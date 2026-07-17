package service

import (
	"context"
	"fmt"
	pb "game/api/app/v1"
	"game/internal/biz"
	"game/internal/conf"
	"game/internal/pkg/middleware/auth"
	"github.com/ethereum/go-ethereum/accounts"
	"github.com/ethereum/go-ethereum/common/hexutil"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/auth/jwt"
	jwt2 "github.com/golang-jwt/jwt/v5"
	"regexp"
	"sync"
	"time"
)

type AppService struct {
	pb.UnimplementedAppServer
	log *log.Helper
	ac  *biz.AppUsecase
	ca  *conf.Auth
}

func NewAppService(ac *biz.AppUsecase, logger log.Logger, ca *conf.Auth) *AppService {
	return &AppService{
		ac:  ac,
		log: log.NewHelper(logger),
		ca:  ca,
	}
}

var ethClient *ethclient.Client

func init() {
	var err error
	ethClient, err = ethclient.Dial("https://bsc-dataseed4.binance.org/")
	if err != nil {
		panic("eth client err")
	}
}

func addressCheck(addressParam string) (bool, error) {
	re := regexp.MustCompile("^0x[0-9a-fA-F]{40}$")
	if !re.MatchString(addressParam) {
		return false, nil
	}

	//var (
	//	err      error
	//	bytecode []byte
	//)
	//
	//if nil == ethClient {
	//	ethClient, err = ethclient.Dial("https://bsc-dataseed4.binance.org/")
	//	if err != nil {
	//		fmt.Println("eth client err")
	//		return false, err
	//	}
	//}
	//
	//// a random user account address
	//address := common.HexToAddress(addressParam)
	//bytecode, err = ethClient.CodeAt(context.Background(), address, nil) // nil is latest block
	//if err != nil {
	//	fmt.Println("eth address err")
	//	return false, err
	//}
	//
	//if len(bytecode) > 0 {
	//	return false, nil
	//}

	return true, nil
}

// TestSign testSign.
func (a *AppService) TestSign(ctx context.Context, req *pb.TestSignRequest) (*pb.TestSignReply, error) {
	privateKey, err := crypto.HexToECDSA(req.Secret)
	if err != nil {
		return &pb.TestSignReply{Sign: ""}, err
	}

	data := []byte(req.SignContent)
	hash := accounts.TextHash(data)

	signature, err := crypto.Sign(hash, privateKey)
	if err != nil {
		return &pb.TestSignReply{Sign: ""}, err
	}

	return &pb.TestSignReply{Sign: string(signature)}, nil
}

type addrCounter struct {
	Count   int
	ResetAt time.Time
}

var (
	mu        sync.Mutex
	addrLimit = make(map[string]*addrCounter)
	window    = 5 * time.Second // 10 秒窗口
	maxInWin  = 20              // 10 秒最多 20 次
)

func allowAddress(addr string) bool {
	now := time.Now()
	mu.Lock()
	defer mu.Unlock()

	c, ok := addrLimit[addr]
	if !ok || now.After(c.ResetAt) {
		// 没有记录，或者窗口过期，重新计数
		addrLimit[addr] = &addrCounter{
			Count:   1,
			ResetAt: now.Add(window),
		}
		return true
	}

	if c.Count >= maxInWin {
		return false
	}

	c.Count++
	return true
}

var (
	muTwo        sync.Mutex
	addrLimitTwo = make(map[string]*addrCounter)
	windowTwo    = 2 * time.Second // 2 秒窗口
	maxInWinTwo  = 4               // 2 秒最多 4 次
)

func allowAddressTwo(addr string) bool {
	now := time.Now()
	muTwo.Lock()
	defer muTwo.Unlock()

	c, ok := addrLimitTwo[addr]
	if !ok || now.After(c.ResetAt) {
		// 没有记录，或者窗口过期，重新计数
		addrLimitTwo[addr] = &addrCounter{
			Count:   1,
			ResetAt: now.Add(windowTwo),
		}
		return true
	}

	if c.Count >= maxInWinTwo {
		return false
	}

	c.Count++
	return true
}

var (
	muThree        sync.Mutex
	addrLimitThree = make(map[string]*addrCounter)
)

func allowAddressThree(addr string) bool {
	now := time.Now()
	muThree.Lock()
	defer muThree.Unlock()

	c, ok := addrLimitThree[addr]
	if !ok || now.After(c.ResetAt) {
		// 没有记录，或者窗口过期，重新计数
		addrLimitThree[addr] = &addrCounter{
			ResetAt: now.Add(1 * time.Second),
		}
		return true
	}

	return false
}

func verifySig(sigHex string, msg []byte) (bool, string) {
	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("签名，捕获到异常:")
		}
	}()

	sig := hexutil.MustDecode(sigHex)

	msg = accounts.TextHash(msg)
	if sig[crypto.RecoveryIDOffset] == 27 || sig[crypto.RecoveryIDOffset] == 28 {
		sig[crypto.RecoveryIDOffset] -= 27 // Transform yellow paper V from 27/28 to 0/1
	}

	recovered, err := crypto.SigToPub(msg, sig)
	if err != nil {
		return false, ""
	}

	recoveredAddr := crypto.PubkeyToAddress(*recovered)

	sigPublicKeyBytes := crypto.FromECDSAPub(recovered)
	signatureNoRecoverID := sig[:len(sig)-1] // remove recovery id
	verified := crypto.VerifySignature(sigPublicKeyBytes, msg, signatureNoRecoverID)
	return verified, recoveredAddr.Hex()
}

// EthAuthorize ethAuthorize.
func (a *AppService) EthAuthorize(ctx context.Context, req *pb.EthAuthorizeRequest) (*pb.EthAuthorizeReply, error) {
	userAddress := req.SendBody.Address // 以太坊账户

	// 验证
	var (
		res bool
		err error
	)
	res, err = addressCheck(userAddress)
	if nil != err {
		return &pb.EthAuthorizeReply{
			Token:  "",
			Status: "地址验证失败",
		}, nil
	}

	if !res {
		return &pb.EthAuthorizeReply{
			Token:  "",
			Status: "地址格式错误",
		}, nil
	}

	if 20 >= len(req.SendBody.Sign) {
		return &pb.EthAuthorizeReply{
			Token:  "",
			Status: "签名错误",
		}, nil
	}

	var (
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(userAddress))
	if !res || addressFromSign != userAddress {
		return &pb.EthAuthorizeReply{
			Token:  "",
			Status: "地址签名错误",
		}, nil
	}

	//if !allowAddress(userAddress) {
	//	// 返回 429 或 503 都行
	//	return nil, nil
	//}

	// 根据地址查询用户，不存在时则创建
	var (
		user *biz.User
		msg  string
	)
	user, err, msg = a.ac.GetExistUserByAddressOrCreate(ctx, userAddress, req)
	if err != nil {
		return &pb.EthAuthorizeReply{
			Token:  "",
			Status: msg,
		}, nil
	}

	claims := auth.CustomClaims{
		Address: user.Address,
		RegisteredClaims: jwt2.RegisteredClaims{
			NotBefore: jwt2.NewNumericDate(time.Now()),                     // 签名的生效时间
			ExpiresAt: jwt2.NewNumericDate(time.Now().Add(48 * time.Hour)), // 2天过期
			Issuer:    "game",
		},
	}

	var (
		token string
	)
	token, err = auth.CreateToken(claims, a.ca.JwtKey)
	if err != nil {
		return &pb.EthAuthorizeReply{
			Token:  "",
			Status: "生成token失败",
		}, nil
	}

	return &pb.EthAuthorizeReply{
		Token:  token,
		Status: "ok",
	}, nil
}

// UserInfo userInfo.
func (a *AppService) UserInfo(ctx context.Context, req *pb.UserInfoRequest) (*pb.UserInfoReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserInfoReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserInfoReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserInfoReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserInfoReply{Status: "无效token"}, nil
	}

	if !allowAddressTwo(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserInfo(ctx, address)
}

// UserBuy userBuy.
func (a *AppService) UserBuy(ctx context.Context, req *pb.UserBuyRequest) (*pb.UserBuyReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserBuyReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserBuyReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserBuyReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserBuyReply{Status: "无效token"}, nil
	}

	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserBuy(ctx, address)
}

// UserRecommend userRecommend.
func (a *AppService) UserRecommend(ctx context.Context, req *pb.UserRecommendRequest) (*pb.UserRecommendReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserRecommendReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserRecommendReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserRecommendReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserRecommendReply{Status: "无效token"}, nil
	}

	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserRecommend(ctx, address, req)
}

// UserRecommendL userRecommendL.
func (a *AppService) UserRecommendL(ctx context.Context, req *pb.UserRecommendLRequest) (*pb.UserRecommendLReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserRecommendLReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserRecommendLReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserRecommendLReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserRecommendLReply{Status: "无效token"}, nil
	}

	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}

	return a.ac.UserRecommendL(ctx, address, req)
}

// UserBuyL UserBuyL.
func (a *AppService) UserBuyL(ctx context.Context, req *pb.UserBuyLRequest) (*pb.UserBuyLReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserBuyLReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserBuyLReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserBuyLReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserBuyLReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserBuyL(ctx, address, req)
}

// UserLand userLand.
func (a *AppService) UserLand(ctx context.Context, req *pb.UserLandRequest) (*pb.UserLandReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserLandReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserLandReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserLandReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserLandReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserLand(ctx, address, req)
}

// UserStakeRewardList userStakeRewardList.
func (a *AppService) UserStakeRewardList(ctx context.Context, req *pb.UserStakeRewardListRequest) (*pb.UserStakeRewardListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserStakeRewardListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserStakeRewardListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserStakeRewardListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserStakeRewardListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserStakeRewardList(ctx, address, req)
}

// UserBoxList userBoxList.
func (a *AppService) UserBoxList(ctx context.Context, req *pb.UserBoxListRequest) (*pb.UserBoxListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserBoxListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserBoxListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserBoxListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserBoxListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserBoxList(ctx, address, req)
}

// UserBackList userBackList.
func (a *AppService) UserBackList(ctx context.Context, req *pb.UserBackListRequest) (*pb.UserBackListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserBackListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserBackListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserBackListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserBackListReply{Status: "无效token"}, nil
	}
	if !allowAddressTwo(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserBackList(ctx, address, req)
}

// UserMarketSeedList userMarketSeedList.
func (a *AppService) UserMarketSeedList(ctx context.Context, req *pb.UserMarketSeedListRequest) (*pb.UserMarketSeedListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserMarketSeedListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserMarketSeedListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserMarketSeedListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserMarketSeedListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserMarketSeedList(ctx, address, req)
}

// UserMarketLandList userMarketLandList.
func (a *AppService) UserMarketLandList(ctx context.Context, req *pb.UserMarketLandListRequest) (*pb.UserMarketLandListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserMarketLandListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserMarketLandListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserMarketLandListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserMarketLandListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserMarketLandList(ctx, address, req)
}

// UserMarketPropList userMarketPropList.
func (a *AppService) UserMarketPropList(ctx context.Context, req *pb.UserMarketPropListRequest) (*pb.UserMarketPropListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserMarketPropListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserMarketPropListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserMarketPropListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserMarketPropListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserMarketPropList(ctx, address, req)
}

// UserMarketRentLandList userMarketRentLandList.
func (a *AppService) UserMarketRentLandList(ctx context.Context, req *pb.UserMarketRentLandListRequest) (*pb.UserMarketRentLandListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserMarketRentLandListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserMarketRentLandListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserMarketRentLandListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserMarketRentLandListReply{Status: "无效token"}, nil
	}
	if !allowAddressTwo(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserMarketRentLandList(ctx, address, req)
}

// UserMyMarketList userMyMarketList.
func (a *AppService) UserMyMarketList(ctx context.Context, req *pb.UserMyMarketListRequest) (*pb.UserMyMarketListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserMyMarketListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		//// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserMyMarketListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserMyMarketListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserMyMarketListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserMyMarketList(ctx, address, req)
}

// UserNoticeList NoticeList.
func (a *AppService) UserNoticeList(ctx context.Context, req *pb.UserNoticeListRequest) (*pb.UserNoticeListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserNoticeListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserNoticeListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserNoticeListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserNoticeListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserNoticeList(ctx, address, req)
}

// UserStakeGitRewardList UserStakeGitRewardList.
func (a *AppService) UserStakeGitRewardList(ctx context.Context, req *pb.UserStakeGitRewardListRequest) (*pb.UserStakeGitRewardListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserStakeGitRewardListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserStakeGitRewardListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserStakeGitRewardListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserStakeGitRewardListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserStakeGitRewardList(ctx, address, req)
}

// UserStakeGitStakeList UserStakeGitStakeList.
func (a *AppService) UserStakeGitStakeList(ctx context.Context, req *pb.UserStakeGitStakeListRequest) (*pb.UserStakeGitStakeListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserStakeGitStakeListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserStakeGitStakeListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserStakeGitStakeListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserStakeGitStakeListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserStakeGitStakeList(ctx, address, req)
}

// UserIndexList UserIndexList.
func (a *AppService) UserIndexList(ctx context.Context, req *pb.UserIndexListRequest) (*pb.UserIndexListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserIndexListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	fmt.Println("这里错误", err)
		//	return &pb.UserIndexListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserIndexListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserIndexListReply{Status: "无效token"}, nil
	}
	if !allowAddressTwo(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserIndexList(ctx, address, req)
}

// UserOrderList  userOrderList.
func (a *AppService) UserOrderList(ctx context.Context, req *pb.UserOrderListRequest) (*pb.UserOrderListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserOrderListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserOrderListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserOrderList(ctx, address, req)
}

// UserRankList  UserRankList.
func (a *AppService) UserRankList(ctx context.Context, req *pb.UserOrderListRequest) (*pb.UserOrderListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserOrderListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserOrderListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserRankList(ctx, address, req)
}

// UserOrderListTwo  userOrderListTwo.
func (a *AppService) UserOrderListTwo(ctx context.Context, req *pb.UserOrderListRequest) (*pb.UserOrderListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserOrderListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserOrderListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.UserOrderListTwo(ctx, address, req)
}

func (a *AppService) UserRewardList(ctx context.Context, req *pb.UserRewardListRequest) (*pb.UserRewardListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserRewardListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserRewardListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}

	return a.ac.UserRewardList(ctx, address, req)
}

func (a *AppService) UserTeamDepositList(ctx context.Context, req *pb.UserTeamDepositListRequest) (*pb.UserTeamDepositListReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.UserTeamDepositListReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.UserOrderListReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.UserTeamDepositListReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}

	return a.ac.UserTeamDepositList(ctx, address, req)
}

func (a *AppService) AddMessage(ctx context.Context, req *pb.AddMessageRequest) (*pb.AddMessageReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.AddMessageReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.BuyBoxReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.BuyBoxReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.AddMessageReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.AddMessageReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.AddMessage(ctx, address, req)
}

func (a *AppService) BuyBox(ctx context.Context, req *pb.BuyBoxRequest) (*pb.BuyBoxReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.BuyBoxReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.BuyBoxReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.BuyBoxReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.BuyBoxReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.BuyBoxReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.BuyBox(ctx, address, req)
}

func (a *AppService) OpenBox(ctx context.Context, req *pb.OpenBoxRequest) (*pb.OpenBoxReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.OpenBoxReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.OpenBoxReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.OpenBoxReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.OpenBoxReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.OpenBoxReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.OpenBox(ctx, address, req)
}

// LandPlay 布置土地
func (a *AppService) LandPlay(ctx context.Context, req *pb.LandPlayRequest) (*pb.LandPlayReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandPlayReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandPlayReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandPlayReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandPlayReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandPlayReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.LandPlay(ctx, address, req)
}

// LandPlayOne 种植
func (a *AppService) LandPlayOne(ctx context.Context, req *pb.LandPlayOneRequest) (*pb.LandPlayOneReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandPlayOneReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandPlayOneReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandPlayOneReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandPlayOneReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandPlayOneReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.LandPlayOne(ctx, address, req)
}

// LandPlayTwo 种植收果实
func (a *AppService) LandPlayTwo(ctx context.Context, req *pb.LandPlayTwoRequest) (*pb.LandPlayTwoReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandPlayTwoReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandPlayTwoReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandPlayTwoReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandPlayTwoReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandPlayTwoReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddressThree(address) {
		// 返回 429 或 503 都行
		return &pb.LandPlayTwoReply{
			Status:    "收获果实中，请勿频繁访问~",
			StatusTwo: "Harvest in progress. Please do not access too frequently.",
		}, nil
	}
	return a.ac.LandPlayTwo(ctx, address, req)
}

func (a *AppService) LandPlayThree(ctx context.Context, req *pb.LandPlayThreeRequest) (*pb.LandPlayThreeReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandPlayThreeReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandPlayThreeReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandPlayThreeReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandPlayThreeReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandPlayThreeReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.LandPlayThree(ctx, address, req)
}

func (a *AppService) LandPlayFour(ctx context.Context, req *pb.LandPlayFourRequest) (*pb.LandPlayFourReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandPlayFourReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandPlayFourReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandPlayFourReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandPlayFourReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandPlayFourReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.LandPlayFour(ctx, address, req)
}

func (a *AppService) LandPlayFive(ctx context.Context, req *pb.LandPlayFiveRequest) (*pb.LandPlayFiveReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandPlayFiveReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandPlayFiveReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandPlayFiveReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandPlayFiveReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandPlayFiveReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.LandPlayFive(ctx, address, req)
}

// LandPlaySix 铲子
func (a *AppService) LandPlaySix(ctx context.Context, req *pb.LandPlaySixRequest) (*pb.LandPlaySixReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandPlaySixReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandPlaySixReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandPlaySixReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandPlaySixReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandPlaySixReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.LandPlaySix(ctx, address, req)
}

// LandPlaySeven 手套
func (a *AppService) LandPlaySeven(ctx context.Context, req *pb.LandPlaySevenRequest) (*pb.LandPlaySevenReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandPlaySevenReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandPlaySevenReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandPlaySevenReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandPlaySevenReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandPlaySevenReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.LandPlaySeven(ctx, address, req)
}

func (a *AppService) Buy(ctx context.Context, req *pb.BuyRequest) (*pb.BuyReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.BuyReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.BuyReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.BuyReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.BuyReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.BuyReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.Buy(ctx, address, req)
}

func (a *AppService) Sell(ctx context.Context, req *pb.SellRequest) (*pb.SellReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.SellReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.SellReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.SellReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.SellReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.SellReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.Sell(ctx, address, req)
}

func (a *AppService) StakeGit(ctx context.Context, req *pb.StakeGitRequest) (*pb.StakeGitReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.StakeGitReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.StakeGitReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.StakeGitReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.StakeGitReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.StakeGitReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.StakeGit(ctx, address, req)
}

// RentLand 出租土地
func (a *AppService) RentLand(ctx context.Context, req *pb.RentLandRequest) (*pb.RentLandReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.RentLandReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.RentLandReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.RentLandReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.RentLandReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.RentLandReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.RentLand(ctx, address, req)
}

// LandAddOutRate 化肥使用在土地
func (a *AppService) LandAddOutRate(ctx context.Context, req *pb.LandAddOutRateRequest) (*pb.LandAddOutRateReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.LandAddOutRateReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.LandAddOutRateReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.LandAddOutRateReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.LandAddOutRateReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.LandAddOutRateReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.LandAddOutRate(ctx, address, req)
}

// GetLand 土地合成
func (a *AppService) GetLand(ctx context.Context, req *pb.GetLandRequest) (*pb.GetLandReply, error) {
	return &pb.GetLandReply{Status: "暂未开放"}, nil

	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.GetLandReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.GetLandReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.GetLandReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.GetLandReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.GetLandReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.GetLand(ctx, address, req)
}

// StakeGet 放大器质解压
func (a *AppService) StakeGet(ctx context.Context, req *pb.StakeGetRequest) (*pb.StakeGetReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.StakeGetReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.StakeGetReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.StakeGetReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.StakeGetReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.StakeGetReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.StakeGet(ctx, address, req)
}

// StakeGetPlay 玩放大器
func (a *AppService) StakeGetPlay(ctx context.Context, req *pb.StakeGetPlayRequest) (*pb.StakeGetPlayReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.StakeGetPlayReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.StakeGetPlayReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.StakeGetPlayReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.StakeGetPlayReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.StakeGetPlayReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.StakeGetPlay(ctx, address, req)
}

// Exchange 兑换
func (a *AppService) Exchange(ctx context.Context, req *pb.ExchangeRequest) (*pb.ExchangeReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.ExchangeReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.ExchangeReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.ExchangeReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.ExchangeReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.ExchangeReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.Exchange(ctx, address, req)
}

// ToAmount 兑换
func (a *AppService) ToAmount(ctx context.Context, req *pb.ToAmountRequest) (*pb.ToAmountReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.ToAmountReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.ExchangeReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.ExchangeReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.ToAmountReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.ToAmountReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.ToAmount(ctx, address, req)
}

// BuyTwo 已删除的认购功能
func (a *AppService) BuyTwo(ctx context.Context, req *pb.BuyTwoRequest) (*pb.BuyTwoReply, error) {
	return &pb.BuyTwoReply{Status: "无效"}, nil

	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.BuyTwoReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.BuyTwoReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.BuyTwoReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.BuyTwoReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.BuyTwoReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.BuyTwo(ctx, address, req)
}

func (a *AppService) Withdraw(ctx context.Context, req *pb.WithdrawRequest) (*pb.WithdrawReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.WithdrawReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.WithdrawReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.WithdrawReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.WithdrawReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.WithdrawReply{
			Status: "地址签名错误",
		}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.Withdraw(ctx, address, req)
}

func (a *AppService) SetGiw(ctx context.Context, req *pb.SetGiwRequest) (*pb.SetGiwReply, error) {
	return a.ac.SetGiw(ctx, req)
}

func (a *AppService) SetGit(ctx context.Context, req *pb.SetGitRequest) (*pb.SetGitReply, error) {
	return a.ac.SetGit(ctx, req)
}

func (a *AppService) SetLand(ctx context.Context, req *pb.SetLandRequest) (*pb.SetLandReply, error) {
	return a.ac.SetLand(ctx, req)
}

// SetBuyLand 定时任务处理竞拍结果
func (a *AppService) SetBuyLand(ctx context.Context, req *pb.SetBuyLandRequest) (*pb.SetBuyLandReply, error) {
	return a.ac.SetBuyLand(ctx, req)
}

// GetBuyLand 当前竞拍信息
func (a *AppService) GetBuyLand(ctx context.Context, req *pb.GetBuyLandRequest) (*pb.GetBuyLandReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.GetBuyLandReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.GetBuyLandReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.GetBuyLandReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.GetBuyLandReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.GetBuyLand(ctx, address, req)
}

// BuyLandRecord 竞拍记录
func (a *AppService) BuyLandRecord(ctx context.Context, req *pb.BuyLandRecordRequest) (*pb.BuyLandRecordReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.BuyLandRecordReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.BuyLandRecordReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.BuyLandRecordReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.BuyLandRecordReply{Status: "无效token"}, nil
	}
	if !allowAddress(address) {
		// 返回 429 或 503 都行
		return nil, nil
	}
	return a.ac.BuyLandRecord(ctx, address, req)
}

// BuyLand 竞拍土地
func (a *AppService) BuyLand(ctx context.Context, req *pb.BuyLandRequest) (*pb.BuyLandReply, error) {
	// 在上下文 context 中取出 claims 对象
	var (
		address string
	)
	if claims, ok := jwt.FromContext(ctx); ok {
		c := claims.(jwt2.MapClaims)
		if c["Address"] == nil {
			return &pb.BuyLandReply{Status: "无效token"}, nil
		}

		address = c["Address"].(string)

		// 验证
		//var (
		//	res bool
		//	err error
		//)
		//res, err = addressCheck(address)
		//if nil != err {
		//	return &pb.BuyLandReply{Status: "无效token"}, nil
		//}
		//
		//if !res {
		//	return &pb.BuyLandReply{Status: "无效token"}, nil
		//}
	} else {
		return &pb.BuyLandReply{Status: "无效token"}, nil
	}

	var (
		res             bool
		addressFromSign string
	)
	res, addressFromSign = verifySig(req.SendBody.Sign, []byte(address))
	if !res || addressFromSign != address {
		return &pb.BuyLandReply{
			Status: "地址签名错误",
		}, nil
	}

	return a.ac.BuyLand(ctx, address, req)
}

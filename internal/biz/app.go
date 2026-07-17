package biz

import (
	"context"
	"crypto/rand"
	"encoding/json"
	"fmt"
	pb "game/api/app/v1"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/go-kratos/kratos/v2/errors"
	"github.com/go-kratos/kratos/v2/log"
	"math"
	"math/big"
	rand2 "math/rand"
	"net/http"
	"strconv"
	"strings"
	"sync"
	"time"
)

type Pagination struct {
	PageNum  int
	PageSize int
}

type User struct {
	ID               uint64
	Address          string
	Level            uint64
	Giw              float64
	GiwTwo           float64
	GiwAdd           float64
	Git              float64
	Total            float64
	TotalOne         float64
	TotalTwo         float64
	TotalThree       float64
	RewardOne        float64
	RewardTwo        float64
	RewardThree      float64
	RewardTwoOne     float64
	RewardTwoTwo     float64
	RewardTwoThree   float64
	RewardThreeOne   float64
	RewardThreeTwo   float64
	RewardThreeThree float64
	Location         float64
	Recommend        float64
	RecommendTwo     float64
	Area             float64
	AreaTwo          float64
	All              float64
	Amount           float64
	AmountGet        float64
	AmountUsdt       float64
	AmountUsdtTotal  float64
	GitNew           float64
	MyTotalAmount    float64
	MyTotalAmountNew float64
	UsdtTwo          float64
	OutNum           uint64
	Vip              uint64
	VipAdmin         uint64
	LockUse          uint64
	LockReward       uint64
	CreatedAt        time.Time
	UpdatedAt        time.Time
	CanSell          uint64
	CanRent          uint64
	CanLand          uint64
	WithdrawMax      uint64
	CanSellProp      uint64
	CanPlayAdd       uint64
	CanPlaySix       uint64
	One              float64
	Two              float64
	Three            float64
	IspayAmount      float64
	StakeIspayAmount float64
	OpenBoxAmount    float64
	GitNewNew        float64
}

type BoxRecord struct {
	ID        uint64
	UserId    uint64
	Num       uint64
	GoodId    uint64
	GoodType  uint64
	CreatedAt time.Time
	UpdatedAt time.Time
	Content   string
}

type UserRecommend struct {
	ID            uint64
	UserId        uint64
	RecommendCode string
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

type Config struct {
	ID      int64
	KeyName string
	Name    string
	Value   string
}

type StakeGit struct {
	ID        uint64
	UserId    uint64
	Status    uint64
	Amount    float64
	Reward    float64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type Reward struct {
	ID        uint64
	UserId    uint64
	Reason    uint64
	One       uint64
	Two       uint64
	Three     float64
	Amount    float64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type EthRecordTwo struct {
	ID            uint64
	UserId        uint64
	Amount        uint64
	Last          uint64
	Address       string
	Coin          string
	RecommendCode string
	CreatedAt     time.Time
	UpdatedAt     time.Time
}

type RewardTwo struct {
	ID        uint64
	UserId    uint64
	Reason    uint64
	One       uint64
	Two       uint64
	Three     float64
	Amount    float64
	Four      string
	Five      float64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type Seed struct {
	ID           uint64
	UserId       uint64
	SeedId       uint64
	Name         string
	OutAmount    float64
	OutOverTime  uint64
	OutMaxAmount float64
	OutMinAmount float64
	Status       uint64
	SellAmount   float64
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

type PropInfo struct {
	ID       uint64
	PropType uint64

	// 化肥相关字段
	OneOne uint64
	OneTwo uint64

	// 铲子相关字段
	TwoOne uint64
	TwoTwo float64

	// 水相关字段
	ThreeOne uint64

	// 除虫剂相关字段
	FourOne uint64

	// 手套相关字段
	FiveOne uint64
	GetRate float64

	// 时间字段
	CreatedAt time.Time
	UpdatedAt time.Time
}

type SeedInfo struct {
	ID           uint64
	Name         string
	OutMinAmount float64
	OutMaxAmount float64
	GetRate      float64
	OutOverTime  uint64
	CreatedAt    time.Time
	UpdatedAt    time.Time
}

type Land struct {
	ID             uint64
	UserId         uint64
	Level          uint64
	OutPutRate     float64
	RentOutPutRate float64
	MaxHealth      uint64
	PerHealth      uint64
	LimitDate      uint64
	Status         uint64
	LocationNum    uint64
	CreatedAt      time.Time
	UpdatedAt      time.Time
	One            uint64
	Two            uint64
	Three          uint64
	AdminAdd       uint64
	SellAmount     float64
	LocationUserId uint64
	CanReward      uint64
}

type LandInfo struct {
	ID                uint64
	Level             uint64
	OutPutRateMax     float64
	OutPutRateMin     float64
	RentOutPutRateMax float64
	MaxHealth         uint64
	PerHealth         uint64
	LimitDateMax      uint64
	CreatedAt         time.Time
	UpdatedAt         time.Time
}

type LandUserUse struct {
	ID           uint64
	LandId       uint64
	Level        uint64
	UserId       uint64
	OwnerUserId  uint64
	SeedId       uint64
	SeedTypeId   uint64
	Status       uint64
	BeginTime    uint64
	TotalTime    uint64
	OverTime     uint64
	OutMaxNum    float64
	OutNum       float64
	InsectStatus uint64
	OutSubNum    float64
	StealNum     float64
	StopStatus   uint64
	StopTime     uint64
	SubTime      uint64
	UseChan      uint64
	CreatedAt    time.Time
	UpdatedAt    time.Time
	One          uint64
	Two          uint64
	IsUseOther   uint64
}

type Message struct {
	ID        uint64
	Content   string
	UserId    uint64
	Status    uint64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type AdminMessage struct {
	ID         uint64
	Content    string
	ContentTwo string
	Status     uint64
	CreatedAt  time.Time
	UpdatedAt  time.Time
}

type ExchangeRecord struct {
	ID        uint64
	UserId    int64
	Git       float64
	Giw       float64
	Fee       float64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type Market struct {
	ID        uint64
	UserId    uint64
	GoodId    uint64
	GoodType  int
	Amount    float64
	Status    int
	GetUserId uint64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type Notice struct {
	ID               uint64
	UserId           uint64
	NoticeContent    string
	NoticeContentTwo string
	CreatedAt        time.Time
	UpdatedAt        time.Time
}

type Prop struct {
	ID         uint64
	UserId     uint64
	Status     int
	PropType   int
	OneOne     int
	OneTwo     int
	TwoOne     int
	TwoTwo     float64
	SellAmount float64
	ThreeOne   int
	FourOne    int
	FiveOne    int
	CreatedAt  time.Time
	UpdatedAt  time.Time
}

type StakeGet struct {
	ID        uint64
	UserId    uint64
	Status    int
	StakeRate float64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type StakeGetPlayRecord struct {
	ID        uint64
	UserId    uint64
	Amount    float64
	Reward    float64
	Status    int
	CreatedAt time.Time
	UpdatedAt time.Time
}

type StakeGetRecord struct {
	ID        uint64
	UserId    uint64
	Amount    float64
	StakeRate float64
	Total     float64
	StakeType int
	CreatedAt time.Time
	UpdatedAt time.Time
}

type StakeGetTotal struct {
	ID        uint64
	Amount    float64
	Balance   float64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type StakeGitRecord struct {
	ID        uint64
	UserId    uint64
	Amount    float64
	AmountTwo float64
	StakeType int
	Day       uint64
	CreatedAt time.Time
	UpdatedAt time.Time
}

type Withdraw struct {
	ID             uint64
	UserID         uint64
	Amount         uint64
	RelAmount      uint64
	AmountFloat    float64
	RelAmountFloat float64
	Status         string
	CreatedAt      time.Time
	UpdatedAt      time.Time
}

type BuyLand struct {
	ID        uint64
	Amount    float64
	Status    uint64
	CreatedAt time.Time
	UpdatedAt time.Time
	AmountTwo float64
	Limit     uint64
	Level     uint64
}

type Exchange struct {
	ID              uint64
	UserId          uint64
	AmountFloat     float64
	AmountFloatUsdt float64
	RelAmountFloat  float64
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

type RandomSeed struct {
	ID        uint64
	Scene     uint64
	SeedValue uint64
	UpdatedAt time.Time
	CreatedAt time.Time
}

type BuyLandRecord struct {
	ID        uint64
	BuyLandID uint64
	Amount    float64
	CreatedAt time.Time
	UpdatedAt time.Time
	Status    uint64
	UserID    uint64
}

type UserRepo interface {
	GetAllUsers(ctx context.Context) ([]*User, error)
	GetUserByUserIds(ctx context.Context, userIds []uint64) (map[uint64]*User, error)
	GetUserByAddress(ctx context.Context, address string) (*User, error)
	GetTodayUserCount(ctx context.Context) (int64, error)
	GetTodayUserWithdrawCount(ctx context.Context, userId uint64) (int64, error)
	GetUserById(ctx context.Context, id uint64) (*User, error)
	GetUserRecommendByUserId(ctx context.Context, userId uint64) (*UserRecommend, error)
	GetUserRecommendByCode(ctx context.Context, code string) ([]*UserRecommend, error)
	GetMessages(ctx context.Context) ([]*Message, error)
	GetAdminMessages(ctx context.Context) ([]*AdminMessage, error)
	GetMessagesCount(ctx context.Context, userId uint64) (int64, error)
	CreateMessages(ctx context.Context, userId uint64, content string) error
	GetUserRecommendLikeCode(ctx context.Context, code string) ([]*UserRecommend, error)
	GetUserRecommends(ctx context.Context) ([]*UserRecommend, error)
	CreateUser(ctx context.Context, uc *User) (*User, error)
	CreateStakeGet(ctx context.Context, sg *StakeGet) error
	CreateStakeGit(ctx context.Context, sg *StakeGit) error
	CreateNotice(ctx context.Context, userId uint64, content string, contentTwo string) error
	CreateUserRecommend(ctx context.Context, user *User, recommendUser *UserRecommend) (*UserRecommend, error)
	GetConfigByKeys(ctx context.Context, keys ...string) ([]*Config, error)
	GetStakeGitByUserId(ctx context.Context, userId uint64) (*StakeGit, error)
	GetBoxRecord(ctx context.Context, num uint64) ([]*BoxRecord, error)
	GetBoxRecordByUserId(ctx context.Context, userId uint64) ([]*BoxRecord, error)
	GetBoxRecordCount(ctx context.Context, num uint64) (int64, error)
	GetUserBoxRecord(ctx context.Context, userId, num uint64, b *Pagination) ([]*BoxRecord, error)
	GetUserBoxRecordOpenCount(ctx context.Context, userId uint64) (int64, error)
	GetUserBoxRecordOpen(ctx context.Context, userId, num uint64, open bool, b *Pagination) ([]*BoxRecord, error)
	GetStakeGetTotal(ctx context.Context) (*StakeGetTotal, error)
	GetUserStakeGet(ctx context.Context, userId uint64) (*StakeGet, error)
	GetTotalStakeRate(ctx context.Context) (float64, error)
	GetUserRecommendCount(ctx context.Context, code string) (int64, error)
	GetUserRecommendByCodePage(ctx context.Context, code string, b *Pagination) ([]*UserRecommend, error)
	GetLandByUserIDUsing(ctx context.Context, userID uint64, status []uint64) ([]*Land, error)
	GetLandByLocationUserIDUsing(ctx context.Context, userID uint64, status []uint64) ([]*Land, error)
	GetLandByUserID(ctx context.Context, userID uint64, status []uint64, b *Pagination) ([]*Land, error)
	GetLandByUserIDCount(ctx context.Context, userID uint64, status []uint64) (int64, error)
	GetLandByExUserID(ctx context.Context, userID uint64, status []uint64, b *Pagination) ([]*Land, error)
	GetLandByExUserIDCount(ctx context.Context, userID uint64, status []uint64) (int64, error)
	GetLandByExUserIDOrdeSellAmount(ctx context.Context, userID uint64, status []uint64, b *Pagination) ([]*Land, error)
	GetLandByExUserIDByIds(ctx context.Context, ids []uint64, b *Pagination) ([]*Land, error)
	GetUserRewardPage(ctx context.Context, userId uint64, reason []uint64, b *Pagination) ([]*Reward, error)
	GetUserRewardTwoPage(ctx context.Context, userId uint64, reason uint64, b *Pagination) ([]*RewardTwo, error)
	GetUserRewardPageCount(ctx context.Context, userId uint64, reason []uint64) (int64, error)
	GetUserRewardTwoPageCount(ctx context.Context, userId uint64, reason uint64) (int64, error)
	GetSeedByUserID(ctx context.Context, userID uint64, status []uint64, b *Pagination) ([]*Seed, error)
	GetSeedByUserIDCount(ctx context.Context, status []uint64, userID uint64) (int64, error)
	GetSeedByExUserID(ctx context.Context, userID uint64, status []uint64, b *Pagination) ([]*Seed, error)
	GetSeedByExUserIDCount(ctx context.Context, status []uint64, userID uint64) (int64, error)
	GetLandUserUseByUserIDUseing(ctx context.Context, userID uint64, status uint64, b *Pagination) ([]*LandUserUse, error)
	GetLandUserUseOrderByTime(ctx context.Context, b *Pagination) ([]*LandUserUse, error)
	GetLandUserUseOrderByTimeCount(ctx context.Context) (int64, error)
	GetExchangeRecordsByUserID(ctx context.Context, userID uint64, b *Pagination) ([]*ExchangeRecord, error)
	GetLandUserUseByID(ctx context.Context, id uint64) (*LandUserUse, error)
	GetMarketRecordsByUserID(ctx context.Context, userID uint64, status uint64, b *Pagination) ([]*Market, error)
	GetNoticesByUserID(ctx context.Context, userID uint64, b *Pagination) ([]*Notice, error)
	GetNoticesCountByUserID(ctx context.Context, userID uint64) (int64, error)
	GetPropsByUserIDCount(ctx context.Context, status []uint64, userID uint64, propType uint64) (int64, error)
	GetPropsByUserID(ctx context.Context, userID uint64, status []uint64, propType uint64, b *Pagination) ([]*Prop, error)
	GetPropsByUserIDPropType(ctx context.Context, userID uint64, propType []uint64) ([]*Prop, error)
	GetPropsByExUserIDCount(ctx context.Context, status []uint64, userID uint64, propType uint64) (int64, error)
	GetPropsByExUserID(ctx context.Context, userID uint64, status []uint64, b *Pagination, propType uint64) ([]*Prop, error)
	GetStakeGetsByUserID(ctx context.Context, userID uint64, b *Pagination) ([]*StakeGet, error)
	GetStakeGetPlayRecordsByUserID(ctx context.Context, userID uint64, status uint64, b *Pagination) ([]*StakeGetPlayRecord, error)
	GetStakeGetPlayRecordCount(ctx context.Context, userID uint64, status uint64) (int64, error)
	GetStakeGetRecordsByUserID(ctx context.Context, userID int64, b *Pagination) ([]*StakeGetRecord, error)
	GetStakeGitByUserID(ctx context.Context, userID int64) (*StakeGit, error)
	GetStakeGitRecordsByUserID(ctx context.Context, userID uint64, b *Pagination) ([]*StakeGitRecord, error)
	GetStakeGitRecordsByID(ctx context.Context, id, userId uint64) (*StakeGitRecord, error)
	GetWithdrawTodayRecordsByUserID(ctx context.Context, userID uint64, coinType string) ([]*Withdraw, error)
	GetExchangeTodayRecordsByUserID(ctx context.Context, userID uint64) ([]*Exchange, error)
	WithdrawThree(ctx context.Context, userId uint64, usdt, relUsdt float64) error
	GetWithdrawRecordsByUserID(ctx context.Context, userID int64, b *Pagination) ([]*Withdraw, error)
	GetUserOrderCount(ctx context.Context) (int64, error)
	GetUserOrder(ctx context.Context, b *Pagination, address string) ([]*User, error)
	GetLandUserUseByLandIDsMapUsing(ctx context.Context, userId uint64, landIDs []uint64) (map[uint64]*LandUserUse, error)
	GetLandMyUseByLandIDsMapUsing(ctx context.Context, userId uint64) (map[uint64]*LandUserUse, error)
	GetLandUserUseByLandIDsUsing(ctx context.Context, userId uint64) ([]*LandUserUse, error)
	BuyBox(ctx context.Context, giw float64, originValue, value string, uc *BoxRecord) (uint64, error)
	BuyLandReward(ctx context.Context, userId, landId uint64, giw float64) error
	GetUserBoxRecordById(ctx context.Context, id uint64) (*BoxRecord, error)
	OpenBoxSeed(ctx context.Context, id, userId uint64, content string, amount float64, seedInfo *Seed) (uint64, error)
	OpenBoxProp(ctx context.Context, id, userId uint64, content string, amount float64, propInfo *Prop) (uint64, error)
	GetAllSeedInfo(ctx context.Context) ([]*SeedInfo, error)
	GetAllPropInfo(ctx context.Context) ([]*PropInfo, error)
	GetAllRandomSeeds(ctx context.Context) ([]*RandomSeed, error)
	UpdateSeedValue(ctx context.Context, scene uint64, newSeed uint64) error
	GetSeedByID(ctx context.Context, seedID, userId, status uint64) (*Seed, error)
	GetLandByID(ctx context.Context, landID uint64) (*Land, error)
	GetLandByIDTwo(ctx context.Context, landID uint64) (*Land, error)
	GetLandByUserIdLocationNum(ctx context.Context, userId uint64, locationNum uint64) (*Land, error)
	GetLandByUserIdLocationUserId(ctx context.Context, locationNum, locationUserId uint64) (*Land, error)
	Plant(ctx context.Context, status, originStatus, perHealth uint64, landUserUse *LandUserUse) error
	PlantPlatTwo(ctx context.Context, id, landId uint64, rent bool) error
	PlantPlatThree(ctx context.Context, id, overTime, propId uint64, one, two bool) error
	PlantPlatFour(ctx context.Context, outMax float64, id, propId, propStatus, propNum uint64) error
	PlantPlatFive(ctx context.Context, overTime, id, propId, propStatus, propNum uint64) error
	PlantPlatSix(ctx context.Context, id, propId, propStatus, propNum, landId uint64) error
	GetTodayRewardPlantPlatSevenUserWithdrawCount(ctx context.Context, userId uint64) (int64, error)
	PlantPlatSeven(ctx context.Context, outMax, amount float64, subTime, lastTime, id, propId, propStatus, propNum, userId uint64) error
	PlantPlatTwoTwo(ctx context.Context, id, userId, rentUserId uint64, amount, ispay, rentAmount, ispayRent float64) error
	PlantPlatTwoTwoL(ctx context.Context, id, userId, lowUserId, num uint64, amount, ispay float64) error
	PlantPlatTwoTwoLL(ctx context.Context, userId, lowUserId, num uint64, amount float64) error
	GetSeedBuyByID(ctx context.Context, seedID, status uint64) (*Seed, error)
	GetPropByID(ctx context.Context, propID, status uint64) (*Prop, error)
	GetPropByIDTwo(ctx context.Context, propID uint64) (*Prop, error)
	BuySeed(ctx context.Context, git, getGit float64, userId, userIdGet, seedId uint64) error
	BuyLand(ctx context.Context, git, getGit float64, userId, userIdGet, landId uint64) error
	BuyProp(ctx context.Context, git, getGit float64, userId, userIdGet, propId uint64) error
	SellLand(ctx context.Context, propId uint64, userId uint64, sellAmount float64) error
	SellProp(ctx context.Context, propId uint64, userId uint64, sellAmount float64) error
	SellSeed(ctx context.Context, seedId uint64, userId uint64, sellAmount float64) error
	GetPropByIDSell(ctx context.Context, propID, status uint64) (*Prop, error)
	UnSellLand(ctx context.Context, propId uint64, userId uint64) error
	UnSellProp(ctx context.Context, propId uint64, userId uint64) error
	UnSellSeed(ctx context.Context, seedId, userId uint64) error
	RentLand(ctx context.Context, landId uint64, userId uint64, rentRate float64) error
	UnRentLand(ctx context.Context, landId uint64, userId uint64) error
	LandPull(ctx context.Context, landId uint64, userId uint64) error
	LandPullTwo(ctx context.Context, landId uint64, userId uint64) error
	LandPush(ctx context.Context, landId uint64, userId, locationUserId, locationNum uint64) error
	LandAddOutRate(ctx context.Context, id, landId, userId uint64) error
	PropStatusThree(ctx context.Context, id uint64) error
	CreateLand(ctx context.Context, lc *Land) (*Land, error)
	GetLand(ctx context.Context, id, id2, userId uint64) error
	GetLandInfoByLevels(ctx context.Context) (map[uint64]*LandInfo, error)
	SetGiw(ctx context.Context, address string, giw uint64) error
	SetGit(ctx context.Context, address string, git uint64) error
	SetStakeGetTotal(ctx context.Context, amount, balance float64) error
	SetStakeGetTotalSub(ctx context.Context, amount, balance float64) error
	SetStakeGet(ctx context.Context, userId uint64, git, amount float64) error
	SetStakeGetSub(ctx context.Context, userId uint64, git, amount float64) error
	SetStakeGetPlaySub(ctx context.Context, userId uint64, amount float64) error
	SetStakeGetPlay(ctx context.Context, userId uint64, git, amount float64) error
	SetStakeGit(ctx context.Context, userId uint64, amount, amountTwo, usdtAmountOrigin, price float64, day uint64) error
	GetStakeGitRecordsByUserIDQueue(ctx context.Context, userID uint64, b *Pagination) ([]*StakeGitRecord, error)
	GetStakeGitRecordsByUserIDQueueCount(ctx context.Context, userId uint64) (int64, error)
	GetStakeGitRecordsByUserIDQueueToday(ctx context.Context) (float64, error)
	SetUnStakeGit(ctx context.Context, id, userId uint64, amount float64) error
	Exchange(ctx context.Context, userId uint64, git, giw float64) error
	Transfer(ctx context.Context, userId, toUserId uint64, amountUsdt float64) error
	ExchangeTwo(ctx context.Context, userId uint64, git, giw float64) error
	ExchangeNew(ctx context.Context, userId uint64, git, gitRel, amountUsdt float64) error
	ExchangeThree(ctx context.Context, userId uint64, git, giw float64) error
	Withdraw(ctx context.Context, userId uint64, giw, relGiw float64) error
	WithdrawTwo(ctx context.Context, userId uint64, usdt, relUsdt float64) error
	GetAllBuyLandRecords(ctx context.Context, id uint64) ([]*BuyLandRecord, error)
	GetBuyLandById(ctx context.Context) (*BuyLand, error)
	CreateBuyLandRecord(ctx context.Context, limit uint64, bl *BuyLandRecord) error
	CreateBuyLandRecordOne(ctx context.Context, bl *BuyLandRecord) error
	GetSetBuyLandById(ctx context.Context) (*BuyLand, error)
	BackUserGit(ctx context.Context, userId, id uint64, git float64) error
	SetBuyLandOver(ctx context.Context, id uint64) error
	UpdateUserNewTwoNew(ctx context.Context, userId uint64, amount, giw float64, amountUsdt uint64) error
	UpdateUserMyTotalAmount(ctx context.Context, userId uint64, amount float64) error
	UpdateUserMyTotalAmountSub(ctx context.Context, userId int64, amount float64) error
	UpdateUserRewardRecommend2(ctx context.Context, userId uint64, giw, giw2, usdt float64, amountOrigin float64, stop bool, address string) error
	GetRewardByTwo(ctx context.Context, twoIds []uint64, userId uint64) (map[uint64]*Reward, error)
	GetUserRewardFourT(ctx context.Context, userId uint64) (float64, error)
	GetUserRewardFour(ctx context.Context, userId uint64) (float64, error)
	GetSumEthTwo(ctx context.Context) (uint64, error)
	GetSumEthTwoThree(ctx context.Context) (uint64, error)
	GetSumEthTwoFour(ctx context.Context) (uint64, error)
	GetUsersLimitUsdtTotal(ctx context.Context) ([]*User, error)
	GetUserRewardAdminPageCount(ctx context.Context, userId uint64, reason uint64) (int64, error)
	GetUserRewardAdminPage(ctx context.Context, userId uint64, reason uint64, b *Pagination) ([]*Reward, error)
	GetRecordPageTwo(ctx context.Context, recommendCode string, b *Pagination) ([]*EthRecordTwo, error)
	GetRecordPageCountTwo(ctx context.Context, recommendCode string) (int64, error)
}

// AppUsecase is an app usecase.
type AppUsecase struct {
	userRepo UserRepo
	tx       Transaction
	log      *log.Helper
}

// NewAppUsecase new a app usecase.
func NewAppUsecase(userRepo UserRepo, tx Transaction, logger log.Logger) *AppUsecase {
	return &AppUsecase{userRepo: userRepo, tx: tx, log: log.NewHelper(logger)}
}

func RandomBoolCrypto() (bool, error) {
	n, err := rand.Int(rand.Reader, big.NewInt(100))
	if err != nil {
		return false, err
	}
	return n.Int64() < 5, nil
}

func (ac *AppUsecase) GetExistUserByAddressOrCreate(ctx context.Context, address string, req *pb.EthAuthorizeRequest) (*User, error, string) {
	var (
		user            *User
		rURecommendUser *UserRecommend
		err             error
		count           int64
	)

	count, err = ac.userRepo.GetTodayUserCount(ctx)
	if err != nil || count > 10000 {
		return nil, errors.New(500, "USER_ERROR", "达到系统24小时可注册人数上限"), "达到系统24小时可注册人数上限"
	}

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil == user || nil != err {
		code := req.SendBody.Code
		if 0 >= len(code) {
			return nil, errors.New(500, "USER_ERROR", "errcode"), "errcode"
		}

		if "abf00dd52c08a9213f225827bc3fb100" != code {
			if 1 >= len(code) {
				return nil, errors.New(500, "USER_ERROR", "无效的推荐码1"), "无效的推荐码"
			}

			var (
				rUser *User
			)

			rUser, err = ac.userRepo.GetUserByAddress(ctx, code)
			if nil == rUser || err != nil {
				return nil, errors.New(500, "USER_ERROR", "无效的推荐码1"), "无效的推荐码"
			}

			//if 0 >= rUser.GiwAdd {
			//	return nil, errors.New(500, "USER_ERROR", "推荐人未入金"), "推荐人未入金"
			//}

			// 查询推荐人的相关信息
			rURecommendUser, err = ac.userRepo.GetUserRecommendByUserId(ctx, rUser.ID)
			if nil == rURecommendUser || err != nil {
				return nil, errors.New(500, "USER_ERROR", "无效的推荐码3"), "无效的推荐码3"
			}
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			user, err = ac.userRepo.CreateUser(ctx, &User{
				Address: address,
			})
			if err != nil {
				return err
			}

			_, err = ac.userRepo.CreateUserRecommend(ctx, user, rURecommendUser) // 创建用户推荐信息
			if err != nil {
				return err
			}

			err = ac.userRepo.CreateStakeGet(ctx, &StakeGet{
				UserId: user.ID,
			})
			if err != nil {
				return err
			}

			//err = ac.userRepo.CreateStakeGit(ctx, &StakeGit{
			//	UserId: user.ID,
			//})
			//if err != nil {
			//	return err
			//}

			return nil
		}); err != nil {
			return nil, err, "错误"
		}
	}

	if 1 == user.LockUse {
		return user, errors.New(500, "USER_ERROR", "锁定用户"), "锁定用户"
	}

	return user, nil, ""
}

func (ac *AppUsecase) UserBuy(ctx context.Context, address string) (*pb.UserBuyReply, error) {
	var (
		user *User
		err  error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserBuyReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.UserBuyReply{
			Status: "锁定用户",
		}, nil
	}

	var (
		configs []*Config
		uPrice  float64
	)

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"u_price",
	)
	if nil != err || nil == configs {
		return &pb.UserBuyReply{
			Status: "配置错误",
		}, nil
	}
	for _, vConfig := range configs {
		if "u_price" == vConfig.KeyName {
			uPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	// 推荐
	var (
		userRecommend   *UserRecommend
		myUserRecommend []*UserRecommend
		team            []*UserRecommend
	)
	userRecommend, err = ac.userRepo.GetUserRecommendByUserId(ctx, user.ID)
	if nil == userRecommend || nil != err {
		return &pb.UserBuyReply{
			Status: "推荐错误查询",
		}, nil
	}

	myUserRecommend, err = ac.userRepo.GetUserRecommendByCode(ctx, userRecommend.RecommendCode+"D"+strconv.FormatUint(user.ID, 10))
	if nil == myUserRecommend || nil != err {
		return &pb.UserBuyReply{
			Status: "推荐错误查询",
		}, nil
	}

	team, err = ac.userRepo.GetUserRecommendLikeCode(ctx, userRecommend.RecommendCode+"D"+strconv.FormatUint(user.ID, 10))
	if nil != err {
		return &pb.UserBuyReply{
			Status: "推荐错误查询",
		}, nil
	}

	var (
		users    []*User
		usersMap map[uint64]*User
	)
	users, err = ac.userRepo.GetAllUsers(ctx)
	if nil == users {
		return &pb.UserBuyReply{
			Status: "错误",
		}, nil
	}

	usersMap = make(map[uint64]*User, 0)
	for _, vUsers := range users {
		usersMap[vUsers.ID] = vUsers
	}

	// 获取业绩
	tmpAreaMax := float64(0)
	tmpAreaMin := float64(0)
	tmpMaxId := uint64(0)
	tmpTwelve := float64(0)
	tmpRecommendNum := uint64(0)
	for _, vMyLowUser := range myUserRecommend {
		if _, ok := usersMap[vMyLowUser.ID]; !ok {
			continue
		}

		tmpTwelve += usersMap[vMyLowUser.UserId].MyTotalAmount
		tmpRecommendNum += 1
		if tmpAreaMax < usersMap[vMyLowUser.UserId].MyTotalAmount+usersMap[vMyLowUser.UserId].Amount {
			tmpAreaMax = usersMap[vMyLowUser.UserId].MyTotalAmount + usersMap[vMyLowUser.UserId].Amount
			tmpMaxId = vMyLowUser.ID
		}
	}

	if 0 < tmpMaxId {
		for _, vMyLowUser := range myUserRecommend {
			if _, ok := usersMap[vMyLowUser.ID]; !ok {
				continue
			}

			if tmpMaxId != vMyLowUser.ID {
				tmpAreaMin += usersMap[vMyLowUser.UserId].MyTotalAmount + usersMap[vMyLowUser.UserId].Amount
			}
		}
	}

	tmpLevel := uint64(0)
	if 0 < user.Vip {
		tmpLevel = user.Vip
	} else {
		if 1000000 <= tmpAreaMin {
			tmpLevel = 5
		} else if 500000 <= tmpAreaMin {
			tmpLevel = 4
		} else if 150000 <= tmpAreaMin {
			tmpLevel = 3
		} else if 50000 <= tmpAreaMin {
			tmpLevel = 2
		} else if 10000 <= tmpAreaMin {
			tmpLevel = 1
		}
	}

	tmpBuyNum := uint64(0)
	for _, v := range team {
		if _, ok := usersMap[v.UserId]; !ok {
			continue
		}

		if 0 >= usersMap[v.UserId].OutNum && 0 >= usersMap[v.UserId].Amount {
			continue
		}

		tmpBuyNum++
	}

	tmpFour := float64(0)
	if user.Amount*2.5 <= user.AmountGet*uPrice {
		tmpFour = 0
	} else {
		tmpFour = user.Amount*2.5 - user.AmountGet*uPrice
	}

	return &pb.UserBuyReply{
		Status:       "ok",
		One:          user.Amount,
		Two:          2.5,
		Three:        user.AmountGet * uPrice,
		Four:         tmpFour,
		Five:         user.Location * uPrice,
		Six:          user.Recommend * uPrice,
		Seven:        user.RecommendTwo * uPrice,
		Eight:        user.Area * uPrice,
		Nine:         user.AreaTwo * uPrice,
		Ten:          user.All * uPrice,
		Elven:        user.MyTotalAmount,
		Twelve:       tmpTwelve,
		Thirteen:     tmpAreaMax,
		Fourteen:     tmpAreaMin,
		RecommendNum: tmpRecommendNum,
		Usdt:         user.AmountUsdt,
		Giw:          user.GiwTwo,
		Price:        uPrice,
		TeamNum:      uint64(len(team)),
		BuyNum:       tmpBuyNum,
		Level:        tmpLevel,
	}, nil
}

func (ac *AppUsecase) UserInfo(ctx context.Context, address string) (*pb.UserInfoReply, error) {
	var (
		user               *User
		boxNum             uint64
		boxSellNum         uint64
		configs            []*Config
		bPrice             float64
		uPrice             float64
		exchangeFeeRate    float64
		exchangeFeeRateTwo float64
		boxMax             uint64
		boxAmount          float64
		boxStart           string
		boxEnd             string
		stakeOverRate      float64
		sellFeeRate        float64
		withdrawMin        uint64
		withdrawMax        uint64
		withdrawMinTwo     uint64
		withdrawMaxTwo     uint64
		withdrawMinThree   float64
		withdrawMaxThree   float64
		exchangeMinThree   float64
		exchangeMaxThree   float64
		err                error
		rentRateOne        float64
		rentRateTwo        float64
		rentRateThree      float64
		sysContent         string
		sysContentE        string
		maxStake           float64
		minStake           float64
		minPlay            float64
		maxPlay            float64
		minStakeTwo        float64
		vOneRate           float64
		vTwoRate           float64
		one                float64
		two                float64
		three              float64
		stakeIspayOne      float64
		v1                 float64
		v2                 float64
		v3                 float64
		v4                 float64
		v5                 float64
		v6                 float64
		v7                 float64
		v8                 float64
		v9                 float64
		v10                float64
		//stakeIspayTwo      float64
		//stakeIspayThree    float64
		//stakeIspayFour     float64
		//stakeIspayFive     float64
		stakePrice   float64
		stakePriceOn uint64
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserInfoReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.UserInfoReply{
			Status: "锁定用户",
		}, nil
	}

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"box_num",
		"b_price",
		"u_price",
		"exchange_fee_rate",
		"exchange_fee_rate_two",
		"reward_stake_rate",
		"box_max",
		"box_sell_num",
		"box_start",
		"box_end",
		"box_amount",
		"stake_over_rate",
		"sell_fee_rate",
		"withdraw_amount_min",
		"withdraw_amount_max",
		"withdraw_amount_min_two",
		"withdraw_amount_max_two",
		"rent_rate_one",
		"rent_rate_three",
		"rent_rate_two",
		"sys_content",
		"sys_content_e",
		"max_stake",
		"min_stake",
		"max_play",
		"min_play",
		"min_stake_two",
		"withdraw_amount_min_three",
		"withdraw_amount_max_three",
		"exchange_three_rate",
		"withdraw_rate_three",
		"exchange_max_three",
		"exchange_min_three",
		"one",
		"two",
		"three",
		"stake_ispay_one",
		"stake_ispay_two",
		"stake_ispay_three",
		"stake_ispay_four",
		"stake_ispay_five",
		"v_1",
		"v_2",
		"v_3",
		"v_4",
		"v_5",
		"v_6",
		"v_7",
		"v_8",
		"v_9",
		"v_10",
		"stake_price",
		"stake_price_on",
	)
	if nil != err || nil == configs {
		return &pb.UserInfoReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "box_num" == vConfig.KeyName {
			boxNum, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		if "box_sell_num" == vConfig.KeyName {
			boxSellNum, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		if "withdraw_amount_min" == vConfig.KeyName {
			withdrawMin, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		if "withdraw_amount_max" == vConfig.KeyName {
			withdrawMax, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}

		if "withdraw_amount_min_two" == vConfig.KeyName {
			withdrawMinTwo, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		if "withdraw_amount_max_two" == vConfig.KeyName {
			withdrawMaxTwo, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		if "b_price" == vConfig.KeyName {
			bPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "exchange_fee_rate" == vConfig.KeyName {
			exchangeFeeRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "exchange_fee_rate_two" == vConfig.KeyName {
			exchangeFeeRateTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "box_start" == vConfig.KeyName {
			boxStart = vConfig.Value
		}
		if "box_end" == vConfig.KeyName {
			boxEnd = vConfig.Value
		}
		if "box_amount" == vConfig.KeyName {
			boxAmount, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "box_max" == vConfig.KeyName {
			boxMax, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		if "stake_over_rate" == vConfig.KeyName {
			stakeOverRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "sell_fee_rate" == vConfig.KeyName {
			sellFeeRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "u_price" == vConfig.KeyName {
			uPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "rent_rate_one" == vConfig.KeyName {
			rentRateOne, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "rent_rate_three" == vConfig.KeyName {
			rentRateThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "rent_rate_two" == vConfig.KeyName {
			rentRateTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "sys_content" == vConfig.KeyName {
			sysContent = vConfig.Value
		}
		if "sys_content_e" == vConfig.KeyName {
			sysContentE = vConfig.Value
		}
		if "max_play" == vConfig.KeyName {
			maxPlay, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "min_play" == vConfig.KeyName {
			minPlay, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "max_stake" == vConfig.KeyName {
			maxStake, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "min_stake" == vConfig.KeyName {
			minStake, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "min_stake_two" == vConfig.KeyName {
			minStakeTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "exchange_three_rate" == vConfig.KeyName {
			vOneRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "withdraw_rate_three" == vConfig.KeyName {
			vTwoRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "withdraw_amount_min_three" == vConfig.KeyName {
			withdrawMinThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "withdraw_amount_max_three" == vConfig.KeyName {
			withdrawMaxThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "exchange_max_three" == vConfig.KeyName {
			exchangeMaxThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "exchange_min_three" == vConfig.KeyName {
			exchangeMinThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "one" == vConfig.KeyName {
			one, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "two" == vConfig.KeyName {
			two, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "three" == vConfig.KeyName {
			three, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "stake_ispay_one" == vConfig.KeyName {
			stakeIspayOne, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		//if "stake_ispay_two" == vConfig.KeyName {
		//	stakeIspayTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//if "stake_ispay_three" == vConfig.KeyName {
		//	stakeIspayThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//if "stake_ispay_four" == vConfig.KeyName {
		//	stakeIspayFour, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//if "stake_ispay_five" == vConfig.KeyName {
		//	stakeIspayFive, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		if "v_1" == vConfig.KeyName {
			v1, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_2" == vConfig.KeyName {
			v2, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_3" == vConfig.KeyName {
			v3, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_4" == vConfig.KeyName {
			v4, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_5" == vConfig.KeyName {
			v5, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_6" == vConfig.KeyName {
			v6, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_7" == vConfig.KeyName {
			v7, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_8" == vConfig.KeyName {
			v8, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_9" == vConfig.KeyName {
			v9, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_10" == vConfig.KeyName {
			v10, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "stake_price" == vConfig.KeyName {
			stakePrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "stake_price_on" == vConfig.KeyName {
			stakePriceOn, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
	}

	if 0 >= bPrice {
		return &pb.UserInfoReply{
			Status: "币价ispay:ispay错误",
		}, nil
	}

	if 0 >= uPrice {
		return &pb.UserInfoReply{
			Status: "币价ispay:u错误",
		}, nil
	}

	if 0 < user.WithdrawMax {
		withdrawMaxTwo = user.WithdrawMax
	}

	// 推荐
	var (
		userRecommend   *UserRecommend
		myUserRecommend []*UserRecommend
	)
	userRecommend, err = ac.userRepo.GetUserRecommendByUserId(ctx, user.ID)
	if nil == userRecommend || nil != err {
		return &pb.UserInfoReply{
			Status: "推荐错误查询",
		}, nil
	}

	var (
		myUserRecommendUserId  uint64
		tmpRecommendUserIdsTmp []string
		addressThree           string
	)

	if 0 < len(userRecommend.RecommendCode) {
		tmpRecommendUserIdsTmp = strings.Split(userRecommend.RecommendCode, "D")
		if 2 <= len(tmpRecommendUserIdsTmp) {
			myUserRecommendUserId, _ = strconv.ParseUint(tmpRecommendUserIdsTmp[len(tmpRecommendUserIdsTmp)-1], 10, 64) // 最后一位是直推人
		}

		if 0 < myUserRecommendUserId {
			var (
				myTopUser *User
			)
			myTopUser, err = ac.userRepo.GetUserById(ctx, myUserRecommendUserId)
			if nil != err {
				return &pb.UserInfoReply{
					Status: "上级查询错误",
				}, nil
			}

			addressThree = myTopUser.Address
		}

	}

	myUserRecommend, err = ac.userRepo.GetUserRecommendByCode(ctx, userRecommend.RecommendCode+"D"+strconv.FormatUint(user.ID, 10))
	if nil == myUserRecommend || nil != err {
		return &pb.UserInfoReply{
			Status: "推荐错误查询",
		}, nil
	}

	RecommendTotalRewardOne := user.RewardOne + user.RewardTwo + user.RewardThree
	RecommendTotalRewardTwo := user.RewardTwoOne + user.RewardTwoTwo + user.RewardTwoThree
	RecommendTotalRewardThree := user.RewardThreeOne + user.RewardThreeTwo + user.RewardThreeThree
	RecommendTotalReward := RecommendTotalRewardOne + RecommendTotalRewardTwo + RecommendTotalRewardThree

	var (
		stakeGitRecord []*StakeGitRecord
	)
	stakeGitRecord, err = ac.userRepo.GetStakeGitRecordsByUserID(ctx, user.ID, nil)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "粮仓错误查询",
		}, nil
	}
	stakeGitAmount := float64(0)
	stakeGitAmountToday := float64(0)

	// 获取中国时区（Asia/Shanghai）
	locShanghai, err := time.LoadLocation("Asia/Shanghai")
	if err != nil {
		return &pb.UserInfoReply{
			Status: "时区查询",
		}, nil
	}
	// 获取当前时间（假设服务器时间是 UTC）
	nowUTC := time.Now()
	// 转换当前时间为中国时区
	nowInShanghai := nowUTC.In(locShanghai)
	todayStakeGitAmount := float64(0)
	canUsdtWithdraw := float64(0)
	for _, v := range stakeGitRecord {
		if v.CreatedAt.Before(time.Now().Add(-time.Duration(v.Day) * 24 * time.Hour)) {
			continue
		}

		canUsdtWithdraw += v.AmountTwo
		todayStakeGitAmount += v.Amount * stakeIspayOne
		//if 30 == v.Day {
		//} else if 60 == v.Day {
		//	todayStakeGitAmount += v.Amount * stakeIspayTwo
		//} else if 90 == v.Day {
		//	todayStakeGitAmount += v.Amount * stakeIspayThree
		//} else if 120 == v.Day {
		//	todayStakeGitAmount += v.Amount * stakeIspayFour
		//} else if 360 == v.Day {
		//	todayStakeGitAmount += v.Amount * stakeIspayFive
		//}

		stakeGitAmount += v.Amount
		// 转换用户注册时间到中国时区
		userRegisterInShanghai := v.CreatedAt.In(locShanghai)
		// 计算用户注册当天在中国时区的 24:00（即第二天 00:00:00）
		nextMidnight := time.Date(userRegisterInShanghai.Year(), userRegisterInShanghai.Month(), userRegisterInShanghai.Day()+1, 0, 0, 0, 0, locShanghai)
		// 判断是否超过注册当天的 24:00
		if nowInShanghai.After(nextMidnight) {
			stakeGitAmountToday += v.Amount
		}
	}

	if boxNum > 0 {
		//var (
		//	countBox int64
		//)
		//countBox, err = ac.userRepo.GetBoxRecordCount(ctx, boxNum)
		//if nil != err {
		//	return &pb.UserInfoReply{
		//		Status: "盲盒错误查询",
		//	}, nil
		//}
		//
		//boxSellNum = uint64(countBox)
	}

	var (
		stakeGetTotalMy = float64(0)
		stakeGet        *StakeGet

		stakeGetTotalAmount float64
		stakeGetTotal       *StakeGetTotal
	)

	stakeGetTotal, err = ac.userRepo.GetStakeGetTotal(ctx)
	if nil != err || nil == stakeGetTotal {
		return &pb.UserInfoReply{
			Status: "我的放大器错误查询",
		}, nil
	}
	stakeGetTotalAmount = stakeGetTotal.Balance

	stakeGet, err = ac.userRepo.GetUserStakeGet(ctx, user.ID)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "我的放大器错误查询",
		}, nil
	}
	if nil != stakeGet {
		if 0 < stakeGetTotal.Amount {
			// 每份价值
			valuePerShare := stakeGetTotalAmount / stakeGetTotal.Amount
			// 用户最大可提取金额
			stakeGetTotalMy = stakeGet.StakeRate * valuePerShare
		}
	}

	var (
		messages []*Message
	)

	messages, err = ac.userRepo.GetMessages(ctx)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "消息查询失败",
		}, nil
	}

	usersMap := make(map[uint64]*User, 0)
	userIds := make([]uint64, 0)
	for _, m := range messages {
		userIds = append(userIds, m.UserId)
	}

	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "消息查询失败",
		}, nil
	}

	resMessage := make([]*pb.UserInfoReply_ListM, 0)
	for _, m := range messages {
		if _, ok := usersMap[m.UserId]; ok {
			resMessage = append(resMessage, &pb.UserInfoReply_ListM{
				Address: usersMap[m.UserId].Address,
				Content: m.Content,
			})
		}
	}

	var (
		adminMessages []*AdminMessage
	)

	adminMessages, err = ac.userRepo.GetAdminMessages(ctx)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "消息查询失败",
		}, nil
	}
	resMessageAdmin := make([]*pb.UserInfoReply_AdminListM, 0)
	for _, m := range adminMessages {
		resMessageAdmin = append(resMessageAdmin, &pb.UserInfoReply_AdminListM{
			Content:    m.Content,
			ContentTwo: m.ContentTwo,
		})
	}

	var (
		landUserUse map[uint64]*LandUserUse
		userRed     uint64
	)
	landUserUse, err = ac.userRepo.GetLandMyUseByLandIDsMapUsing(ctx, user.ID)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "错误查询",
		}, nil
	}

	current := time.Now().Unix()
	for _, v := range landUserUse {
		if uint64(current) < v.OverTime {
			continue
		}

		if 0 != v.One {
			continue
		}

		if user.ID == v.IsUseOther {
			continue
		}

		// 已结束
		userRed = 1
	}

	//var (
	//	tmpThree float64
	//	tmp0     float64
	//	tmp1     float64
	//)
	//tmp0, tmp1, err = GetReservers()
	//if nil == err && 1 < tmp0 && 1 < tmp1 {
	//	tmpThree = tmp0 / tmp1
	//}

	var (
		newIspayPrice float64
	)
	if 1 == stakePriceOn {
		newIspayPrice = stakePrice
	} else {
		newIspayPrice, err = GetIspayPrice()
		if nil != err || 0.0000001 > newIspayPrice {
			fmt.Println(err, newIspayPrice, "err ispay price")
			//return &pb.UserInfoReply{
			//	Status: "错误查询",
			//}, nil
		}
	}

	var (
		tA float64
		yA float64
	)

	tA, err = ac.userRepo.GetUserRewardFourT(ctx, user.ID)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "错误查询",
		}, nil
	}

	yA, err = ac.userRepo.GetUserRewardFour(ctx, user.ID)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "错误查询",
		}, nil
	}

	var (
		four uint64
		five uint64
		six  uint64
	)

	four, err = ac.userRepo.GetSumEthTwo(ctx)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "错误查询",
		}, nil
	}

	five, err = ac.userRepo.GetSumEthTwoThree(ctx)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "错误查询",
		}, nil
	}

	six, err = ac.userRepo.GetSumEthTwoFour(ctx)
	if nil != err {
		return &pb.UserInfoReply{
			Status: "错误查询",
		}, nil
	}

	tmpLevel := 0
	tmpVip := user.Vip
	if v10 <= user.MyTotalAmountNew || 10 == tmpVip {
		tmpLevel = 10
	} else if v9 <= user.MyTotalAmountNew || 9 == tmpVip {
		tmpLevel = 9
	} else if v8 <= user.MyTotalAmountNew || 8 == tmpVip {
		tmpLevel = 8
	} else if v7 <= user.MyTotalAmountNew || 7 == tmpVip {
		tmpLevel = 7
	} else if v6 <= user.MyTotalAmountNew || 6 == tmpVip {
		tmpLevel = 6
	} else if v5 <= user.MyTotalAmountNew || 5 == tmpVip {
		tmpLevel = 5
	} else if v4 <= user.MyTotalAmountNew || 4 == tmpVip {
		tmpLevel = 4
	} else if v3 <= user.MyTotalAmountNew || 3 == tmpVip {
		tmpLevel = 3
	} else if v2 <= user.MyTotalAmountNew || 2 == tmpVip {
		tmpLevel = 2
	} else if v1 <= user.MyTotalAmountNew || 1 == tmpVip {
		tmpLevel = 1
	}

	return &pb.UserInfoReply{
		Red:                       userRed,
		ListM:                     resMessage,
		Status:                    "ok",
		CanLand:                   user.CanLand,
		MyAddress:                 user.Address,
		Level:                     uint64(tmpLevel),
		Giw:                       user.Giw,
		Git:                       user.Git,
		RecommendTotal:            uint64(len(myUserRecommend)),
		RecommendTotalBiw:         user.Total,
		RecommendTotalReward:      RecommendTotalReward,
		RecommendTotalBiwOne:      user.TotalOne,
		RecommendTotalRewardOne:   RecommendTotalRewardOne,
		RecommendTotalBiwTwo:      user.TotalTwo,
		RecommendTotalRewardTwo:   RecommendTotalRewardTwo,
		RecommendTotalBiwThree:    user.TotalThree,
		RecommendTotalRewardThree: RecommendTotalRewardThree,
		MyStakeGit:                stakeGitAmount,
		TodayRewardSkateGit:       todayStakeGitAmount,
		Box:                       boxMax,
		BoxSell:                   boxSellNum,
		Start:                     boxStart,
		End:                       boxEnd,
		BoxSellAmount:             boxAmount,
		ExchangeRate:              bPrice,
		ExchangeRateTwo:           uPrice,
		BiwPrice:                  uPrice,
		UsdtTwo:                   user.AmountUsdt,
		ExchangeFeeRate:           exchangeFeeRate,
		ExchangeFeeRateTwo:        exchangeFeeRateTwo,
		StakeGetTotal:             stakeGetTotalAmount,
		MyStakeGetTotal:           stakeGetTotalMy,
		StakeGetOverFeeRate:       stakeOverRate,
		SellFeeRate:               sellFeeRate,
		WithdrawMax:               withdrawMax,
		WithdrawMin:               withdrawMin,
		WithdrawMaxTwo:            withdrawMaxTwo,
		WithdrawMinTwo:            withdrawMinTwo,
		Usdt:                      user.AmountUsdt,
		CreatedAt:                 user.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
		AddressThree:              addressThree,
		GiwTwo:                    user.GiwTwo,
		RentOne:                   rentRateOne,
		RentThree:                 rentRateThree,
		RentTwo:                   rentRateTwo,
		SySContent:                sysContent,
		SySContentE:               sysContentE,
		MinPlay:                   minPlay,
		MaxPlay:                   maxPlay,
		MaxStake:                  maxStake,
		MinStake:                  minStake,
		MinStakeTwo:               minStakeTwo,
		CanPlayAdd:                user.CanPlayAdd,
		AdminListM:                resMessageAdmin,
		WithdrawMaxThree:          withdrawMaxThree,
		WithdrawMinThree:          withdrawMinThree,
		GitNew:                    user.GitNew,
		GitNewNew:                 user.GitNewNew,
		ExchangeRateThree:         vOneRate,
		WithdrawRateThree:         vTwoRate,
		ExchangeThree:             newIspayPrice,
		ExchangeMaxThree:          exchangeMaxThree,
		ExchangeMinThree:          exchangeMinThree,
		One:                       one,
		Two:                       two,
		Three:                     three,
		CanUsdtWithdraw:           canUsdtWithdraw,
		CanPlaySix:                user.CanPlaySix,
		NewOne:                    user.MyTotalAmountNew,
		NewTwo:                    yA,
		NewThree:                  tA,
		NewFour:                   four,
		NewFive:                   five,
		NewSix:                    six,
	}, nil
}

func (ac *AppUsecase) UserRecommend(ctx context.Context, address string, req *pb.UserRecommendRequest) (*pb.UserRecommendReply, error) {
	res := make([]*pb.UserRecommendReply_List, 0)
	var (
		user    *User
		err     error
		v1      float64
		v2      float64
		v3      float64
		v4      float64
		v5      float64
		v6      float64
		v7      float64
		v8      float64
		v9      float64
		v10     float64
		configs []*Config
	)

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"v_1",
		"v_2",
		"v_3",
		"v_4",
		"v_5",
		"v_6",
		"v_7",
		"v_8",
		"v_9",
		"v_10",
	)
	if nil != err || nil == configs {
		return &pb.UserRecommendReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "v_1" == vConfig.KeyName {
			v1, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_2" == vConfig.KeyName {
			v2, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_3" == vConfig.KeyName {
			v3, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_4" == vConfig.KeyName {
			v4, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_5" == vConfig.KeyName {
			v5, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_6" == vConfig.KeyName {
			v6, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_7" == vConfig.KeyName {
			v7, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_8" == vConfig.KeyName {
			v8, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_9" == vConfig.KeyName {
			v9, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "v_10" == vConfig.KeyName {
			v10, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserRecommendReply{
			Status: "不存在用户",
		}, nil
	}

	// 推荐
	var (
		userRecommend  *UserRecommend
		userRecommends []*UserRecommend
		count          int64
	)
	userRecommend, err = ac.userRepo.GetUserRecommendByUserId(ctx, user.ID)
	if nil == userRecommend || nil != err {
		return &pb.UserRecommendReply{
			Status: "推荐错误查询",
		}, nil
	}

	count, err = ac.userRepo.GetUserRecommendCount(ctx, userRecommend.RecommendCode+"D"+strconv.FormatUint(user.ID, 10))
	if nil != err {
		return &pb.UserRecommendReply{
			Status: "推荐错误查询",
		}, nil
	}

	userRecommends, err = ac.userRepo.GetUserRecommendByCodePage(ctx, userRecommend.RecommendCode+"D"+strconv.FormatUint(user.ID, 10), &Pagination{
		PageNum:  int(req.Page),
		PageSize: 20,
	})
	if nil != err {
		return &pb.UserRecommendReply{
			Status: "推荐错误查询",
		}, nil
	}

	userIds := make([]uint64, 0)
	for _, v := range userRecommends {
		userIds = append(userIds, v.UserId)
	}

	usersMap := make(map[uint64]*User)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserRecommendReply{
			Status: "推荐用户查询错误",
		}, nil
	}

	for _, v := range usersMap {
		tmpLevel := 0
		tmpVip := v.Vip
		if v10 <= v.MyTotalAmountNew || 10 == tmpVip {
			tmpLevel = 10
		} else if v9 <= v.MyTotalAmountNew || 9 == tmpVip {
			tmpLevel = 9
		} else if v8 <= v.MyTotalAmountNew || 8 == tmpVip {
			tmpLevel = 8
		} else if v7 <= v.MyTotalAmountNew || 7 == tmpVip {
			tmpLevel = 7
		} else if v6 <= v.MyTotalAmountNew || 6 == tmpVip {
			tmpLevel = 6
		} else if v5 <= v.MyTotalAmountNew || 5 == tmpVip {
			tmpLevel = 5
		} else if v4 <= v.MyTotalAmountNew || 4 == tmpVip {
			tmpLevel = 4
		} else if v3 <= v.MyTotalAmountNew || 3 == tmpVip {
			tmpLevel = 3
		} else if v2 <= v.MyTotalAmountNew || 2 == tmpVip {
			tmpLevel = 2
		} else if v1 <= v.MyTotalAmountNew || 1 == tmpVip {
			tmpLevel = 1
		}

		res = append(res, &pb.UserRecommendReply_List{
			Address:   v.Address,
			Level:     uint64(tmpLevel),
			CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
		})
	}

	return &pb.UserRecommendReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

func (ac *AppUsecase) UserRecommendL(ctx context.Context, address string, req *pb.UserRecommendLRequest) (*pb.UserRecommendLReply, error) {
	res := make([]*pb.UserRecommendLReply_List, 0)
	var (
		user  *User
		err   error
		count int64
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserRecommendLReply{
			Status: "不存在用户",
		}, nil
	}

	var (
		reward []*Reward
	)

	status := []uint64{}
	if 1 == req.Num {
		status = append(status, 4, 5, 6)
	} else if 2 == req.Num {
		status = append(status, 7, 8, 9)
	} else if 3 == req.Num {
		status = append(status, 10, 11, 12)
	} else {
		return &pb.UserRecommendLReply{
			Status: "参数错误",
		}, nil
	}

	count, err = ac.userRepo.GetUserRewardPageCount(ctx, user.ID, status)
	if nil != err {
		return &pb.UserRecommendLReply{
			Status: "不存在数据L，count",
		}, nil
	}

	reward, err = ac.userRepo.GetUserRewardPage(ctx, user.ID, status, &Pagination{
		PageNum:  int(req.Page),
		PageSize: 20,
	})
	if nil != err {
		return &pb.UserRecommendLReply{
			Status: "不存在数据L",
		}, nil
	}

	userIds := []uint64{}
	for _, v := range reward {
		userIds = append(userIds, v.One)
	}

	usersMap := make(map[uint64]*User)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserRecommendLReply{
			Status: "不存在数据L,用户",
		}, nil
	}

	for _, v := range reward {
		tmpAddress := ""
		if _, ok := usersMap[v.One]; ok {
			tmpAddress = usersMap[v.One].Address
		}

		res = append(res, &pb.UserRecommendLReply_List{
			Address:   tmpAddress,
			Amount:    fmt.Sprintf("%.5f", v.Amount),
			CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
		})
	}

	return &pb.UserRecommendLReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

func (ac *AppUsecase) UserBuyL(ctx context.Context, address string, req *pb.UserBuyLRequest) (*pb.UserBuyLReply, error) {
	res := make([]*pb.UserBuyLReply_List, 0)
	var (
		user  *User
		err   error
		count int64
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserBuyLReply{
			Status: "不存在用户",
		}, nil
	}

	var (
		configs []*Config
		uPrice  float64
	)

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"u_price",
	)
	if nil != err || nil == configs {
		return &pb.UserBuyLReply{
			Status: "配置错误",
		}, nil
	}
	for _, vConfig := range configs {
		if "u_price" == vConfig.KeyName {
			uPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	var (
		reward []*RewardTwo
	)
	if 1 <= req.Num && req.Num <= 7 {

	} else {
		return &pb.UserBuyLReply{
			Status: "参数错误",
		}, nil
	}

	count, err = ac.userRepo.GetUserRewardTwoPageCount(ctx, user.ID, req.Num)
	if nil != err {
		return &pb.UserBuyLReply{
			Status: "不存在数据L，count",
		}, nil
	}

	reward, err = ac.userRepo.GetUserRewardTwoPage(ctx, user.ID, req.Num, &Pagination{
		PageNum:  int(req.Page),
		PageSize: 20,
	})
	if nil != err {
		return &pb.UserBuyLReply{
			Status: "不存在数据L",
		}, nil
	}

	for _, v := range reward {

		if 1 == v.Reason {
			res = append(res, &pb.UserBuyLReply_List{
				AmountThree: v.Amount,
				Amount:      v.Five,
				AmountTwo:   v.Three,
				Address:     v.Four,
				Num:         v.One,
				CreatedAt:   v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
			})
		} else {
			res = append(res, &pb.UserBuyLReply_List{
				Amount:    v.Three * uPrice,
				AmountTwo: v.Amount,
				Address:   v.Four,
				Num:       v.One,
				CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
			})
		}
	}

	return &pb.UserBuyLReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

func (ac *AppUsecase) UserLand(ctx context.Context, address string, req *pb.UserLandRequest) (*pb.UserLandReply, error) {
	res := make([]*pb.UserLandReply_List, 0)
	var (
		user  *User
		lands []*Land
		count int64
		err   error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserLandReply{
			Status: "不存在用户",
		}, nil
	}

	status := []uint64{0, 1, 2, 3, 4, 5, 8}
	if 0 < req.Status {
		if 100 == req.Status {
			req.Status = 0
		}

		status = []uint64{req.Status}
	}

	pageInit := 1
	if 1 < req.Page {
		pageInit = int(req.Page)
	}
	count, err = ac.userRepo.GetLandByUserIDCount(ctx, user.ID, status)
	if nil != err {
		return &pb.UserLandReply{
			Status: "不存在用户",
		}, nil
	}

	lands, err = ac.userRepo.GetLandByUserID(ctx, user.ID, status, &Pagination{
		PageNum:  pageInit,
		PageSize: 100,
	})
	if nil != err {
		return &pb.UserLandReply{
			Status: "不存在用户",
		}, nil
	}

	userIds := []uint64{}
	for _, v := range lands {
		if 0 < v.LocationUserId {
			userIds = append(userIds, v.LocationUserId)
		}
	}

	usersMap := make(map[uint64]*User)
	if 0 < len(userIds) {
		usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
		if nil != err {
			return &pb.UserLandReply{
				Status: "不存在数据，用户",
			}, nil
		}
	}

	for _, v := range lands {
		statusTmp := v.Status
		rentPlant := uint64(0)
		if 8 == v.Status {
			statusTmp = 3
			rentPlant = 1
		}

		tmpAddress := ""
		if _, ok := usersMap[v.LocationUserId]; ok {
			tmpAddress = usersMap[v.LocationUserId].Address
		}

		res = append(res, &pb.UserLandReply_List{
			Id:         v.ID,
			Level:      v.Level,
			Health:     v.MaxHealth,
			Status:     statusTmp,
			OutRate:    v.OutPutRate,
			PerHealth:  v.PerHealth,
			RentAmount: v.RentOutPutRate,
			One:        v.One,
			Two:        v.Two,
			Three:      v.Three,
			Content:    "在Magic Manor大陆最肥沃的土地，由神秘的地契合成，层叠强大的成长性，任何劣质的种子都可以得到茁壮的成长。",
			EContent:   "The most fertile land in the Magic Manorcontinent is composed of mysterious landdeeds. lt has strong growth potential, andany low-quality seeds can grow vigorously.",
			AddressTwo: tmpAddress,
			RentPlant:  rentPlant,
		})
	}

	return &pb.UserLandReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

func (ac *AppUsecase) UserStakeGitStakeList(ctx context.Context, address string, req *pb.UserStakeGitStakeListRequest) (*pb.UserStakeGitStakeListReply, error) {
	res := make([]*pb.UserStakeGitStakeListReply_List, 0)
	var (
		user        *User
		count       int64
		myCount     int64
		configs     []*Config
		queueAmount float64
		todayAmount float64
		err         error
	)
	if 10 < len(req.Address) {
		address = req.Address
	}
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserStakeGitStakeListReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == req.IsQueue {
		// 配置
		configs, err = ac.userRepo.GetConfigByKeys(ctx,
			"queue_amount",
		)
		if nil != err || nil == configs {
			return &pb.UserStakeGitStakeListReply{
				Status: "配置错误",
			}, nil
		}
		for _, vConfig := range configs {
			if "queue_amount" == vConfig.KeyName {
				queueAmount, _ = strconv.ParseFloat(vConfig.Value, 10)
			}
		}

		var (
			stakeGitRecord []*StakeGitRecord
			userId         uint64
		)
		if 10 < len(req.Address) {
			userId = user.ID
		}

		todayAmount, err = ac.userRepo.GetStakeGitRecordsByUserIDQueueToday(ctx)
		if nil != err {
			return &pb.UserStakeGitStakeListReply{
				Status: "粮仓错误查询",
			}, nil
		}

		if todayAmount < queueAmount {
			queueAmount = queueAmount - todayAmount
		} else {
			queueAmount = 0
		}

		myCount, err = ac.userRepo.GetStakeGitRecordsByUserIDQueueCount(ctx, user.ID)
		if nil != err {
			return &pb.UserStakeGitStakeListReply{
				Status: "粮仓错误查询",
			}, nil
		}

		count, err = ac.userRepo.GetStakeGitRecordsByUserIDQueueCount(ctx, userId)
		if nil != err {
			return &pb.UserStakeGitStakeListReply{
				Status: "粮仓错误查询",
			}, nil
		}

		stakeGitRecord, err = ac.userRepo.GetStakeGitRecordsByUserIDQueue(ctx, userId, &Pagination{
			PageNum:  int(req.Page),
			PageSize: 20,
		})
		if nil != err {
			return &pb.UserStakeGitStakeListReply{
				Status: "粮仓错误查询",
			}, nil
		}

		userIds := make([]uint64, 0)
		for _, v := range stakeGitRecord {
			userIds = append(userIds, v.UserId)
		}
		usersMap := make(map[uint64]*User)
		if 0 < len(userIds) {
			usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
			if nil != err {
				return &pb.UserStakeGitStakeListReply{
					Status: "粮仓错误查询",
				}, nil
			}
		}

		for _, v := range stakeGitRecord {
			tmpAddress := ""
			if _, ok := usersMap[v.UserId]; ok {
				tmpAddress = usersMap[v.UserId].Address
			}

			res = append(res, &pb.UserStakeGitStakeListReply_List{
				Id:        v.ID,
				Stake:     v.Amount,
				CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
				Day:       v.Day,
				Reward:    v.AmountTwo,
				Address:   tmpAddress,
			})
		}
	} else {
		var (
			stakeGitRecord []*StakeGitRecord
		)
		stakeGitRecord, err = ac.userRepo.GetStakeGitRecordsByUserID(ctx, user.ID, nil)
		if nil != err {
			return &pb.UserStakeGitStakeListReply{
				Status: "粮仓错误查询",
			}, nil
		}

		for _, v := range stakeGitRecord {
			if v.CreatedAt.Before(time.Now().Add(-time.Duration(v.Day) * 24 * time.Hour)) {
				continue
			}

			res = append(res, &pb.UserStakeGitStakeListReply_List{
				Id:        v.ID,
				Stake:     v.Amount,
				CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
				Day:       v.Day,
				Reward:    v.AmountTwo,
			})
		}
	}

	return &pb.UserStakeGitStakeListReply{
		Status:      "ok",
		Count:       uint64(count),
		MyCount:     uint64(myCount),
		TodayAmount: queueAmount,
		List:        res,
	}, err
}

func (ac *AppUsecase) UserStakeGitRewardList(ctx context.Context, address string, req *pb.UserStakeGitRewardListRequest) (*pb.UserStakeGitRewardListReply, error) {
	res := make([]*pb.UserStakeGitRewardListReply_List, 0)
	var (
		user *User
		err  error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserStakeGitRewardListReply{
			Status: "不存在用户",
		}, nil
	}

	var (
		reward []*Reward
		count  int64
	)

	status := []uint64{3}
	count, err = ac.userRepo.GetUserRewardPageCount(ctx, user.ID, status)
	if nil != err {
		return &pb.UserStakeGitRewardListReply{
			Status: "粮仓查询错误",
		}, nil
	}

	reward, err = ac.userRepo.GetUserRewardPage(ctx, user.ID, status, &Pagination{
		PageNum:  int(req.Page),
		PageSize: 20,
	})
	if nil != err {
		return &pb.UserStakeGitRewardListReply{
			Status: "粮仓查询错误",
		}, nil
	}

	for _, v := range reward {
		res = append(res, &pb.UserStakeGitRewardListReply_List{
			Amount:    v.Amount,
			CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
		})
	}

	return &pb.UserStakeGitRewardListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

func (ac *AppUsecase) UserBoxList(ctx context.Context, address string, req *pb.UserBoxListRequest) (*pb.UserBoxListReply, error) {
	res := make([]*pb.UserBoxListReply_List, 0)
	var (
		boxNum  uint64
		configs []*Config
		user    *User
		err     error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserBoxListReply{
			Status: "不存在用户",
		}, nil
	}

	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"box_num",
	)
	if nil != err || nil == configs {
		return &pb.UserBoxListReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "box_num" == vConfig.KeyName {
			boxNum, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
	}

	if 0 < boxNum {
		var (
			box []*BoxRecord
		)
		box, err = ac.userRepo.GetUserBoxRecordOpen(ctx, user.ID, boxNum, true, &Pagination{
			PageNum:  1,
			PageSize: 20,
		})
		if nil != err {
			return &pb.UserBoxListReply{
				Status: "查询错误",
			}, nil
		}

		for _, v := range box {
			res = append(res, &pb.UserBoxListReply_List{
				Content:   v.Content,
				CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
			})
		}
	}

	return &pb.UserBoxListReply{
		Status: "ok",
		Count:  2,
		List:   res,
	}, nil
}

func (ac *AppUsecase) UserBackList(ctx context.Context, address string, req *pb.UserBackListRequest) (*pb.UserBackListReply, error) {
	res := make([]*pb.UserBackListReply_List, 0)
	var (
		count int64
		user  *User
		err   error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserBackListReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == req.Num {
		var (
			prop []*Prop
		)
		// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
		propStatus := []uint64{1, 2, 4}

		count, err = ac.userRepo.GetPropsByUserIDCount(ctx, propStatus, user.ID, req.PropType)
		if nil != err {
			return &pb.UserBackListReply{
				Status: "道具错误",
			}, nil
		}

		prop, err = ac.userRepo.GetPropsByUserID(ctx, user.ID, propStatus, req.PropType, &Pagination{
			PageNum:  int(req.Page),
			PageSize: 100,
		})
		if nil != err {
			return &pb.UserBackListReply{
				Status: "道具错误",
			}, nil
		}

		for _, vProp := range prop {
			useNum := uint64(0)
			contentTmp := ""
			eContentTmp := ""
			if 12 == vProp.PropType {
				useNum = uint64(vProp.ThreeOne) // 水
				contentTmp = "一种植物在成长过程中也许会用到的特殊用水，缺水的植物会停止成长，使用后您的植物将永远不会缺水。"
				eContentTmp = "A plant may use special water duringits growth. Plants that are short ofwater will stop growing. After using it,your plants will never be short of water."
			} else if 13 == vProp.PropType {
				useNum = uint64(vProp.FiveOne) // 手套
				contentTmp = "带上手套后，可偷取任何邻居家的已经成熟的植物，可获得一定的ISPAY，但是使用的次数有限。"
				eContentTmp = "After wearing gloves, you can stealany mature plants from your neighbor'shouse and obtain a certain amount ofGlT, but the number of uses is limited."
			} else if 14 == vProp.PropType {
				useNum = uint64(vProp.FourOne) // 除虫剂
				contentTmp = "由Magic Manor大陆中的巫师制作，不除虫子的植物，每5分钟减产1%;直到最后为产量为0，它可以杀死Magic Manor大陆中的任何害虫。"
				eContentTmp = "Made by wizards in the Magic Manorcontinent, plants that do not eliminateinsects will reduce their yield by 1% every5 minutes; until the final yield is O, it can killany pests in the Magic Manor continent."
			} else if 15 == vProp.PropType {
				useNum = uint64(vProp.TwoOne) // 铲子
				contentTmp = "可铲除出租土地上已经成熟的植物，不可铲除自己种植的植物，但是成熟时间必须大于1H。"
				eContentTmp = "Mature plants on the leased land canbe eradicated, but self-grown plantscannot be eradicated, but the maturitytime must be greater than 1H."
			} else if 11 == vProp.PropType {
				contentTmp = "一种通过算法生成的增加产量道具，合成士地和增加土地肥沃度。"
				eContentTmp = "An algorithmically generated item thatincreases yield, synthesizes land, andincreases land fertility."
			} else if 17 == vProp.PropType {
				contentTmp = "在Magic Manor大陆深处埋徵着一张”地契”，它是初创统治者亲手制作，代表着整个Magic Manor最肥沃的土地，找到它的人不仅可以拥有土地，还能解锁谷中隐藏的古老秘密。\n\t\t获取方式:每新增1亿ISPAY产出业绩，自动获得1张地契:作用:1张地契加5块化肥，可合成一个崭新的1级土地;地契描述"
				eContentTmp = "There is a \"land deed\" buried deep in the Magic Manorcontinent. lt was made by the original ruler himself andrepresents the most fertile land in the entire MagicManor. Whoever finds it will not only claim the land, butalso unlock ancient secrets hidden within the valley.How to obtain: For every 100 milion new GlT outputs,you will automatically obtain a land deed;Function: 1 land deed and 5 fertilizers can be combinedinto a brand new level 1 land."
			}

			res = append(res, &pb.UserBackListReply_List{
				Id:       vProp.ID,
				Type:     2,
				Num:      uint64(vProp.PropType),
				UseNum:   useNum,
				Status:   uint64(vProp.Status),
				OutMax:   0,
				Amount:   vProp.SellAmount,
				Content:  contentTmp,
				EContent: eContentTmp,
			})
		}
	} else if 2 == req.Num {
		var (
			seed []*Seed
		)
		seedStatus := []uint64{0, 4}
		count, err = ac.userRepo.GetSeedByUserIDCount(ctx, seedStatus, user.ID)
		if nil != err {
			return &pb.UserBackListReply{
				Status: "查询种子错误",
			}, nil
		}

		seed, err = ac.userRepo.GetSeedByUserID(ctx, user.ID, seedStatus, &Pagination{
			PageNum:  int(req.Page),
			PageSize: 100,
		})
		if nil != err {
			return &pb.UserBackListReply{
				Status: "查询种子错误",
			}, nil
		}

		for _, vSeed := range seed {
			tmpStatus := uint64(1)
			if 4 == vSeed.Status {
				tmpStatus = 4
			}

			res = append(res, &pb.UserBackListReply_List{
				Id:       vSeed.ID,
				Type:     1,
				Num:      vSeed.SeedId,
				UseNum:   0,
				Status:   tmpStatus,
				OutMax:   vSeed.OutMaxAmount,
				Time:     vSeed.OutOverTime,
				Amount:   vSeed.SellAmount,
				Content:  "一种来自区块链世界算法加密的种子，打开盲盒或合成获得，每一颗种子都不同，找到适合他的土地后，会有惊人的产出！",
				EContent: "A seed from the blockchain world algorithm encryption, open the blind box or synthetic access, each seed is different, find suitable for his land, there will be amazing output!",
			})
		}
	} else if 3 == req.Num {
		var (
			box []*BoxRecord
		)

		count, err = ac.userRepo.GetUserBoxRecordOpenCount(ctx, user.ID)
		if nil != err {
			return &pb.UserBackListReply{
				Status: "查询盒子错误",
			}, nil
		}

		box, err = ac.userRepo.GetUserBoxRecordOpen(ctx, user.ID, 0, false, &Pagination{
			PageNum:  1,
			PageSize: 100,
		})
		if nil != err {
			return &pb.UserBackListReply{
				Status: "查询盒子错误",
			}, nil
		}

		for _, v := range box {
			res = append(res, &pb.UserBackListReply_List{
				Id:     v.ID,
				Type:   2,
				Num:    16,
				UseNum: 0,
				Status: 0,
				OutMax: 0,
			})
		}
	}

	return &pb.UserBackListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

// UserMarketSeedList userMarketSeedList.
func (ac *AppUsecase) UserMarketSeedList(ctx context.Context, address string, req *pb.UserMarketSeedListRequest) (*pb.UserMarketSeedListReply, error) {

	var (
		user *User
		err  error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserMarketSeedListReply{
			Status: "不存在用户",
		}, nil
	}
	res := make([]*pb.UserMarketSeedListReply_List, 0)
	var (
		seed  []*Seed
		count int64
	)

	//return &pb.UserMarketSeedListReply{
	//	Status: "ok",
	//	Count:  uint64(count),
	//	List:   res,
	//}, nil

	seedStatus := []uint64{4}
	count, err = ac.userRepo.GetSeedByExUserIDCount(ctx, seedStatus, user.ID)
	if nil != err {
		return &pb.UserMarketSeedListReply{
			Status: "查询错误",
		}, nil
	}

	if 0 >= count {
		return &pb.UserMarketSeedListReply{
			Status: "ok",
			Count:  uint64(count),
			List:   res,
		}, nil
	}

	pageInit := 1
	if 1 < req.Page {
		pageInit = int(req.Page)
	}

	seed, err = ac.userRepo.GetSeedByExUserID(ctx, user.ID, seedStatus, &Pagination{
		PageNum:  pageInit,
		PageSize: 100,
	})
	if nil != err {
		return &pb.UserMarketSeedListReply{
			Status: "查询错误",
		}, nil
	}

	if 0 >= len(seed) {
		return &pb.UserMarketSeedListReply{
			Status: "ok",
			Count:  uint64(count),
			List:   res,
		}, nil
	}

	userIds := make([]uint64, 0)
	for _, vSeed := range seed {
		userIds = append(userIds, vSeed.UserId)
	}

	usersMap := make(map[uint64]*User)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserMarketSeedListReply{
			Status: "查询错误",
		}, nil
	}

	for _, vSeed := range seed {
		addressTmp := ""
		if _, ok := usersMap[vSeed.UserId]; ok {
			addressTmp = usersMap[vSeed.UserId].Address
		}

		res = append(res, &pb.UserMarketSeedListReply_List{
			Id:       vSeed.ID,
			Num:      vSeed.SeedId,
			Amount:   vSeed.SellAmount,
			OutMax:   vSeed.OutMaxAmount,
			Time:     vSeed.OutOverTime,
			Address:  addressTmp,
			Content:  "一种来自区块链世界算法加密的种子，打开盲盒或合成获得，每一颗种子都不同，找到适合他的土地后，会有惊人的产出！",
			EContent: "A seed from the blockchain world algorithm encryption, open the blind box or synthetic access, each seed is different, find suitable for his land, there will be amazing output!",
		})
	}

	return &pb.UserMarketSeedListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

// UserMarketLandList userMarketLandList.
func (ac *AppUsecase) UserMarketLandList(ctx context.Context, address string, req *pb.UserMarketLandListRequest) (*pb.UserMarketLandListReply, error) {
	var (
		user  *User
		err   error
		count int64
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserMarketLandListReply{
			Status: "不存在用户",
		}, nil
	}

	res := make([]*pb.UserMarketLandListReply_List, 0)
	var (
		land []*Land
	)
	landStatus := []uint64{4}

	count, err = ac.userRepo.GetLandByExUserIDCount(ctx, user.ID, landStatus)
	if nil != err {
		return &pb.UserMarketLandListReply{
			Status: "错误查询",
		}, nil
	}

	if 0 >= count {
		return &pb.UserMarketLandListReply{
			Status: "ok",
			Count:  uint64(count),
			List:   res,
		}, nil
	}

	pageInit := 1
	if 1 < req.Page {
		pageInit = int(req.Page)
	}

	land, err = ac.userRepo.GetLandByExUserIDOrdeSellAmount(ctx, user.ID, landStatus, &Pagination{
		PageNum:  pageInit,
		PageSize: 100,
	})
	if nil != err {
		return &pb.UserMarketLandListReply{
			Status: "错误查询",
		}, nil
	}

	if 0 >= len(land) {
		return &pb.UserMarketLandListReply{
			Status: "ok",
			Count:  uint64(count),
			List:   res,
		}, nil
	}

	userIds := make([]uint64, 0)
	for _, vLand := range land {
		userIds = append(userIds, vLand.UserId)
	}

	usersMap := make(map[uint64]*User)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserMarketLandListReply{
			Status: "错误查询",
		}, nil
	}

	for _, vLand := range land {
		addressTmp := ""
		if _, ok := usersMap[vLand.UserId]; ok {
			addressTmp = usersMap[vLand.UserId].Address
		}

		res = append(res, &pb.UserMarketLandListReply_List{
			Id:         vLand.ID,
			Level:      vLand.Level,
			MaxHealth:  vLand.MaxHealth,
			Amount:     vLand.SellAmount,
			PerHealth:  vLand.PerHealth,
			OutPutRate: uint64(vLand.OutPutRate),
			Address:    addressTmp,
			Content:    "在Magic Manor大陆最肥沃的土地，由神秘的地契合成，层叠强大的成长性，任何劣质的种子都可以得到茁壮的成长。",
			EContent:   "The most fertile land in the Magic Manorcontinent is composed of mysterious landdeeds. lt has strong growth potential, andany low-quality seeds can grow vigorously.",
		})
	}

	return &pb.UserMarketLandListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

// UserMarketPropList userMarketPropList.
func (ac *AppUsecase) UserMarketPropList(ctx context.Context, address string, req *pb.UserMarketPropListRequest) (*pb.UserMarketPropListReply, error) {
	var (
		user  *User
		err   error
		count int64
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserMarketPropListReply{
			Status: "不存在用户",
		}, nil
	}

	res := make([]*pb.UserMarketPropListReply_List, 0)
	var (
		prop []*Prop
	)
	propStatus := []uint64{4}

	// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
	count, err = ac.userRepo.GetPropsByExUserIDCount(ctx, propStatus, user.ID, req.PropType)
	if nil != err {
		return &pb.UserMarketPropListReply{
			Status: "错误查询",
		}, nil
	}

	pageInit := 1
	if 1 < req.Page {
		pageInit = int(req.Page)
	}

	// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
	prop, err = ac.userRepo.GetPropsByExUserID(ctx, user.ID, propStatus, &Pagination{
		PageNum:  pageInit,
		PageSize: 100,
	}, req.PropType)
	if nil != err {
		return &pb.UserMarketPropListReply{
			Status: "错误查询",
		}, nil
	}

	if 0 >= len(prop) {
		return &pb.UserMarketPropListReply{
			Status: "ok",
			Count:  uint64(count),
			List:   res,
		}, nil
	}

	userIds := make([]uint64, 0)
	for _, vProp := range prop {
		userIds = append(userIds, vProp.UserId)
	}

	usersMap := make(map[uint64]*User)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserMarketPropListReply{
			Status: "错误查询",
		}, nil
	}

	for _, v := range prop {
		addressTmp := ""
		if _, ok := usersMap[v.UserId]; ok {
			addressTmp = usersMap[v.UserId].Address
		}

		useNum := uint64(0)
		contentTmp := ""
		eContentTmp := ""
		if 12 == v.PropType {
			useNum = uint64(v.ThreeOne) // 水
			contentTmp = "一种植物在成长过程中也许会用到的特殊用水，缺水的植物会停止成长，使用后您的植物将永远不会缺水。"
			eContentTmp = "A plant may use special water duringits growth. Plants that are short ofwater will stop growing. After using it,your plants will never be short of water."
		} else if 13 == v.PropType {
			useNum = uint64(v.FiveOne) // 手套
			contentTmp = "带上手套后，可偷取任何邻居家的已经成熟的植物，可获得一定的ISPAY，但是使用的次数有限。"
			eContentTmp = "After wearing gloves, you can stealany mature plants from your neighbor'shouse and obtain a certain amount ofGlT, but the number of uses is limited."
		} else if 14 == v.PropType {
			useNum = uint64(v.FourOne) // 除虫剂
			contentTmp = "由Magic Manor大陆中的巫师制作，不除虫子的植物，每5分钟减产1%;直到最后为产量为0，它可以杀死Magic Manor大陆中的任何害虫。"
			eContentTmp = "Made by wizards in the Magic Manorcontinent, plants that do not eliminateinsects will reduce their yield by 1% every5 minutes; until the final yield is O, it can killany pests in the Magic Manor continent."
		} else if 15 == v.PropType {
			useNum = uint64(v.TwoOne) // 铲子
			contentTmp = "可铲除出租土地上已经成熟的植物，不可铲除自己种植的植物，但是成熟时间必须大于1H。"
			eContentTmp = "Mature plants on the leased land canbe eradicated, but self-grown plantscannot be eradicated, but the maturitytime must be greater than 1H."
		} else if 11 == v.PropType {
			contentTmp = "一种通过算法生成的增加产量道具，合成士地和增加土地肥沃度。"
			eContentTmp = "An algorithmically generated item thatincreases yield, synthesizes land, andincreases land fertility."
		} else if 17 == v.PropType {
			contentTmp = "在Magic Manor大陆深处埋徵着一张”地契”，它是初创统治者亲手制作，代表着整个Magic Manor最肥沃的土地，找到它的人不仅可以拥有土地，还能解锁谷中隐藏的古老秘密。\n\t\t获取方式:每新增1亿ISPAY产出业绩，自动获得1张地契:作用:1张地契加5块化肥，可合成一个崭新的1级土地;地契描述"
			eContentTmp = "There is a \"land deed\" buried deep in the Magic Manorcontinent. lt was made by the original ruler himself andrepresents the most fertile land in the entire MagicManor. Whoever finds it will not only claim the land, butalso unlock ancient secrets hidden within the valley.How to obtain: For every 100 milion new GlT outputs,you will automatically obtain a land deed;Function: 1 land deed and 5 fertilizers can be combinedinto a brand new level 1 land."
		}

		res = append(res, &pb.UserMarketPropListReply_List{
			Id:       v.ID,
			Num:      uint64(v.PropType),
			Amount:   v.SellAmount,
			UseMax:   useNum,
			Address:  addressTmp,
			Content:  contentTmp,
			EContent: eContentTmp,
		})
	}

	return &pb.UserMarketPropListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

// UserMarketRentLandList userMarketRentLandList.
func (ac *AppUsecase) UserMarketRentLandList(ctx context.Context, address string, req *pb.UserMarketRentLandListRequest) (*pb.UserMarketRentLandListReply, error) {
	var (
		user *User
		err  error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserMarketRentLandListReply{
			Status: "不存在用户",
		}, nil
	}

	res := make([]*pb.UserMarketRentLandListReply_List, 0)
	var (
		count int64
		land  []*Land
	)

	if 2 == req.RentType {
		var (
			landUserUse []*LandUserUse
		)

		landUserUse, err = ac.userRepo.GetLandUserUseByLandIDsUsing(ctx, user.ID)
		if nil != err {
			return &pb.UserMarketRentLandListReply{
				Status: "错误查询",
			}, nil
		}

		// 找出租用的种植信息
		landIds := make([]uint64, 0)
		for _, v := range landUserUse {
			if user.ID == v.OwnerUserId {
				continue
			}

			landIds = append(landIds, v.LandId)
		}

		if 0 >= len(landIds) {
			return &pb.UserMarketRentLandListReply{
				Status: "ok",
				Count:  0,
				List:   res,
			}, nil
		}

		land, err = ac.userRepo.GetLandByExUserIDByIds(ctx, landIds, nil)
		if nil != err {
			return &pb.UserMarketRentLandListReply{
				Status: "错误查询",
			}, nil
		}
	} else {
		landStatus := []uint64{3}
		count, err = ac.userRepo.GetLandByExUserIDCount(ctx, user.ID, landStatus)
		if nil != err {
			return &pb.UserMarketRentLandListReply{
				Status: "错误查询",
			}, nil
		}

		reqPage := 1
		if 0 < req.Page {
			reqPage = int(req.Page)
		}
		land, err = ac.userRepo.GetLandByExUserID(ctx, user.ID, landStatus, &Pagination{
			PageNum:  reqPage,
			PageSize: 100,
		})
		if nil != err {
			return &pb.UserMarketRentLandListReply{
				Status: "错误查询",
			}, nil
		}
	}

	if 0 >= len(land) {
		return &pb.UserMarketRentLandListReply{
			Status: "ok",
			Count:  0,
			List:   res,
		}, nil
	}

	userIds := make([]uint64, 0)
	for _, vLand := range land {
		if 0 < vLand.LocationUserId {
			userIds = append(userIds, vLand.LocationUserId)
		}

		userIds = append(userIds, vLand.UserId)
	}

	usersMap := make(map[uint64]*User)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserMarketRentLandListReply{
			Status: "错误查询",
		}, nil
	}

	for _, vLand := range land {
		addressTmp := ""
		addressTmpTwo := ""
		if _, ok := usersMap[vLand.UserId]; ok {
			addressTmp = usersMap[vLand.UserId].Address
			addressTmpTwo = usersMap[vLand.UserId].Address
		}

		if 0 < vLand.LocationUserId {
			if _, ok := usersMap[vLand.LocationUserId]; ok {
				addressTmpTwo = usersMap[vLand.LocationUserId].Address
			}
		}

		res = append(res, &pb.UserMarketRentLandListReply_List{
			Id:         vLand.ID,
			Level:      vLand.Level,
			MaxHealth:  vLand.MaxHealth,
			RentAmount: vLand.RentOutPutRate,
			Address:    addressTmp,
			AddressTwo: addressTmpTwo,
			OutPutRate: vLand.OutPutRate,
			PerHealth:  vLand.PerHealth,
			Content:    "在Magic Manor大陆最肥沃的土地，由神秘的地契合成，层叠强大的成长性，任何劣质的种子都可以得到茁壮的成长。",
			EContent:   "The most fertile land in the Magic Manorcontinent is composed of mysterious landdeeds. lt has strong growth potential, andany low-quality seeds can grow vigorously.",
		})
	}

	return &pb.UserMarketRentLandListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

// UserMyMarketList userMyMarketList.
func (ac *AppUsecase) UserMyMarketList(ctx context.Context, address string, req *pb.UserMyMarketListRequest) (*pb.UserMyMarketListReply, error) {
	res := make([]*pb.UserMyMarketListReply_List, 0)
	var (
		count int64
		user  *User
		err   error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserMyMarketListReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == req.Num {
		var (
			prop []*Prop
		)
		// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
		propStatus := []uint64{4}
		count, err = ac.userRepo.GetPropsByUserIDCount(ctx, propStatus, user.ID, 0)
		if nil != err {
			return &pb.UserMyMarketListReply{
				Status: "道具错误",
			}, nil
		}

		prop, err = ac.userRepo.GetPropsByUserID(ctx, user.ID, propStatus, 0, &Pagination{
			PageNum:  int(req.Page),
			PageSize: 100,
		})
		if nil != err {
			return &pb.UserMyMarketListReply{
				Status: "道具错误",
			}, nil
		}

		for _, vProp := range prop {

			useNum := uint64(0)
			contentTmp := ""
			eContentTmp := ""
			if 12 == vProp.PropType {
				useNum = uint64(vProp.ThreeOne) // 水
				contentTmp = "一种植物在成长过程中也许会用到的特殊用水，缺水的植物会停止成长，使用后您的植物将永远不会缺水。"
				eContentTmp = "A plant may use special water duringits growth. Plants that are short ofwater will stop growing. After using it,your plants will never be short of water."
			} else if 13 == vProp.PropType {
				useNum = uint64(vProp.FiveOne) // 手套
				contentTmp = "带上手套后，可偷取任何邻居家的已经成熟的植物，可获得一定的ISPAY，但是使用的次数有限。"
				eContentTmp = "After wearing gloves, you can stealany mature plants from your neighbor'shouse and obtain a certain amount ofGlT, but the number of uses is limited."
			} else if 14 == vProp.PropType {
				useNum = uint64(vProp.FourOne) // 除虫剂
				contentTmp = "由Magic Manor大陆中的巫师制作，不除虫子的植物，每5分钟减产1%;直到最后为产量为0，它可以杀死Magic Manor大陆中的任何害虫。"
				eContentTmp = "Made by wizards in the Magic Manorcontinent, plants that do not eliminateinsects will reduce their yield by 1% every5 minutes; until the final yield is O, it can killany pests in the Magic Manor continent."
			} else if 15 == vProp.PropType {
				useNum = uint64(vProp.TwoOne) // 铲子
				contentTmp = "可铲除出租土地上已经成熟的植物，不可铲除自己种植的植物，但是成熟时间必须大于1H。"
				eContentTmp = "Mature plants on the leased land canbe eradicated, but self-grown plantscannot be eradicated, but the maturitytime must be greater than 1H."
			} else if 11 == vProp.PropType {
				contentTmp = "一种通过算法生成的增加产量道具，合成士地和增加土地肥沃度。"
				eContentTmp = "An algorithmically generated item thatincreases yield, synthesizes land, andincreases land fertility."
			} else if 17 == vProp.PropType {
				contentTmp = "在Magic Manor大陆深处埋徵着一张”地契”，它是初创统治者亲手制作，代表着整个Magic Manor最肥沃的土地，找到它的人不仅可以拥有土地，还能解锁谷中隐藏的古老秘密。\n\t\t获取方式:每新增1亿ISPAY产出业绩，自动获得1张地契:作用:1张地契加5块化肥，可合成一个崭新的1级土地;地契描述"
				eContentTmp = "There is a \"land deed\" buried deep in the Magic Manorcontinent. lt was made by the original ruler himself andrepresents the most fertile land in the entire MagicManor. Whoever finds it will not only claim the land, butalso unlock ancient secrets hidden within the valley.How to obtain: For every 100 milion new GlT outputs,you will automatically obtain a land deed;Function: 1 land deed and 5 fertilizers can be combinedinto a brand new level 1 land."
			}

			res = append(res, &pb.UserMyMarketListReply_List{
				Id:         vProp.ID,
				Type:       2,
				Num:        uint64(vProp.PropType),
				UseNum:     useNum,
				OutMax:     0,
				Level:      0,
				Status:     0,
				MaxHealth:  0,
				Amount:     vProp.SellAmount,
				RentAmount: 0,
				Address:    address,
				Content:    contentTmp,
				EContent:   eContentTmp,
			})
		}
	} else if 2 == req.Num {
		var (
			seed []*Seed
		)
		seedStatus := []uint64{4}
		count, err = ac.userRepo.GetSeedByUserIDCount(ctx, seedStatus, user.ID)
		if nil != err {
			return &pb.UserMyMarketListReply{
				Status: "查询种子错误",
			}, nil
		}

		seed, err = ac.userRepo.GetSeedByUserID(ctx, user.ID, seedStatus, &Pagination{
			PageNum:  int(req.Page),
			PageSize: 100,
		})
		if nil != err {
			return &pb.UserMyMarketListReply{
				Status: "查询种子错误",
			}, nil
		}

		for _, vSeed := range seed {
			res = append(res, &pb.UserMyMarketListReply_List{
				Id:         vSeed.ID,
				Type:       1,
				Num:        vSeed.SeedId,
				UseNum:     0,
				OutMax:     vSeed.OutMaxAmount,
				Level:      0,
				Status:     0,
				MaxHealth:  0,
				Amount:     vSeed.SellAmount,
				RentAmount: 0,
				Time:       vSeed.OutOverTime,
				Address:    address,
				Content:    "一种来自区块链世界算法加密的种子，打开盲盒或合成获得，每一颗种子都不同，找到适合他的土地后，会有惊人的产出！",
				EContent:   "A seed from the blockchain world algorithm encryption, open the blind box or synthetic access, each seed is different, find suitable for his land, there will be amazing output!",
			})
		}
	} else if 3 == req.Num {
		var (
			land []*Land
		)
		landStatus := []uint64{3, 4, 8}
		count, err = ac.userRepo.GetLandByUserIDCount(ctx, user.ID, landStatus)
		if nil != err {
			return &pb.UserMyMarketListReply{
				Status: "错误查询",
			}, nil
		}

		land, err = ac.userRepo.GetLandByUserID(ctx, user.ID, landStatus, &Pagination{
			PageNum:  int(req.Page),
			PageSize: 100,
		})
		if nil != err {
			return &pb.UserMyMarketListReply{
				Status: "错误查询",
			}, nil
		}

		for _, vLand := range land {
			statusTmp := uint64(1)
			if 4 == vLand.Status {
				statusTmp = 2
			}

			res = append(res, &pb.UserMyMarketListReply_List{
				Id:         vLand.ID,
				Type:       3,
				Num:        0,
				UseNum:     0,
				OutMax:     0,
				Level:      vLand.Level,
				Status:     statusTmp,
				MaxHealth:  vLand.MaxHealth,
				Amount:     vLand.SellAmount,
				RentAmount: vLand.RentOutPutRate,
				PerHealth:  vLand.PerHealth,
				OutPutRate: uint64(vLand.OutPutRate),
				Address:    address,
				Content:    "在Magic Manor大陆最肥沃的土地，由神秘的地契合成，层叠强大的成长性，任何劣质的种子都可以得到茁壮的成长。",
				EContent:   "The most fertile land in the Magic Manorcontinent is composed of mysterious landdeeds. lt has strong growth potential, andany low-quality seeds can grow vigorously.",
			})
		}
	} else {

	}

	return &pb.UserMyMarketListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

// UserNoticeList NoticeList.
func (ac *AppUsecase) UserNoticeList(ctx context.Context, address string, req *pb.UserNoticeListRequest) (*pb.UserNoticeListReply, error) {
	var (
		user *User
		err  error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserNoticeListReply{
			Status: "不存在用户",
		}, nil
	}

	res := make([]*pb.UserNoticeListReply_List, 0)

	var (
		notice []*Notice
		count  int64
	)

	count, err = ac.userRepo.GetNoticesCountByUserID(ctx, user.ID)
	if nil != err {
		return &pb.UserNoticeListReply{
			Status: "推荐错误查询",
		}, nil
	}

	notice, err = ac.userRepo.GetNoticesByUserID(ctx, user.ID, &Pagination{
		PageNum:  int(req.Page),
		PageSize: 20,
	})
	if nil != err {
		return &pb.UserNoticeListReply{
			Status: "错误查询",
		}, nil
	}

	for _, vNotice := range notice {
		res = append(res, &pb.UserNoticeListReply_List{
			EContent:  vNotice.NoticeContentTwo,
			Content:   vNotice.NoticeContent,
			CreatedAt: vNotice.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
		})
	}

	return &pb.UserNoticeListReply{
		Count:  uint64(count),
		List:   res,
		Status: "ok",
	}, nil
}

// UserStakeRewardList userStakeRewardList.
func (ac *AppUsecase) UserStakeRewardList(ctx context.Context, address string, req *pb.UserStakeRewardListRequest) (*pb.UserStakeRewardListReply, error) {
	var (
		user *User
		err  error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserStakeRewardListReply{
			Status: "不存在用户",
		}, nil
	}

	res := make([]*pb.UserStakeRewardListReply_List, 0)

	var (
		stakeGetPlayRecord []*StakeGetPlayRecord
		count              int64
	)

	count, err = ac.userRepo.GetStakeGetPlayRecordCount(ctx, user.ID, 0)
	if nil != err {
		return &pb.UserStakeRewardListReply{
			Status: "推荐错误查询",
		}, nil
	}

	stakeGetPlayRecord, err = ac.userRepo.GetStakeGetPlayRecordsByUserID(ctx, user.ID, 0, &Pagination{
		PageNum:  int(req.Page),
		PageSize: 20,
	})
	if nil != err {
		return &pb.UserStakeRewardListReply{
			Status: "错误查询",
		}, nil
	}

	userIds := make([]uint64, 0)
	for _, v := range stakeGetPlayRecord {
		userIds = append(userIds, v.UserId)
	}

	usersMap := make(map[uint64]*User)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserStakeRewardListReply{
			Status: "错误查询",
		}, nil
	}

	for _, v := range stakeGetPlayRecord {
		addressTmp := ""
		if _, ok := usersMap[v.UserId]; ok {
			addressTmp = usersMap[v.UserId].Address
		}

		res = append(res, &pb.UserStakeRewardListReply_List{
			Address: addressTmp,
			Content: "",
			Amount:  v.Amount,
			Reward:  fmt.Sprintf("%.3f", v.Reward),
			Status:  uint64(v.Status),
		})
	}

	return &pb.UserStakeRewardListReply{
		Count:  uint64(count),
		List:   res,
		Status: "ok",
	}, nil
}

// UserIndexList UserIndexList.
func (ac *AppUsecase) UserIndexList(ctx context.Context, address string, req *pb.UserIndexListRequest) (*pb.UserIndexListReply, error) {
	res := make([]*pb.UserIndexListReply_List, 0)
	var (
		user     *User
		lands    []*Land
		landsTwo []*Land
		reqUser  *User
		err      error
	)

	reqUser, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == reqUser {
		return &pb.UserIndexListReply{
			Status: "不存在用户",
		}, nil
	}

	if 20 < len(req.Address) {
		address = req.Address
	}

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserIndexListReply{
			Status: "不存在用户",
		}, nil
	}

	status := []uint64{1, 2, 3, 8}
	lands, err = ac.userRepo.GetLandByUserIDUsing(ctx, user.ID, status)
	if nil != err {
		return &pb.UserIndexListReply{
			Status: "错误查询",
		}, nil
	}

	landsTwo, err = ac.userRepo.GetLandByLocationUserIDUsing(ctx, user.ID, status)
	if nil != err {
		return &pb.UserIndexListReply{
			Status: "错误查询",
		}, nil
	}

	for _, vLand := range landsTwo {
		lands = append(lands, vLand)
	}

	landIds := make([]uint64, 0)
	userIds := make([]uint64, 0)
	for _, vLand := range lands {
		userIds = append(userIds, vLand.UserId)
		landIds = append(landIds, vLand.ID)
	}

	var (
		landUserUse map[uint64]*LandUserUse
	)
	landUserUse, err = ac.userRepo.GetLandUserUseByLandIDsMapUsing(ctx, user.ID, landIds)
	if nil != err {
		return &pb.UserIndexListReply{
			Status: "错误查询",
		}, nil
	}

	for _, vLand := range landUserUse {
		userIds = append(userIds, vLand.UserId)
	}

	usersMap := make(map[uint64]*User)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.UserIndexListReply{
			Status: "错误查询",
		}, nil
	}

	resTmp := make(map[uint64]*pb.UserIndexListReply_List, 0)
	now := time.Now().Unix()
	for _, vLand := range lands {
		plantUserAddressTmp := ""
		landUserAddress := ""
		if _, ok3 := usersMap[vLand.UserId]; ok3 {
			landUserAddress = usersMap[vLand.UserId].Address
		}

		if _, ok := landUserUse[vLand.ID]; ok {
			if _, ok2 := usersMap[landUserUse[vLand.ID].UserId]; ok2 {
				plantUserAddressTmp = usersMap[landUserUse[vLand.ID].UserId].Address
			}

			tmpRewardStatus := uint64(2)
			rewardTmp := float64(0)
			statusTmp := uint64(1)
			if 0 != landUserUse[vLand.ID].One {
				if landUserUse[vLand.ID].One <= uint64(now) {
					statusTmp = 3
				}

			} else if 0 != landUserUse[vLand.ID].Two {
				if landUserUse[vLand.ID].Two <= uint64(now) {
					statusTmp = 2
				}

				// 有虫子但是已经结束
				if landUserUse[vLand.ID].OverTime <= uint64(now) {
					if uint64(now) > landUserUse[vLand.ID].Two {
						tmp := landUserUse[vLand.ID].OutMaxNum * 0.01 * float64(uint64(now)-landUserUse[vLand.ID].Two) / 300

						if tmp >= landUserUse[vLand.ID].OutMaxNum {
							rewardTmp = 0
						} else {
							rewardTmp = landUserUse[vLand.ID].OutMaxNum - tmp
						}
					}

					tmpRewardStatus = 1
				}
			} else {
				if landUserUse[vLand.ID].OverTime <= uint64(now) {
					rewardTmp = landUserUse[vLand.ID].OutMaxNum
					tmpRewardStatus = 1
				}
			}

			tmpOneOne := uint64(0)
			//if 0 < landUserUse[vLand.ID].SubTime {
			//	tmpOneOne = 1
			//}

			resTmp[vLand.LocationNum] = &pb.UserIndexListReply_List{
				LocationNum:      vLand.LocationNum,
				LandId:           vLand.ID,
				LandLevel:        vLand.Level,
				Health:           vLand.MaxHealth,
				OutRate:          vLand.OutPutRate,
				PerHealth:        vLand.PerHealth,
				LandUseId:        landUserUse[vLand.ID].ID,
				SeedId:           landUserUse[vLand.ID].SeedTypeId,
				Start:            landUserUse[vLand.ID].BeginTime,
				End:              landUserUse[vLand.ID].OverTime,
				CurrentTime:      uint64(now),
				Status:           statusTmp,
				Reward:           rewardTmp,
				PlantUserAddress: plantUserAddressTmp,
				RewardStatus:     tmpRewardStatus,
				LandStatus:       vLand.Status,
				OneOne:           tmpOneOne,
				LandUserAddress:  landUserAddress,
			}
		} else {
			// 过期的从放置在移除
			if 1 == vLand.Status || 3 == vLand.Status {
				if vLand.LimitDate <= uint64(time.Now().Unix()) {
					if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
						return ac.userRepo.LandPullTwo(ctx, vLand.ID, user.ID)
					}); nil != err {
						fmt.Println(err, "首页触发的，过期土地回收", user)
					}

					continue
				}
			}

			tmpCanUnLand := uint64(0)
			if 1 == vLand.Status && reqUser.ID == vLand.UserId {
				tmpCanUnLand = 1
			}

			resTmp[vLand.LocationNum] = &pb.UserIndexListReply_List{
				LocationNum:      vLand.LocationNum,
				LandId:           vLand.ID,
				LandLevel:        vLand.Level,
				Health:           vLand.MaxHealth,
				OutRate:          vLand.OutPutRate,
				PerHealth:        vLand.PerHealth,
				LandStatus:       vLand.Status,
				LandUseId:        0,
				SeedId:           0,
				Start:            0,
				End:              0,
				CurrentTime:      0,
				Status:           0,
				Reward:           0,
				PlantUserAddress: plantUserAddressTmp,
				RewardStatus:     2,
				CanUnLand:        tmpCanUnLand,
				LandUserAddress:  landUserAddress,
			}
		}
	}

	for i := uint64(1); i <= 9; i++ {
		if _, ok := resTmp[i]; !ok {
			res = append(res, &pb.UserIndexListReply_List{
				LocationNum:      0,
				LandId:           0,
				LandLevel:        0,
				Health:           0,
				OutRate:          0,
				PerHealth:        0,
				LandUseId:        0,
				SeedId:           0,
				Start:            0,
				End:              0,
				CurrentTime:      0,
				Status:           0,
				Reward:           0,
				PlantUserAddress: "",
				LandUserAddress:  "",
			})
		} else {
			res = append(res, resTmp[i])
		}
	}

	return &pb.UserIndexListReply{
		Status: "ok",
		Count:  9,
		List:   res,
	}, nil
}

// UserRankList UserRankList.
func (ac *AppUsecase) UserRankList(ctx context.Context, address string, req *pb.UserOrderListRequest) (*pb.UserOrderListReply, error) {

	var (
		err     error
		users   []*User
		g1      float64
		g2      float64
		g3      float64
		g4      float64
		g5      float64
		g6      float64
		g7      float64
		g8      float64
		configs []*Config
	)
	users, err = ac.userRepo.GetUsersLimitUsdtTotal(ctx)
	if nil != err {
		return &pb.UserOrderListReply{
			Status: "查询错误",
		}, nil
	}

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"g_1",
		"g_2",
		"g_3",
		"g_4",
		"g_5",
		"g_6",
		"g_7",
		"g_8",
	)
	if nil != err || nil == configs {
		return &pb.UserOrderListReply{
			Status: "查询错误",
		}, nil
	}
	for _, vConfig := range configs {
		if "g_1" == vConfig.KeyName {
			g1, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "g_2" == vConfig.KeyName {
			g2, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "g_3" == vConfig.KeyName {
			g3, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "g_4" == vConfig.KeyName {
			g4, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "g_5" == vConfig.KeyName {
			g5, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "g_6" == vConfig.KeyName {
			g6, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "g_7" == vConfig.KeyName {
			g7, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "g_8" == vConfig.KeyName {
			g8, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	var (
		yAmount uint64
	)
	yAmount, err = ac.userRepo.GetSumEthTwoFour(ctx)
	if nil != err {
		fmt.Println("今日分红错误用户获取失败3")
		return &pb.UserOrderListReply{
			Status: "查询错误",
		}, nil
	}

	//fmt.Println("昨日入u", yAmount)
	var (
		yAmountTwo uint64
	)
	yAmountTwo, err = ac.userRepo.GetSumEthTwo(ctx)
	if nil != err {
		fmt.Println("今日分红错误用户获取失败4")
		return &pb.UserOrderListReply{
			Status: "查询错误",
		}, nil
	}
	//fmt.Println("前日入u", yAmountTwo)

	tmpTotal := float64(yAmount)*0.03 + float64(yAmountTwo)*0.02
	//fmt.Println("合计", tmpTotal)

	res := make([]*pb.UserOrderListReply_List, 0)
	for k, v := range users {
		if 0.0001 > v.AmountUsdtTotal {
			continue
		}

		var tmpReward float64
		if 0 == k {
			tmpReward = g1 * tmpTotal
		} else if 1 == k {
			tmpReward = g2 * tmpTotal
		} else if 2 == k {
			tmpReward = g3 * tmpTotal
		} else if 3 == k {
			tmpReward = g4 * tmpTotal
		} else if 4 == k {
			tmpReward = g5 * tmpTotal
		} else if 5 == k {
			tmpReward = g6 * tmpTotal
		} else if 6 == k {
			tmpReward = g7 * tmpTotal
		} else if 7 == k {
			tmpReward = g8 * tmpTotal
		}

		res = append(res, &pb.UserOrderListReply_List{
			Address: v.Address,
			Git:     v.AmountUsdtTotal,
			Red:     0,
			Rate:    tmpReward,
		})
	}

	return &pb.UserOrderListReply{
		Count:  8,
		List:   res,
		Status: "ok",
	}, nil
}
func (ac *AppUsecase) UserTeamDepositList(ctx context.Context, address string, req *pb.UserTeamDepositListRequest) (*pb.UserTeamDepositListReply, error) {
	var (
		count int64
		err   error
	)

	var (
		user *User
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserTeamDepositListReply{
			Status: "不存在用户",
		}, nil
	}

	// 推荐
	var (
		userRecommend *UserRecommend
	)
	userRecommend, err = ac.userRepo.GetUserRecommendByUserId(ctx, user.ID)
	if nil == userRecommend || nil != err {
		return &pb.UserTeamDepositListReply{
			Status: "查询推荐错误",
		}, nil
	}

	var (
		reward []*EthRecordTwo
	)
	count, err = ac.userRepo.GetRecordPageCountTwo(ctx, userRecommend.RecommendCode+"D"+strconv.FormatUint(user.ID, 10))
	if nil != err {
		return &pb.UserTeamDepositListReply{
			Status: "不存在数据L，count",
		}, nil
	}

	reward, err = ac.userRepo.GetRecordPageTwo(ctx, userRecommend.RecommendCode+"D"+strconv.FormatUint(user.ID, 10), &Pagination{
		PageNum:  int(req.Page),
		PageSize: 20,
	})
	if nil != err {
		return &pb.UserTeamDepositListReply{
			Status: "不存在数据L",
		}, nil
	}

	res := make([]*pb.UserTeamDepositListReply_List, 0)
	for _, v := range reward {
		res = append(res, &pb.UserTeamDepositListReply_List{
			Amount:    float64(v.Amount),
			Address:   v.Address,
			CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
		})
	}

	return &pb.UserTeamDepositListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

func (ac *AppUsecase) UserRewardList(ctx context.Context, address string, req *pb.UserRewardListRequest) (*pb.UserRewardListReply, error) {
	res := make([]*pb.UserRewardListReply_List, 0)
	var (
		count int64
		err   error
	)

	var (
		user *User
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserRewardListReply{
			Status: "不存在用户",
		}, nil
	}

	var (
		reward []*Reward
	)
	count, err = ac.userRepo.GetUserRewardAdminPageCount(ctx, user.ID, 27)
	if nil != err {
		return &pb.UserRewardListReply{
			Status: "不存在数据L，count",
		}, nil
	}

	reward, err = ac.userRepo.GetUserRewardAdminPage(ctx, user.ID, 27, &Pagination{
		PageNum:  int(req.Page),
		PageSize: 20,
	})
	if nil != err {
		return &pb.UserRewardListReply{
			Status: "不存在数据L",
		}, nil
	}

	userIds := make([]uint64, 0)
	for _, v := range reward {
		userIds = append(userIds, v.UserId)
		if 0 >= v.One {
			continue
		}

		userIds = append(userIds, v.One)
	}

	usersMap := make(map[uint64]*User, 0)
	if 0 < len(userIds) {
		usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
		if nil != err {
			return &pb.UserRewardListReply{
				Status: "不存在数据L",
			}, nil
		}
	}

	for _, v := range reward {
		addressTmp := ""
		if 0 < v.One {
			if _, ok := usersMap[v.One]; ok {
				addressTmp = usersMap[v.One].Address
			}
		}

		res = append(res, &pb.UserRewardListReply_List{
			Amount:      v.Amount,
			IspayAmount: v.Three,
			Address:     addressTmp,
			Vip:         v.Two,
			CreatedAt:   v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
		})
	}

	return &pb.UserRewardListReply{
		Status: "ok",
		Count:  uint64(count),
		List:   res,
	}, nil
}

// UserOrderListTwo userOrderListTwo.
func (ac *AppUsecase) UserOrderListTwo(ctx context.Context, address string, req *pb.UserOrderListRequest) (*pb.UserOrderListReply, error) {
	if 15 < len(req.Address) && len(req.Address) > 100 {
		return &pb.UserOrderListReply{
			Status: "参数错误",
		}, nil
	}
	var (
		user *User
		err  error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserOrderListReply{
			Status: "不存在用户",
		}, nil
	}

	var (
		count       int64
		users       []*User
		landUserUse []*LandUserUse
	)

	res := make([]*pb.UserOrderListReply_List, 0)

	if 15 < len(req.Address) {
		users, err = ac.userRepo.GetUserOrder(ctx, nil, req.Address)
		if nil != err {
			return &pb.UserOrderListReply{
				Status: "查询错误",
			}, nil
		}

		count = int64(len(users))

		for _, v := range users {
			res = append(res, &pb.UserOrderListReply_List{
				Address: v.Address,
			})
		}
	} else {
		count, err = ac.userRepo.GetLandUserUseOrderByTimeCount(ctx)
		if nil != err {
			return &pb.UserOrderListReply{
				Status: "查询错误",
			}, nil
		}

		landUserUse, err = ac.userRepo.GetLandUserUseOrderByTime(ctx, &Pagination{
			PageNum:  int(req.Page),
			PageSize: 20,
		})
		if nil != err {
			return &pb.UserOrderListReply{
				Status: "查询错误",
			}, nil
		}

		userIds := make([]uint64, 0)
		rewardIds := make([]uint64, 0)
		for _, v := range landUserUse {
			userIds = append(userIds, v.UserId)
			rewardIds = append(rewardIds, v.ID)
		}

		var (
			userMap map[uint64]*User
			rewards map[uint64]*Reward
		)
		userMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
		if nil != err {
			return &pb.UserOrderListReply{
				Status: "查询错误",
			}, nil
		}

		rewards, err = ac.userRepo.GetRewardByTwo(ctx, rewardIds, user.ID)
		if nil != err {
			return &pb.UserOrderListReply{
				Status: "查询错误",
			}, nil
		}
		for _, v := range landUserUse {
			if _, ok := userMap[v.UserId]; !ok {
				continue
			}

			tmpRed := uint64(0)
			if _, ok := rewards[v.ID]; ok {
				tmpRed = 1
			}

			res = append(res, &pb.UserOrderListReply_List{
				Address: userMap[v.UserId].Address,
				Red:     tmpRed,
			})
		}
	}

	return &pb.UserOrderListReply{
		Count:  uint64(count),
		List:   res,
		Status: "ok",
	}, nil
}

// UserOrderList userOrderList.
func (ac *AppUsecase) UserOrderList(ctx context.Context, address string, req *pb.UserOrderListRequest) (*pb.UserOrderListReply, error) {
	if 15 < len(req.Address) && len(req.Address) > 100 {
		return &pb.UserOrderListReply{
			Status: "参数错误",
		}, nil
	}

	var (
		user *User
		err  error
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.UserOrderListReply{
			Status: "不存在用户",
		}, nil
	}

	var (
		count int64
		users []*User
	)
	if 15 < len(req.Address) {
		users, err = ac.userRepo.GetUserOrder(ctx, nil, req.Address)
		if nil != err {
			return &pb.UserOrderListReply{
				Status: "查询错误",
			}, nil
		}

		count = int64(len(users))
	} else {
		count, err = ac.userRepo.GetUserOrderCount(ctx)
		if nil != err {
			return &pb.UserOrderListReply{
				Status: "查询错误",
			}, nil
		}

		users, err = ac.userRepo.GetUserOrder(ctx, &Pagination{
			PageNum:  int(req.Page),
			PageSize: 20,
		}, "")
		if nil != err {
			return &pb.UserOrderListReply{
				Status: "查询错误",
			}, nil
		}
	}

	var (
		landUserUse map[uint64]*LandUserUse
		userRed     map[uint64]bool
	)
	landUserUse, err = ac.userRepo.GetLandMyUseByLandIDsMapUsing(ctx, user.ID)
	if nil != err {
		return &pb.UserOrderListReply{
			Status: "错误查询",
		}, nil
	}

	current := time.Now().Unix()
	userRed = make(map[uint64]bool, 0)
	for _, v := range landUserUse {
		if uint64(current) < v.OverTime {
			continue
		}

		if 0 != v.One {
			continue
		}

		if user.ID == v.IsUseOther {
			continue
		}

		// 已结束
		userRed[v.IsUseOther] = true
	}

	res := make([]*pb.UserOrderListReply_List, 0)

	for _, v := range users {
		tmpRed := uint64(0)
		if _, ok := userRed[v.ID]; ok {
			tmpRed = 1
		}
		res = append(res, &pb.UserOrderListReply_List{
			Address: v.Address,
			Git:     v.Git,
			Red:     tmpRed,
		})
	}

	return &pb.UserOrderListReply{
		Count:  uint64(count),
		List:   res,
		Status: "ok",
	}, nil
}

// 随机数生成器的初始化锁
var rngMutexBuyBox sync.Mutex

func (ac *AppUsecase) BuyBox(ctx context.Context, address string, req *pb.BuyBoxRequest) (*pb.BuyBoxReply, error) {
	var (
		user             *User
		err              error
		boxNum           uint64
		boxSellNum       uint64
		boxSellNumOrigin string
		configs          []*Config
		boxMax           uint64
		boxAmount        float64
		boxStart         string
		boxEnd           string
		//uPrice           float64
	)
	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.BuyBoxReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.BuyBoxReply{
			Status: "锁定用户",
		}, nil
	}

	rngMutexBuyBox.Lock()
	defer rngMutexBuyBox.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.BuyBoxReply{
			Status: "不存在用户",
		}, nil
	}

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"box_num",
		"box_max",
		"box_sell_num",
		"box_start",
		"box_end",
		"box_amount",
		"u_price",
	)
	if nil != err || nil == configs {
		return &pb.BuyBoxReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "box_num" == vConfig.KeyName {
			boxNum, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		if "box_sell_num" == vConfig.KeyName {
			boxSellNum, _ = strconv.ParseUint(vConfig.Value, 10, 64)
			boxSellNumOrigin = vConfig.Value
		}
		if "box_start" == vConfig.KeyName {
			boxStart = vConfig.Value
		}
		if "box_end" == vConfig.KeyName {
			boxEnd = vConfig.Value
		}
		if "box_amount" == vConfig.KeyName {
			boxAmount, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "box_max" == vConfig.KeyName {
			boxMax, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		//if "u_price" == vConfig.KeyName {
		//	uPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
	}
	// 解析时间字符串

	var (
		parsedboxStart time.Time
		parsedboxEnd   time.Time
	)
	parsedboxStart, err = time.Parse("2006-01-02 15:04:05", boxStart)
	if err != nil {
		return &pb.BuyBoxReply{
			Status: "解析时间失败",
		}, nil
	}

	parsedboxEnd, err = time.Parse("2006-01-02 15:04:05", boxEnd)
	if err != nil {
		return &pb.BuyBoxReply{
			Status: "解析时间失败",
		}, nil
	}

	// 获取当前时间
	now := time.Now()

	// 比较时间
	if now.After(parsedboxEnd) {
		return &pb.BuyBoxReply{
			Status: "已结束",
		}, nil
	}

	if now.Before(parsedboxStart) {
		return &pb.BuyBoxReply{
			Status: "未开始",
		}, nil
	}

	if boxSellNum >= boxMax {
		return &pb.BuyBoxReply{
			Status: "已售空",
		}, nil
	}

	//if 0 >= uPrice {
	//	return &pb.BuyBoxReply{
	//		Status: "价格biw:u错误",
	//	}, nil
	//}

	//boxAmount = boxAmount / uPrice
	if boxAmount > user.AmountUsdt {
		return &pb.BuyBoxReply{
			Status:    "余额不足",
			StatusTwo: "Not enough balance.",
		}, nil
	}

	tmpSellNumNew := strconv.FormatUint(boxSellNum+1, 10)
	//fmt.Println(boxSellNum, tmpSellNumNew)
	boxId := uint64(0)
	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		boxId, err = ac.userRepo.BuyBox(ctx, boxAmount, boxSellNumOrigin, tmpSellNumNew, &BoxRecord{
			UserId: user.ID,
			Num:    boxNum,
		})
		if nil != err {
			return err
		}

		err = ac.userRepo.CreateNotice(
			ctx,
			user.ID,
			"您花费"+fmt.Sprintf("%.2f", boxAmount)+"USDT购买了盲盒",
			"You've used "+fmt.Sprintf("%.2f", boxAmount)+" USDT buy box",
		)
		if nil != err {
			return err
		}

		return nil
	}); nil != err {
		fmt.Println(err, "buybox", user)
		return &pb.BuyBoxReply{
			Status: "购买失败",
		}, nil
	}

	return &pb.BuyBoxReply{
		Status: "ok",
		Id:     boxId,
	}, nil
}

// 随机数生成器
var rngBox *rand2.Rand
var rngPlant *rand2.Rand
var rngPlay *rand2.Rand

// 随机数生成器的初始化锁
var rngMutexBox sync.Mutex

func (ac *AppUsecase) OpenBox(ctx context.Context, address string, req *pb.OpenBoxRequest) (*pb.OpenBoxReply, error) {
	var (
		user *User
		box  *BoxRecord
		//userBox []*BoxRecord
		err error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.OpenBoxReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.OpenBoxReply{
			Status: "锁定用户",
		}, nil
	}

	rngMutexBox.Lock()
	defer rngMutexBox.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.OpenBoxReply{
			Status: "不存在用户",
		}, nil
	}

	//if 0 >= user.OpenBoxAmount {
	//	return &pb.OpenBoxReply{
	//		Status: "stake ispay not enough|质押ispay额度太少",
	//	}, nil
	//}

	box, err = ac.userRepo.GetUserBoxRecordById(ctx, req.SendBody.Id)
	if nil != err || nil == box {
		return &pb.OpenBoxReply{
			Status: "不存在盲盒",
		}, nil
	}

	if user.ID != box.UserId {
		return &pb.OpenBoxReply{
			Status: "非用户盲盒",
		}, nil
	}

	if 0 != box.GoodId {
		return &pb.OpenBoxReply{
			Status: "已开盲盒",
		}, nil
	}

	var (
		configs []*Config
		//priceOpen    float64
		//priceOpenUse uint64
		usdtAmount   float64
		stakePrice   float64
		stakePriceOn uint64
	)

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"open_box_price",
		"open_box_price_use",
		"box_amount",
		"stake_price",
		"stake_price_on",
	)
	if nil != err || nil == configs {
		return &pb.OpenBoxReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		//if "open_box_price" == vConfig.KeyName {
		//	priceOpen, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//
		//if "open_box_price_use" == vConfig.KeyName {
		//	priceOpenUse, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		//}

		if "box_amount" == vConfig.KeyName {
			usdtAmount, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "stake_price" == vConfig.KeyName {
			stakePrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "stake_price_on" == vConfig.KeyName {
			stakePriceOn, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
	}

	var ispay float64
	if 1 == stakePriceOn {
		ispay = usdtAmount / stakePrice
	} else {
		//var (
		//	tmp0 float64
		//	tmp1 float64
		//)
		//tmp0, tmp1, err = GetReservers()
		//if nil != err || 1 >= tmp0 || 1 >= tmp1 {
		//	return &pb.OpenBoxReply{
		//		Status: "获取交易池数据失败",
		//	}, nil
		//}

		var (
			newIspayPrice float64
		)
		newIspayPrice, err = GetIspayPrice()
		if nil != err || 0.0000001 > newIspayPrice {
			fmt.Println(err, newIspayPrice, "err open box ispay price")
			return &pb.OpenBoxReply{
				Status: "获取交易池数据失败",
			}, nil
		}

		ispay = usdtAmount / newIspayPrice
	}

	if 0 >= ispay {
		return &pb.OpenBoxReply{
			Status: "配置错误",
		}, nil
	}

	//userBox, err = ac.userRepo.GetBoxRecordByUserId(ctx, user.ID)
	//if nil != err {
	//	return &pb.OpenBoxReply{
	//		Status: "不存在盲盒",
	//	}, nil
	//}

	//if 0 < len(userBox) {
	//if user.OpenBoxAmount < ispay*float64(len(userBox)) {
	//	return &pb.OpenBoxReply{
	//		Status: "stake ispay not enough|质押ispay额度太少",
	//	}, nil
	//}
	//}

	// 盲盒道具池
	blindBoxItems := make([]struct {
		Name   uint64
		Weight float64
	}, 0)

	var (
		seedInfos    []*SeedInfo
		seedInfosMap map[uint64]*SeedInfo
	)
	seedInfos, err = ac.userRepo.GetAllSeedInfo(ctx)
	if nil != err {
		return &pb.OpenBoxReply{
			Status: "异常配置",
		}, nil
	}

	seedInfosMap = make(map[uint64]*SeedInfo)
	for _, v := range seedInfos {
		seedInfosMap[v.ID] = v

		blindBoxItems = append(blindBoxItems, struct {
			Name   uint64
			Weight float64
		}{Name: v.ID, Weight: v.GetRate})
	}

	var (
		//	propInfos    []*PropInfo
		propInfosMap map[uint64]*PropInfo
	)
	//propInfos, err = ac.userRepo.GetAllPropInfo(ctx)
	//if nil != err {
	//	return &pb.OpenBoxReply{
	//		Status: "异常配置",
	//	}, nil
	//}
	//
	propInfosMap = make(map[uint64]*PropInfo)
	//for _, v := range propInfos {
	//	propInfosMap[v.PropType] = v
	//
	//	blindBoxItems = append(blindBoxItems, struct {
	//		Name   uint64
	//		Weight float64
	//	}{Name: v.PropType, Weight: v.GetRate})
	//}

	if 0 >= len(blindBoxItems) {
		return &pb.OpenBoxReply{
			Status: "异常配置概率",
		}, nil
	}

	if nil == rngBox {
		var (
			seedInt     int64
			randomSeeds []*RandomSeed
		)
		randomSeeds, err = ac.userRepo.GetAllRandomSeeds(ctx)
		if nil != err {
			return &pb.OpenBoxReply{
				Status: "异常",
			}, nil
		}

		for _, v := range randomSeeds {
			if 1 == v.Scene {
				seedInt = int64(v.SeedValue)
				break
			}
		}

		if 0 >= seedInt {
			seedInt = time.Now().UnixNano()
			err = ac.userRepo.UpdateSeedValue(ctx, 1, uint64(seedInt))
			if nil != err {
				return &pb.OpenBoxReply{
					Status: "异常",
				}, nil
			}
		}

		rngBox = rand2.New(rand2.NewSource(seedInt))
	}

	r := rngBox.Float64() // 生成 0.0 ~ 1.0 之间的随机数
	// 计算总权重
	var totalWeight float64
	for _, item := range blindBoxItems {
		totalWeight += item.Weight
	}

	// 按照概率随机选择
	result := uint64(0)
	var sum float64
	for _, item := range blindBoxItems {
		sum += item.Weight / totalWeight // 归一化
		if r < sum {
			result = item.Name
			break
		}
	}

	if 0 >= result || 15 < result {
		return &pb.OpenBoxReply{
			Status: "错误盲盒",
		}, nil
	}

	if 1 <= result && result <= 10 {
		if _, ok := seedInfosMap[result]; !ok {
			return &pb.OpenBoxReply{
				Status: "不存在盲盒信息",
			}, nil
		}
		rngTmp := rand2.New(rand2.NewSource(time.Now().UnixNano()))

		outMin := int64(seedInfosMap[result].OutMinAmount)
		outMax := int64(seedInfosMap[result].OutMaxAmount)

		// 计算随机范围
		tmpNum := outMax - outMin
		if tmpNum <= 0 {
			tmpNum = 1 // 避免 Int63n(0) panic
		}

		// 生成随机数
		randomNumber := outMin + rngTmp.Int63n(tmpNum)

		// 种子
		boxId := uint64(0)
		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			boxId, err = ac.userRepo.OpenBoxSeed(ctx, box.ID, user.ID, "获得种子", ispay, &Seed{
				UserId:       user.ID,
				SeedId:       result,
				Name:         seedInfosMap[result].Name,
				OutOverTime:  seedInfosMap[result].OutOverTime,
				OutMaxAmount: float64(randomNumber),
			})
			if nil != err {
				return err
			}

			//err = ac.userRepo.CreateNotice(
			//	ctx,
			//	user.ID,
			//	"您开盒子获得了, 种子",
			//	"You've get seed from box",
			//)
			//if nil != err {
			//	return err
			//}

			return nil
		}); nil != err {
			fmt.Println(err, "openBox", user)
			return &pb.OpenBoxReply{
				Status: "开启失败",
			}, nil
		}

		return &pb.OpenBoxReply{
			Id:       boxId,
			Status:   "ok",
			OpenType: 1,
			Num:      result,
			OutMax:   float64(randomNumber),
			Time:     seedInfosMap[result].OutOverTime,
		}, nil
	} else if 11 <= result && result <= 15 {
		if _, ok := propInfosMap[result]; !ok {
			return &pb.OpenBoxReply{
				Status: "不存在盲盒信息",
			}, nil
		}

		// 种子
		boxId := uint64(0)
		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			boxId, err = ac.userRepo.OpenBoxProp(ctx, box.ID, user.ID, "获得道具", ispay, &Prop{
				UserId:   user.ID,
				PropType: int(result),
				OneOne:   int(propInfosMap[result].OneOne),
				OneTwo:   int(propInfosMap[result].OneTwo),
				TwoOne:   int(propInfosMap[result].TwoOne),
				TwoTwo:   propInfosMap[result].TwoTwo,
				ThreeOne: int(propInfosMap[result].ThreeOne),
				FourOne:  int(propInfosMap[result].FourOne),
				FiveOne:  int(propInfosMap[result].FiveOne),
			})
			if nil != err {
				return err
			}

			//err = ac.userRepo.CreateNotice(
			//	ctx,
			//	user.ID,
			//	"您开盒子获得了, 道具",
			//	"You've get prop from box",
			//)
			//if nil != err {
			//	return err
			//}

			return nil
		}); nil != err {
			fmt.Println(err, "openBox", user)
			return &pb.OpenBoxReply{
				Status: "开启失败",
			}, nil
		}

		useNum := uint64(0)
		if 12 == propInfosMap[result].PropType {
			useNum = propInfosMap[result].ThreeOne // 水
		} else if 13 == propInfosMap[result].PropType {
			useNum = propInfosMap[result].FiveOne // 手套
		} else if 14 == propInfosMap[result].PropType {
			useNum = propInfosMap[result].FourOne // 除虫剂
		} else if 15 == propInfosMap[result].PropType {
			useNum = propInfosMap[result].TwoOne // 铲子
		}

		return &pb.OpenBoxReply{
			Id:       boxId,
			Status:   "ok",
			OpenType: 2,
			Num:      result,
			OutMax:   0,
			UseNum:   useNum,
		}, nil
	} else {
		return &pb.OpenBoxReply{
			Status: "开盲盒失败",
		}, nil
	}
}

var rngMutexPlant sync.Mutex

// LandPlayOne 种植
func (ac *AppUsecase) LandPlayOne(ctx context.Context, address string, req *pb.LandPlayOneRequest) (*pb.LandPlayOneReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlayOneReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandPlayOneReply{
			Status: "锁定用户",
		}, nil
	}

	rngMutexPlant.Lock()
	defer rngMutexPlant.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlayOneReply{
			Status: "不存在用户",
		}, nil
	}

	var (
		seed *Seed
	)
	seed, err = ac.userRepo.GetSeedByID(ctx, req.SendBody.SeedId, user.ID, 0)
	if nil != err || nil == seed {
		return &pb.LandPlayOneReply{
			Status: "不存种子",
		}, nil
	}

	var (
		land *Land
	)
	land, err = ac.userRepo.GetLandByID(ctx, req.SendBody.LandId)
	if nil != err || nil == land {
		return &pb.LandPlayOneReply{
			Status: "土地不存在或已失效，撤销布置",
		}, nil
	}

	//if land.PerHealth > land.MaxHealth {
	//	return &pb.LandPlayOneReply{
	//		Status:    "肥沃度不足",
	//		StatusTwo: "Insufficient fertility.",
	//	}, nil
	//}

	if land.UserId != user.ID {
		if 3 != land.Status {
			return &pb.LandPlayOneReply{
				Status: "未出租土地，不能种植",
			}, nil
		}
	} else if land.UserId == user.ID {
		if 1 != land.Status {
			return &pb.LandPlayOneReply{
				Status: "已出租土地，自己不能种植",
			}, nil
		}
	} else {
		return &pb.LandPlayOneReply{
			Status: "错误参数",
		}, nil
	}

	if 0 == land.LocationNum {
		return &pb.LandPlayOneReply{
			Status: "未布置土地",
		}, nil
	}

	var (
		configs     []*Config
		playOneRate float64
		playTwoRate float64
	)

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"play_one_rate",
		"play_two_rate",
	)
	if nil != err || nil == configs {
		return &pb.LandPlayOneReply{
			Status: "配置错误",
		}, nil
	}
	for _, vConfig := range configs {
		if "play_one_rate" == vConfig.KeyName {
			playOneRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "play_two_rate" == vConfig.KeyName {
			playTwoRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	if nil == rngPlant {
		var (
			seedInt     int64
			randomSeeds []*RandomSeed
		)
		randomSeeds, err = ac.userRepo.GetAllRandomSeeds(ctx)
		if nil != err {
			return &pb.LandPlayOneReply{
				Status: "异常",
			}, nil
		}

		for _, v := range randomSeeds {
			if 2 == v.Scene {
				seedInt = int64(v.SeedValue)
				break
			}
		}

		if 0 >= seedInt {
			seedInt = time.Now().UnixNano()
			err = ac.userRepo.UpdateSeedValue(ctx, 2, uint64(seedInt))
			if nil != err {
				return &pb.LandPlayOneReply{
					Status: "异常",
				}, nil
			}
		}

		rngPlant = rand2.New(rand2.NewSource(seedInt))
	}

	now := uint64(time.Now().Unix())
	rngTmp := rand2.New(rand2.NewSource(time.Now().UnixNano()))
	outMin := int64(now)
	outMax := int64(now + seed.OutOverTime)

	// 计算随机范围
	tmpNum := outMax - outMin
	if tmpNum <= 0 {
		tmpNum = 1 // 避免 Int63n(0) panic
	}
	// 生成随机数
	randomNumber := outMin + rngTmp.Int63n(tmpNum)

	one := uint64(0)
	two := uint64(0)
	r := rngPlant.Float64() // 生成 0.0 ~ 1.0 之间的随机数
	if r < playOneRate {
		one = uint64(randomNumber)
	} else if r < playOneRate+playTwoRate {
		two = uint64(randomNumber)
	}

	originStatusTmp := land.Status
	statusTmp := uint64(2)
	if 3 == originStatusTmp {
		statusTmp = 8
	}

	isUserOther := land.UserId
	if 0 < land.LocationUserId {
		isUserOther = land.LocationUserId
	}
	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		err = ac.userRepo.Plant(ctx, statusTmp, originStatusTmp, land.PerHealth, &LandUserUse{
			LandId:      land.ID,
			Level:       land.Level,
			UserId:      user.ID,
			OwnerUserId: land.UserId,
			SeedId:      seed.ID,
			SeedTypeId:  seed.SeedId,
			Status:      1,
			BeginTime:   now,
			TotalTime:   seed.OutOverTime,
			OverTime:    now + seed.OutOverTime,
			OutMaxNum:   seed.OutMaxAmount * land.OutPutRate,
			One:         one, // 水时间
			Two:         two, // 虫子时间
			IsUseOther:  isUserOther,
		})
		if nil != err {
			return err
		}

		err = ac.userRepo.CreateNotice(
			ctx,
			user.ID,
			"您种植了一个产量为"+fmt.Sprintf("%.2f", seed.OutMaxAmount)+"ISPAY的种子",
			"You've plant a seed with output "+fmt.Sprintf("%.2f", seed.OutMaxAmount)+" ISPAY",
		)
		if nil != err {
			return err
		}

		return nil
	}); nil != err {
		fmt.Println(err, "openBox", user)
		return &pb.LandPlayOneReply{
			Status: "种植失败",
		}, nil
	}

	return &pb.LandPlayOneReply{
		Status: "ok",
	}, nil

}

//var rngMutexPlantTwo sync.Mutex

// LandPlayTwo 收果实
func (ac *AppUsecase) LandPlayTwo(ctx context.Context, address string, req *pb.LandPlayTwoRequest) (*pb.LandPlayTwoReply, error) {
	var (
		configs []*Config
		user    *User
		//oneRate   float64
		//twoRate   float64
		//threeRate float64
		uPrice  float64
		sRate   float64
		selfSub uint64
		//lowRewardU float64
		err error
		//priceOpen    float64
		//priceOpenUse uint64
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlayTwoReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandPlayTwoReply{
			Status: "锁定用户",
		}, nil
	}

	//rngMutexPlantTwo.Lock()
	//defer rngMutexPlantTwo.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlayTwoReply{
			Status: "不存在用户",
		}, nil
	}

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"one_rate", "two_rate", "three_rate", "u_price", "s_rate", "self_sub", "open_box_price",
		"open_box_price_use",
	)
	if nil != err || nil == configs {
		return &pb.LandPlayTwoReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		//if "one_rate" == vConfig.KeyName {
		//	oneRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//
		//if "two_rate" == vConfig.KeyName {
		//	twoRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//
		//if "three_rate" == vConfig.KeyName {
		//	threeRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}

		if "u_price" == vConfig.KeyName {
			uPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "s_rate" == vConfig.KeyName {
			sRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "self_sub" == vConfig.KeyName {
			selfSub, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		//if "open_box_price" == vConfig.KeyName {
		//	priceOpen, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//
		//if "open_box_price_use" == vConfig.KeyName {
		//	priceOpenUse, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		//}
	}

	if 0 >= uPrice {
		return &pb.LandPlayTwoReply{
			Status: "币价ispay:u错误",
		}, nil
	}

	var (
		landUserUse *LandUserUse
	)
	landUserUse, err = ac.userRepo.GetLandUserUseByID(ctx, req.SendBody.LandUseId)
	if nil != err || nil == landUserUse {
		return &pb.LandPlayTwoReply{
			Status: "不存在信息",
		}, nil
	}

	if landUserUse.UserId != user.ID {
		return &pb.LandPlayTwoReply{
			Status: "非种植用户",
		}, nil
	}

	if 1 != landUserUse.Status {
		return &pb.LandPlayTwoReply{
			Status: "状态错误",
		}, nil
	}

	current := time.Now().Unix()
	if uint64(current) < landUserUse.OverTime {
		return &pb.LandPlayTwoReply{
			Status: "种植未结束",
		}, nil
	}

	if 0 != landUserUse.One {
		return &pb.LandPlayTwoReply{
			Status: "停止生长状态",
		}, nil
	}

	// 有虫子
	if 0 != landUserUse.Two {
		return &pb.LandPlayTwoReply{
			Status: "有虫子请先杀虫",
		}, nil
	}

	// 开启了系统偷盗全局
	tmpLandUserUseOutMaxNum := landUserUse.OutMaxNum
	if 1 == selfSub {
		tmpAmount := tmpLandUserUseOutMaxNum * sRate
		if tmpAmount >= tmpLandUserUseOutMaxNum {
			tmpLandUserUseOutMaxNum = 0
		} else {
			tmpLandUserUseOutMaxNum = tmpLandUserUseOutMaxNum - tmpAmount
		}
	}
	// 已结束
	reward := tmpLandUserUseOutMaxNum

	var (
		land *Land
	)
	land, err = ac.userRepo.GetLandByIDTwo(ctx, landUserUse.LandId)
	if nil != err || nil == land {
		return &pb.LandPlayTwoReply{
			Status: "土地信息错误",
		}, nil
	}

	rentReward := float64(0)
	if landUserUse.UserId != landUserUse.OwnerUserId {
		if 0 < reward {
			rentReward = reward * land.RentOutPutRate
			if reward > rentReward {
				reward = reward - rentReward
			}
		}
	}

	// 推荐
	var (
		userRecommend *UserRecommend
	)
	tmpRecommendUserIds := make([]string, 0)
	userRecommend, err = ac.userRepo.GetUserRecommendByUserId(ctx, landUserUse.UserId)
	if nil == userRecommend || nil != err {
		return &pb.LandPlayTwoReply{
			Status: "查询推荐错误",
		}, nil
	}
	if "" != userRecommend.RecommendCode {
		tmpRecommendUserIds = strings.Split(userRecommend.RecommendCode, "D")
	}

	// 收租推荐
	tmpRecommendUserIdsRent := make([]string, 0)
	tmpRent := false
	rentUserId := uint64(0)
	if landUserUse.UserId != landUserUse.OwnerUserId {
		tmpRent = true
		rentUserId = landUserUse.OwnerUserId
		var (
			userRecommendRent *UserRecommend
		)
		userRecommendRent, err = ac.userRepo.GetUserRecommendByUserId(ctx, landUserUse.OwnerUserId)
		if nil == userRecommendRent || nil != err {
			return &pb.LandPlayTwoReply{
				Status: "查询推荐错误",
			}, nil
		}
		if "" != userRecommendRent.RecommendCode {
			tmpRecommendUserIdsRent = strings.Split(userRecommendRent.RecommendCode, "D")
		}
	}

	userIds := make([]uint64, 0)
	tmpIi := 0
	for i := len(tmpRecommendUserIds) - 1; i >= 0; i-- {
		if 3 <= tmpIi {
			break
		}
		tmpIi++

		tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIds[i], 10, 64) // 最后一位是直推人
		if 0 >= tmpUserId {
			continue
		}

		userIds = append(userIds, tmpUserId)
	}

	tmpIj := 0
	for i := len(tmpRecommendUserIdsRent) - 1; i >= 0; i-- {
		if 3 <= tmpIj {
			break
		}
		tmpIj++

		tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIdsRent[i], 10, 64) // 最后一位是直推人
		if 0 >= tmpUserId {
			continue
		}

		userIds = append(userIds, tmpUserId)
	}

	//usersMap := make(map[uint64]*User, 0)
	//if 0 < len(userIds) {
	//	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	//	if nil != err {
	//		return &pb.LandPlayTwoReply{
	//			Status: "查询推荐错误",
	//		}, nil
	//	}
	//}

	//var (
	//	ispay     float64
	//	ispayRent float64
	//)
	//var (
	//	tmp0 float64
	//	tmp1 float64
	//)
	//tmp0, tmp1, err = GetReservers()
	//if nil != err || 1 >= tmp0 || 1 >= tmp1 {
	//	return &pb.LandPlayTwoReply{
	//		Status: "获取交易池数据失败",
	//	}, nil
	//}

	//rewardL := reward
	//
	//reward = reward / 2
	//rentReward = rentReward / 2
	//if 0 == priceOpenUse {
	//	ispay = reward / priceOpen
	//	ispayRent = rentReward / priceOpen
	//} else {
	//	ispay = reward * tmp1 / tmp0
	//	ispayRent = rentReward * tmp1 / tmp0
	//}
	//
	//if 0.0000000001 >= ispay {
	//	return &pb.LandPlayTwoReply{
	//		Status: "配置错误",
	//	}, nil
	//}

	// 分红，状态变更
	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		// 资源释放
		err = ac.userRepo.PlantPlatTwo(ctx, landUserUse.ID, land.ID, tmpRent)
		if nil != err {
			return err
		}

		// 奖励
		err = ac.userRepo.PlantPlatTwoTwo(ctx, landUserUse.ID, landUserUse.UserId, rentUserId, reward, 0, rentReward, 0)
		if nil != err {
			return err
		}

		err = ac.userRepo.CreateNotice(
			ctx,
			user.ID,
			"您收获了"+fmt.Sprintf("%.2f", reward)+" USDT",
			"You've harvest "+fmt.Sprintf("%.2f", reward)+" USDT",
		)
		if nil != err {
			return err
		}

		if 0 < rentReward {
			err = ac.userRepo.CreateNotice(
				ctx,
				rentUserId,
				"您收获了"+fmt.Sprintf("%.2f", rentReward)+" USDT",
				"You've harvest "+fmt.Sprintf("%.2f", rentReward)+" USDT",
			)
			if nil != err {
				return err
			}
		}

		// l1-l3，奖励发放
		//if rewardL > 0 {
		//	tmpI := 0
		//	for i := len(tmpRecommendUserIds) - 1; i >= 0; i-- {
		//		if 3 <= tmpI {
		//			break
		//		}
		//		tmpI++
		//
		//		tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIds[i], 10, 64) // 最后一位是直推人
		//		if 0 >= tmpUserId {
		//			continue
		//		}
		//
		//		if _, ok := usersMap[tmpUserId]; !ok {
		//			continue
		//		}
		//
		//		//if lowRewardU > usersMap[tmpUserId].Giw/uPrice {
		//		//	continue
		//		//}
		//
		//		tmpReward := float64(0)
		//
		//		tmpNum := uint64(4)
		//		tmpReward = rewardL * oneRate
		//		if 1 == tmpI {
		//
		//		} else if 2 == tmpI {
		//			tmpReward = rewardL * twoRate
		//			tmpNum = 7
		//		} else if 3 == tmpI {
		//			tmpReward = rewardL * threeRate
		//			tmpNum = 10
		//		} else {
		//			break
		//		}
		//
		//		if 0.0000001 >= tmpReward {
		//			continue
		//		}
		//
		//		var (
		//			ispayL float64
		//		)
		//		tmpReward = tmpReward / 2
		//		if 0 == priceOpenUse {
		//			ispayL = tmpReward / priceOpen
		//		} else {
		//			ispayL = tmpReward * tmp1 / tmp0
		//		}
		//
		//		// 奖励
		//		err = ac.userRepo.PlantPlatTwoTwoL(ctx, landUserUse.ID, tmpUserId, landUserUse.UserId, tmpNum, tmpReward, ispayL)
		//		if nil != err {
		//			return err
		//		}
		//
		//		err = ac.userRepo.CreateNotice(
		//			ctx,
		//			tmpUserId,
		//			"您收获了"+fmt.Sprintf("%.2f", tmpReward)+"USDT 和"+fmt.Sprintf("%.2f", ispayL)+" ISPAY",
		//			"You've harvest "+fmt.Sprintf("%.2f", tmpReward)+" USDT AND "+fmt.Sprintf("%.2f", ispayL)+" ISPAY",
		//		)
		//		if nil != err {
		//			return err
		//		}
		//	}
		//}

		//// l1-l3，奖励发放
		//if rentReward > 0 {
		//	tmpI := 0
		//	for i := len(tmpRecommendUserIdsRent) - 1; i >= 0; i-- {
		//		if 3 <= tmpI {
		//			break
		//		}
		//		tmpI++
		//
		//		tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIdsRent[i], 10, 64) // 最后一位是直推人
		//		if 0 >= tmpUserId {
		//			continue
		//		}
		//
		//		if _, ok := usersMap[tmpUserId]; !ok {
		//			continue
		//		}
		//
		//		//if lowRewardU > usersMap[tmpUserId].Giw/uPrice {
		//		//	continue
		//		//}
		//
		//		tmpReward := float64(0)
		//
		//		tmpNum := uint64(5)
		//		tmpReward = rentReward * oneRate
		//		if 1 == tmpI {
		//
		//		} else if 2 == tmpI {
		//			tmpReward = rentReward * twoRate
		//			tmpNum = 8
		//		} else if 3 == tmpI {
		//			tmpReward = rentReward * threeRate
		//			tmpNum = 11
		//		} else {
		//			break
		//		}
		//
		//		// 奖励
		//		err = ac.userRepo.PlantPlatTwoTwoL(ctx, landUserUse.ID, tmpUserId, landUserUse.OwnerUserId, tmpNum, tmpReward)
		//		if nil != err {
		//			return err
		//		}
		//
		//		err = ac.userRepo.CreateNotice(
		//			ctx,
		//			tmpUserId,
		//			"您收获了"+fmt.Sprintf("%.2f", tmpReward)+"ISPAY",
		//			"You've harvest "+fmt.Sprintf("%.2f", tmpReward)+" ISPAY",
		//		)
		//		if nil != err {
		//			return err
		//		}
		//	}
		//}

		return nil
	}); nil != err {
		fmt.Println(err, "LandPlayTwo", landUserUse)
		return &pb.LandPlayTwoReply{
			Status: "种植失败",
		}, nil
	}

	return &pb.LandPlayTwoReply{
		Status: "ok",
	}, nil
}

var rngMutexAddM sync.Mutex

func (ac *AppUsecase) AddMessage(ctx context.Context, address string, req *pb.AddMessageRequest) (*pb.AddMessageReply, error) {
	var (
		user  *User
		count int64
		err   error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.AddMessageReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.AddMessageReply{
			Status: "锁定用户",
		}, nil
	}

	rngMutexAddM.Lock()
	defer rngMutexAddM.Unlock()

	count, err = ac.userRepo.GetMessagesCount(ctx, user.ID)
	if nil != err || 50 < count {
		return &pb.AddMessageReply{
			Status: "内容今日发送上限50条",
		}, nil
	}

	if 0 >= len(req.SendBody.Content) {
		return &pb.AddMessageReply{
			Status: "最少1个字符",
		}, nil
	}

	if 100 <= len(req.SendBody.Content) {
		return &pb.AddMessageReply{
			Status: "最大100字符",
		}, nil
	}

	err = ac.userRepo.CreateMessages(ctx, user.ID, req.SendBody.Content)
	if nil != err {
		return &pb.AddMessageReply{
			Status: "发生失败",
		}, nil
	}

	return &pb.AddMessageReply{
		Status: "ok",
	}, nil
}

// LandPlayThree 施肥
func (ac *AppUsecase) LandPlayThree(ctx context.Context, address string, req *pb.LandPlayThreeRequest) (*pb.LandPlayThreeReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlayThreeReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandPlayThreeReply{
			Status: "锁定用户",
		}, nil
	}

	var (
		prop *Prop
	)
	prop, err = ac.userRepo.GetPropByID(ctx, req.SendBody.Id, 1)
	if nil != err || nil == prop {
		return &pb.LandPlayThreeReply{
			Status: "不存道具",
		}, nil
	}

	if 1 != user.CanPlayAdd {
		if user.ID != prop.UserId {
			return &pb.LandPlayThreeReply{
				Status: "不是自己的",
			}, nil
		}
	}

	if 11 != prop.PropType {
		return &pb.LandPlayThreeReply{
			Status: "不是化肥",
		}, nil
	}

	var (
		landUserUse *LandUserUse
	)
	landUserUse, err = ac.userRepo.GetLandUserUseByID(ctx, req.SendBody.LandUseId)
	if nil != err || nil == landUserUse {
		return &pb.LandPlayThreeReply{
			Status: "不存在信息",
		}, nil
	}

	if 1 != user.CanPlayAdd {
		if landUserUse.UserId != user.ID {
			return &pb.LandPlayThreeReply{
				Status: "非种植用户",
			}, nil
		}
	}

	if 1 != landUserUse.Status {
		return &pb.LandPlayThreeReply{
			Status: "状态错误",
		}, nil
	}

	current := time.Now().Unix()
	if 0 != landUserUse.One && uint64(current) >= landUserUse.One {
		return &pb.LandPlayThreeReply{
			Status: "停止生长状态",
		}, nil
	}

	if 0 != landUserUse.Two && uint64(current) >= landUserUse.Two {
		return &pb.LandPlayThreeReply{
			Status: "生虫状态",
		}, nil
	}

	if uint64(current) >= landUserUse.OverTime {
		return &pb.LandPlayThreeReply{
			Status: "种植已经结束了",
		}, nil
	}

	if landUserUse.OverTime < uint64(prop.OneTwo) {
		return &pb.LandPlayThreeReply{
			Status: "道具配置错误",
		}, nil
	}

	overTime := landUserUse.OverTime - uint64(prop.OneTwo)
	one := false
	if overTime <= landUserUse.One {
		one = true
	}

	two := false
	if overTime <= landUserUse.Two {
		two = true
	}

	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		return ac.userRepo.PlantPlatThree(ctx, landUserUse.ID, overTime, prop.ID, one, two)
	}); nil != err {
		fmt.Println(err, "LandPlayThree", user)
		return &pb.LandPlayThreeReply{
			Status: "施肥失败",
		}, nil
	}

	return &pb.LandPlayThreeReply{
		Status: "ok",
	}, nil
}

// LandPlayFour 杀虫
func (ac *AppUsecase) LandPlayFour(ctx context.Context, address string, req *pb.LandPlayFourRequest) (*pb.LandPlayFourReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlayFourReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandPlayFourReply{
			Status: "锁定用户",
		}, nil
	}

	// 配置
	var (
		configs    []*Config
		twoSubRate float64
	)
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"two_sub_reward",
	)
	if nil != err || nil == configs {
		return &pb.LandPlayFourReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "two_sub_reward" == vConfig.KeyName {
			twoSubRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

	}
	var (
		prop *Prop
	)

	// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
	prop, err = ac.userRepo.GetPropByIDTwo(ctx, req.SendBody.Id)
	if nil != err || nil == prop {
		return &pb.LandPlayFourReply{
			Status: "不存在道具",
		}, nil
	}

	if 14 != prop.PropType {
		return &pb.LandPlayFourReply{
			Status: "无效道具",
		}, nil

	}

	if 2 < prop.Status {
		return &pb.LandPlayFourReply{
			Status: "无效道具",
		}, nil
	}

	if 0 >= prop.FourOne {
		return &pb.LandPlayFourReply{
			Status: "无效道具",
		}, nil
	}

	if user.ID != prop.UserId {
		return &pb.LandPlayFourReply{
			Status: "不是自己的",
		}, nil
	}

	var (
		landUserUse *LandUserUse
	)
	landUserUse, err = ac.userRepo.GetLandUserUseByID(ctx, req.SendBody.LandUseId)
	if nil != err || nil == landUserUse {
		return &pb.LandPlayFourReply{
			Status: "不存在信息",
		}, nil
	}

	if landUserUse.UserId != user.ID {
		return &pb.LandPlayFourReply{
			Status: "非种植用户",
		}, nil
	}

	if 1 != landUserUse.Status {
		return &pb.LandPlayFourReply{
			Status: "状态错误",
		}, nil
	}

	current := time.Now().Unix()
	if 0 >= landUserUse.Two {
		return &pb.LandPlayFourReply{
			Status: "无需杀虫",
		}, nil
	}

	if uint64(current) < landUserUse.Two {
		return &pb.LandPlayFourReply{
			Status: "无需杀虫",
		}, nil
	}

	// 剩余最大产出
	rewardTmp := float64(0)
	if uint64(current) >= landUserUse.Two {
		tmp := landUserUse.OutMaxNum * twoSubRate
		if tmp < landUserUse.OutMaxNum {
			rewardTmp = landUserUse.OutMaxNum - tmp
		}
	}

	one := uint64(0)
	if 1 <= prop.FourOne {
		one = uint64(prop.FourOne - 1)
	}

	two := uint64(2)
	if 0 >= one {
		two = 3
	}

	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		return ac.userRepo.PlantPlatFour(ctx, rewardTmp, landUserUse.ID, prop.ID, two, one)
	}); nil != err {
		fmt.Println(err, "LandPlayFour", user)
		return &pb.LandPlayFourReply{
			Status: "杀虫失败",
		}, nil
	}

	return &pb.LandPlayFourReply{
		Status: "ok",
	}, nil
}

// LandPlayFive 浇水
func (ac *AppUsecase) LandPlayFive(ctx context.Context, address string, req *pb.LandPlayFiveRequest) (*pb.LandPlayFiveReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlayFiveReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandPlayFiveReply{
			Status: "锁定用户",
		}, nil
	}

	var (
		prop *Prop
	)

	// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
	prop, err = ac.userRepo.GetPropByIDTwo(ctx, req.SendBody.Id)
	if nil != err || nil == prop {
		return &pb.LandPlayFiveReply{
			Status: "不存在道具",
		}, nil
	}

	if 12 != prop.PropType {
		return &pb.LandPlayFiveReply{
			Status: "无效道具",
		}, nil

	}

	if 2 < prop.Status {
		return &pb.LandPlayFiveReply{
			Status: "无效道具",
		}, nil
	}

	if 0 >= prop.ThreeOne {
		return &pb.LandPlayFiveReply{
			Status: "无效道具",
		}, nil
	}

	if user.ID != prop.UserId {
		return &pb.LandPlayFiveReply{
			Status: "不是自己的",
		}, nil
	}

	var (
		landUserUse *LandUserUse
	)
	landUserUse, err = ac.userRepo.GetLandUserUseByID(ctx, req.SendBody.LandUseId)
	if nil != err || nil == landUserUse {
		return &pb.LandPlayFiveReply{
			Status: "不存在信息",
		}, nil
	}

	if landUserUse.UserId != user.ID {
		return &pb.LandPlayFiveReply{
			Status: "非种植用户",
		}, nil
	}

	if 1 != landUserUse.Status {
		return &pb.LandPlayFiveReply{
			Status: "状态错误",
		}, nil
	}

	current := time.Now().Unix()
	if 0 >= landUserUse.One {
		return &pb.LandPlayFiveReply{
			Status: "无需浇水",
		}, nil
	}

	if uint64(current) < landUserUse.One {
		return &pb.LandPlayFiveReply{
			Status: "无需浇水",
		}, nil
	}

	tmpOverTime := landUserUse.OverTime + uint64(current) - landUserUse.One

	one := uint64(0)
	if 1 <= prop.ThreeOne {
		one = uint64(prop.ThreeOne - 1)
	}

	two := uint64(2)
	if 0 >= one {
		two = 3
	}

	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		return ac.userRepo.PlantPlatFive(ctx, tmpOverTime, landUserUse.ID, prop.ID, two, one)
	}); nil != err {
		fmt.Println(err, "LandPlayFive", user)
		return &pb.LandPlayFiveReply{
			Status: "浇水失败",
		}, nil
	}

	return &pb.LandPlayFiveReply{
		Status: "ok",
	}, nil
}

// LandPlaySix 铲子
func (ac *AppUsecase) LandPlaySix(ctx context.Context, address string, req *pb.LandPlaySixRequest) (*pb.LandPlaySixReply, error) {
	var (
		user *User
		err  error

		//priceOpen    float64
		//priceOpenUse uint64
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlaySixReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandPlaySixReply{
			Status: "锁定用户",
		}, nil
	}

	if 1 != user.CanPlaySix {
		return &pb.LandPlaySixReply{
			Status: "不能使用该道具",
		}, nil
	}

	// 配置
	var (
		configs []*Config
		//oneRate    float64
		//twoRate    float64
		//threeRate  float64
		uPrice     float64
		propTwoTwo float64
		sRate      float64
		selfSub    uint64
		//lowRewardU float64
	)
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"one_rate", "two_rate", "three_rate", "u_price", "low_reward_u", "prop_two_two", "s_rate", "self_sub", "open_box_price",
		"open_box_price_use",
	)
	if nil != err || nil == configs {
		return &pb.LandPlaySixReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		//if "one_rate" == vConfig.KeyName {
		//	oneRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//
		//if "two_rate" == vConfig.KeyName {
		//	twoRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//
		//if "three_rate" == vConfig.KeyName {
		//	threeRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}

		if "u_price" == vConfig.KeyName {
			uPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "prop_two_two" == vConfig.KeyName {
			propTwoTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "s_rate" == vConfig.KeyName {
			sRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "self_sub" == vConfig.KeyName {
			selfSub, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
		//if "open_box_price" == vConfig.KeyName {
		//	priceOpen, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//
		//if "open_box_price_use" == vConfig.KeyName {
		//	priceOpenUse, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		//}
		//if "low_reward_u" == vConfig.KeyName {
		//	lowRewardU, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
	}

	if 0 >= uPrice {
		return &pb.LandPlaySixReply{
			Status: "币价ispay:u错误",
		}, nil
	}

	var (
		prop *Prop
	)

	// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
	prop, err = ac.userRepo.GetPropByIDTwo(ctx, req.SendBody.Id)
	if nil != err || nil == prop {
		return &pb.LandPlaySixReply{
			Status: "不存在道具",
		}, nil
	}

	if 15 != prop.PropType {
		return &pb.LandPlaySixReply{
			Status: "无效道具",
		}, nil

	}

	if 2 < prop.Status {
		return &pb.LandPlaySixReply{
			Status: "无效道具",
		}, nil
	}

	if 0 >= prop.TwoOne {
		return &pb.LandPlaySixReply{
			Status: "无效道具",
		}, nil
	}

	if user.ID != prop.UserId {
		return &pb.LandPlaySixReply{
			Status: "不是自己的",
		}, nil
	}

	var (
		landUserUse *LandUserUse
	)
	landUserUse, err = ac.userRepo.GetLandUserUseByID(ctx, req.SendBody.LandUseId)
	if nil != err || nil == landUserUse {
		return &pb.LandPlaySixReply{
			Status: "不存在信息",
		}, nil
	}

	//if landUserUse.OwnerUserId != user.ID {
	//	return &pb.LandPlaySixReply{
	//		Status: "非土地用户",
	//	}, nil
	//}
	//
	//if landUserUse.UserId == user.ID {
	//	return &pb.LandPlaySixReply{
	//		Status: "非出租土地",
	//	}, nil
	//}

	if 1 != landUserUse.Status {
		return &pb.LandPlaySixReply{
			Status: "状态错误",
		}, nil
	}

	// 必须先清理了，才能铲除
	//if 0 < landUserUse.One {
	//	return &pb.LandPlaySixReply{
	//		Status: "暂停生长不能铲除",
	//	}, nil
	//} else if 0 < landUserUse.Two {
	//	return &pb.LandPlaySixReply{
	//		Status: "蛀虫状态不能铲除",
	//	}, nil
	//}

	current := time.Now().Unix()
	if uint64(current) < landUserUse.OverTime {
		return &pb.LandPlaySixReply{
			Status: "成熟后可以铲除|over time limit",
		}, nil
	}

	one := uint64(0)
	if 1 <= prop.TwoOne {
		one = uint64(prop.TwoOne - 1)
	}

	two := uint64(2)
	if 0 >= one {
		two = 3 // 使用次数归0
	}

	tmpOverMax := float64(0)
	// 开启了系统偷盗全局
	tmpLandUserUseOutMaxNum := landUserUse.OutMaxNum
	if 1 == selfSub {
		tmpAmount := tmpLandUserUseOutMaxNum * sRate
		if tmpAmount >= tmpLandUserUseOutMaxNum {
			tmpLandUserUseOutMaxNum = 0
		} else {
			tmpLandUserUseOutMaxNum = tmpLandUserUseOutMaxNum - tmpAmount
		}
	}

	if tmpLandUserUseOutMaxNum > tmpLandUserUseOutMaxNum*propTwoTwo {
		tmpOverMax = tmpLandUserUseOutMaxNum - tmpLandUserUseOutMaxNum*propTwoTwo
	}
	tmpOverMaxTwo := tmpLandUserUseOutMaxNum * propTwoTwo

	//if 0 < landUserUse.One {
	//	tmpOverMax = 0
	//	tmpOverMaxTwo = 0
	//} else if 0 < landUserUse.Two {
	//	// 剩余最大产出
	//	rewardTmp := float64(0)
	//	if uint64(current) > landUserUse.Two {
	//		tmp := tmpLandUserUseOutMaxNum * 0.01 * float64(uint64(uint64(current)-landUserUse.Two)/300)
	//		if tmp < tmpLandUserUseOutMaxNum {
	//			rewardTmp = tmpLandUserUseOutMaxNum - tmp
	//		}
	//	}
	//
	//	if 0 >= rewardTmp {
	//		tmpOverMax = 0
	//		tmpOverMaxTwo = 0
	//	} else {
	//		if rewardTmp > rewardTmp*propTwoTwo {
	//			tmpOverMax = rewardTmp - rewardTmp*propTwoTwo
	//		}
	//		tmpOverMaxTwo = rewardTmp * propTwoTwo
	//	}
	//}

	// 推荐
	//var (
	//	userRecommend *UserRecommend
	//)
	//tmpRecommendUserIds := make([]string, 0)
	//userRecommend, err = ac.userRepo.GetUserRecommendByUserId(ctx, landUserUse.UserId)
	//if nil == userRecommend || nil != err {
	//	return &pb.LandPlaySixReply{
	//		Status: "查询推荐错误",
	//	}, nil
	//}
	//if "" != userRecommend.RecommendCode {
	//	tmpRecommendUserIds = strings.Split(userRecommend.RecommendCode, "D")
	//}
	//
	//// 收租推荐
	//tmpRecommendUserIdsRent := make([]string, 0)
	//if landUserUse.UserId != landUserUse.OwnerUserId {
	//	var (
	//		userRecommendRent *UserRecommend
	//	)
	//	userRecommendRent, err = ac.userRepo.GetUserRecommendByUserId(ctx, landUserUse.OwnerUserId)
	//	if nil == userRecommendRent || nil != err {
	//		return &pb.LandPlaySixReply{
	//			Status: "查询推荐错误",
	//		}, nil
	//	}
	//	if "" != userRecommendRent.RecommendCode {
	//		tmpRecommendUserIdsRent = strings.Split(userRecommendRent.RecommendCode, "D")
	//	}
	//}

	//userIds := make([]uint64, 0)
	//tmpIi := 0
	//for i := len(tmpRecommendUserIds) - 1; i >= 0; i-- {
	//	if 3 <= tmpIi {
	//		break
	//	}
	//	tmpIi++
	//
	//	tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIds[i], 10, 64) // 最后一位是直推人
	//	if 0 >= tmpUserId {
	//		continue
	//	}
	//
	//	userIds = append(userIds, tmpUserId)
	//}
	//
	//tmpIj := 0
	//for i := len(tmpRecommendUserIdsRent) - 1; i >= 0; i-- {
	//	if 3 <= tmpIj {
	//		break
	//	}
	//	tmpIj++
	//
	//	tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIdsRent[i], 10, 64) // 最后一位是直推人
	//	if 0 >= tmpUserId {
	//		continue
	//	}
	//
	//	userIds = append(userIds, tmpUserId)
	//}

	//usersMap := make(map[uint64]*User, 0)
	//if 0 < len(userIds) {
	//	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	//	if nil != err {
	//		return &pb.LandPlaySixReply{
	//			Status: "查询推荐错误",
	//		}, nil
	//	}
	//}

	//var (
	//	ispay     float64
	//	ispayRent float64
	//)
	//
	//var (
	//	tmp0 float64
	//	tmp1 float64
	//)
	//tmp0, tmp1, err = GetReservers()
	//if nil != err || 1 >= tmp0 || 1 >= tmp1 {
	//	return &pb.LandPlaySixReply{
	//		Status: "获取交易池数据失败",
	//	}, nil
	//}

	//tmpOverMaxL := tmpOverMax

	//tmpOverMax = tmpOverMax / 2
	//tmpOverMaxTwo = tmpOverMaxTwo / 2
	//if 0 == priceOpenUse {
	//	ispay = tmpOverMax / priceOpen
	//	ispayRent = tmpOverMaxTwo / priceOpen
	//} else {
	//	ispay = tmpOverMax * tmp1 / tmp0
	//	ispayRent = tmpOverMaxTwo * tmp1 / tmp0
	//}
	//
	//if 0.0000000001 >= ispay {
	//	return &pb.LandPlaySixReply{
	//		Status: "配置错误",
	//	}, nil
	//}

	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		err = ac.userRepo.PlantPlatSix(ctx, landUserUse.ID, prop.ID, two, one, landUserUse.LandId)
		if nil != err {
			return err
		}

		// 奖励
		err = ac.userRepo.PlantPlatTwoTwo(ctx, landUserUse.ID, landUserUse.UserId, landUserUse.OwnerUserId, tmpOverMax, 0, tmpOverMaxTwo, 0)
		if nil != err {
			return err
		}

		err = ac.userRepo.CreateNotice(
			ctx,
			landUserUse.UserId,
			"您收获了 "+fmt.Sprintf("%.2f", tmpOverMax)+" USDT",
			"You've harvest "+fmt.Sprintf("%.2f", tmpOverMax)+" USDT",
		)
		if nil != err {
			return err
		}

		err = ac.userRepo.CreateNotice(
			ctx,
			landUserUse.OwnerUserId,
			"您收获了 "+fmt.Sprintf("%.2f", tmpOverMaxTwo)+" USDT",
			"You've harvest "+fmt.Sprintf("%.2f", tmpOverMaxTwo)+" USDT",
		)

		// l1-l3，奖励发放
		//if tmpOverMaxL > 0 {
		//	tmpI := 0
		//	for i := len(tmpRecommendUserIds) - 1; i >= 0; i-- {
		//		if 3 <= tmpI {
		//			break
		//		}
		//		tmpI++
		//
		//		tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIds[i], 10, 64) // 最后一位是直推人
		//		if 0 >= tmpUserId {
		//			continue
		//		}
		//
		//		if _, ok := usersMap[tmpUserId]; !ok {
		//			continue
		//		}
		//
		//		//if lowRewardU > usersMap[tmpUserId].Giw/uPrice {
		//		//	continue
		//		//}
		//
		//		tmpReward := float64(0)
		//
		//		tmpNum := uint64(4)
		//		tmpReward = tmpOverMaxL * oneRate
		//		if 1 == tmpI {
		//
		//		} else if 2 == tmpI {
		//			tmpReward = tmpOverMaxL * twoRate
		//			tmpNum = 7
		//		} else if 3 == tmpI {
		//			tmpReward = tmpOverMaxL * threeRate
		//			tmpNum = 10
		//		} else {
		//			break
		//		}
		//
		//		if 0.0000001 >= tmpReward {
		//			continue
		//		}
		//
		//		var (
		//			ispayL float64
		//		)
		//		tmpReward = tmpReward / 2
		//		if 0 == priceOpenUse {
		//			ispayL = tmpReward / priceOpen
		//		} else {
		//			ispayL = tmpReward * tmp1 / tmp0
		//		}
		//		// 奖励
		//		err = ac.userRepo.PlantPlatTwoTwoL(ctx, landUserUse.ID, tmpUserId, landUserUse.UserId, tmpNum, tmpReward, ispayL)
		//		if nil != err {
		//			return err
		//		}
		//
		//		err = ac.userRepo.CreateNotice(
		//			ctx,
		//			tmpUserId,
		//			"您收获了"+fmt.Sprintf("%.2f", tmpReward)+"USDT 和"+fmt.Sprintf("%.2f", ispayL)+" ISPAY",
		//			"You've harvest "+fmt.Sprintf("%.2f", tmpReward)+" USDT AND "+fmt.Sprintf("%.2f", ispayL)+" ISPAY",
		//		)
		//		if nil != err {
		//			return err
		//		}
		//	}
		//}

		//// l1-l3，奖励发放，出租的
		//if tmpOverMaxTwo > 0 {
		//	tmpI := 0
		//	for i := len(tmpRecommendUserIdsRent) - 1; i >= 0; i-- {
		//		if 3 <= tmpI {
		//			break
		//		}
		//		tmpI++
		//
		//		tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIdsRent[i], 10, 64) // 最后一位是直推人
		//		if 0 >= tmpUserId {
		//			continue
		//		}
		//
		//		if _, ok := usersMap[tmpUserId]; !ok {
		//			continue
		//		}
		//
		//		//if lowRewardU > usersMap[tmpUserId].Giw/uPrice {
		//		//	continue
		//		//}
		//
		//		tmpReward := float64(0)
		//
		//		tmpNum := uint64(5)
		//		tmpReward = tmpOverMaxTwo * oneRate
		//		if 1 == tmpI {
		//
		//		} else if 2 == tmpI {
		//			tmpReward = tmpOverMaxTwo * twoRate
		//			tmpNum = 8
		//		} else if 3 == tmpI {
		//			tmpReward = tmpOverMaxTwo * threeRate
		//			tmpNum = 11
		//		} else {
		//			break
		//		}
		//
		//		// 奖励
		//		err = ac.userRepo.PlantPlatTwoTwoL(ctx, landUserUse.ID, tmpUserId, landUserUse.OwnerUserId, tmpNum, tmpReward)
		//		if nil != err {
		//			return err
		//		}
		//
		//		err = ac.userRepo.CreateNotice(
		//			ctx,
		//			tmpUserId,
		//			"您收获了"+fmt.Sprintf("%.2f", tmpReward)+"ISPAY",
		//			"You've harvest "+fmt.Sprintf("%.2f", tmpReward)+" ISPAY",
		//		)
		//		if nil != err {
		//			return err
		//		}
		//	}
		//}

		return nil
	}); nil != err {
		fmt.Println(err, "LandPlaySix", user)
		return &pb.LandPlaySixReply{
			Status: "铲除土地失败",
		}, nil
	}

	return &pb.LandPlaySixReply{
		Status: "ok",
	}, nil
}

var landPlaySeven sync.Mutex

// LandPlaySeven 手套
func (ac *AppUsecase) LandPlaySeven(ctx context.Context, address string, req *pb.LandPlaySevenRequest) (*pb.LandPlaySevenReply, error) {
	var (
		user    *User
		err     error
		configs []*Config
		sRate   float64
		selfSub uint64
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlaySevenReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandPlaySevenReply{
			Status: "锁定用户",
		}, nil
	}

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"s_rate",
		"self_sub",
	)
	if nil != err || nil == configs {
		return &pb.LandPlaySevenReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "s_rate" == vConfig.KeyName {
			sRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "self_sub" == vConfig.KeyName {
			selfSub, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}
	}

	landPlaySeven.Lock()
	defer landPlaySeven.Unlock()

	var (
		rewards map[uint64]*Reward
	)
	rewardIds := make([]uint64, 0)
	rewardIds = append(rewardIds, req.SendBody.LandUseId)
	rewards, err = ac.userRepo.GetRewardByTwo(ctx, rewardIds, user.ID)
	if nil != err {
		return &pb.LandPlaySevenReply{
			Status: "already err",
		}, nil
	}

	if _, ok := rewards[req.SendBody.LandUseId]; ok {
		return &pb.LandPlaySevenReply{
			Status: "already",
		}, nil
	}

	// 开启了系统偷盗全局
	if 1 == selfSub {
		return &pb.LandPlaySevenReply{
			Status: "偷盗过于频繁",
		}, nil
	}

	if 0 >= sRate {
		return &pb.LandPlaySevenReply{
			Status: "手套获取百分比为0",
		}, nil
	}

	var (
		prop *Prop
	)

	// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
	prop, err = ac.userRepo.GetPropByIDTwo(ctx, req.SendBody.Id)
	if nil != err || nil == prop {
		return &pb.LandPlaySevenReply{
			Status: "不存在道具",
		}, nil
	}

	if 13 != prop.PropType {
		return &pb.LandPlaySevenReply{
			Status: "无效道具",
		}, nil

	}

	if 2 < prop.Status {
		return &pb.LandPlaySevenReply{
			Status: "无效道具",
		}, nil
	}

	if 0 >= prop.FiveOne {
		return &pb.LandPlaySevenReply{
			Status: "无效道具",
		}, nil
	}

	if user.ID != prop.UserId {
		return &pb.LandPlaySevenReply{
			Status: "不是自己的",
		}, nil
	}

	//var (
	//	rewardCount int64
	//)
	//
	//rewardCount, err = ac.userRepo.GetTodayRewardPlantPlatSevenUserWithdrawCount(ctx, user.ID)
	//if nil != err || 50 < rewardCount {
	//	return &pb.LandPlaySevenReply{
	//		Status: "24小时内只能偷取50次",
	//	}, nil
	//}

	var (
		landUserUse *LandUserUse
	)
	landUserUse, err = ac.userRepo.GetLandUserUseByID(ctx, req.SendBody.LandUseId)
	if nil != err || nil == landUserUse {
		return &pb.LandPlaySevenReply{
			Status: "不存在信息",
		}, nil
	}

	if landUserUse.OwnerUserId == user.ID {
		return &pb.LandPlaySevenReply{
			Status: "土地用户不能使用手套",
		}, nil
	}

	if landUserUse.UserId == user.ID {
		return &pb.LandPlaySevenReply{
			Status: "种植用户不能使用手套",
		}, nil
	}

	if 1 != landUserUse.Status {
		return &pb.LandPlaySevenReply{
			Status: "状态错误",
		}, nil
	}

	current := time.Now().Unix()
	if uint64(current) < landUserUse.OverTime {
		return &pb.LandPlaySevenReply{
			Status: "还未成熟",
		}, nil
	}

	if 0 < landUserUse.One {
		return &pb.LandPlaySevenReply{
			Status:    "缺水暂停中",
			StatusTwo: "Paused due to lack of water.",
		}, nil
	}

	if 0 < landUserUse.Two {
		return &pb.LandPlaySevenReply{
			Status:    "虫蛀减产中",
			StatusTwo: "Production reduced due to pests.",
		}, nil
	}

	if 1 >= landUserUse.OutMaxNum {
		return &pb.LandPlaySevenReply{
			Status:    "已经偷光了",
			StatusTwo: "already over.",
		}, nil
	}

	lastTime := landUserUse.SubTime
	//if 0 < lastTime {
	//	return &pb.LandPlaySevenReply{
	//		Status:    "偷盗过于频繁",
	//		StatusTwo: "Stealing is too frequent.",
	//	}, nil
	//	//if uint64(current)-600 <= lastTime {
	//	//	return &pb.LandPlaySevenReply{
	//	//		Status: "偷盗过于频繁",
	//	//	}, nil
	//	//}
	//}

	tmpAmount := 100 * sRate
	tmpOutMax := float64(0)
	if tmpAmount >= landUserUse.OutMaxNum {
		tmpOutMax = 0
		tmpAmount = landUserUse.OutMaxNum
	} else {
		tmpOutMax = landUserUse.OutMaxNum - tmpAmount
	}

	if tmpAmount <= 0 {
		return &pb.LandPlaySevenReply{
			Status:    "已经偷光了",
			StatusTwo: "already over.",
		}, nil
	}

	one := uint64(0)
	if 1 <= prop.FiveOne {
		one = uint64(prop.FiveOne - 1)
	}

	two := uint64(2)
	if 0 >= one {
		two = 3 // 可用次数归0
	}

	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		err = ac.userRepo.PlantPlatSeven(ctx, tmpOutMax, tmpAmount, uint64(current), lastTime, landUserUse.ID, prop.ID, two, one, user.ID)
		if nil != err {
			return err
		}

		err = ac.userRepo.CreateNotice(
			ctx,
			user.ID,
			"您使用手套偷取了"+fmt.Sprintf("%.2f", tmpAmount)+"USDT",
			"You've steal "+fmt.Sprintf("%.2f", tmpAmount)+" USDT use gloves",
		)
		if nil != err {
			return err
		}

		return nil
	}); nil != err {
		fmt.Println(err, "LandPlaySeven", user)
		return &pb.LandPlaySevenReply{
			Status: "偷取失败",
		}, nil
	}

	return &pb.LandPlaySevenReply{
		Status: "ok",
		Amount: tmpAmount,
	}, nil
}

var rngMutexBuy sync.Mutex

func (ac *AppUsecase) Buy(ctx context.Context, address string, req *pb.BuyRequest) (*pb.BuyReply, error) {
	var (
		user         *User
		feeRate      float64
		buyLandOne   float64
		buyLandTwo   float64
		buyLandThree float64
		configs      []*Config
		err          error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.BuyReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.BuyReply{
			Status: "锁定用户",
		}, nil
	}

	rngMutexBuy.Lock()
	defer rngMutexBuy.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.BuyReply{
			Status: "不存在用户",
		}, nil
	}

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"sell_fee_rate",
		"buy_land_two",
		"buy_land_one",
		"buy_land_three",
	)
	if nil != err || nil == configs {
		return &pb.BuyReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "sell_fee_rate" == vConfig.KeyName {
			feeRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "buy_land_one" == vConfig.KeyName {
			buyLandOne, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "buy_land_two" == vConfig.KeyName {
			buyLandTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "buy_land_three" == vConfig.KeyName {
			buyLandThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	//var (
	//	tmp0 float64
	//	tmp1 float64
	//)
	//tmp0, tmp1, err = GetReservers()
	//if nil != err || 1 >= tmp0 || 1 >= tmp1 {
	//	return &pb.BuyReply{
	//		Status: "获取交易池数据失败",
	//	}, nil
	//}

	if 1 == req.SendBody.BuyType {
		var (
			seed *Seed
		)
		seed, err = ac.userRepo.GetSeedBuyByID(ctx, req.SendBody.Id, 4)
		if nil != err || nil == seed {
			return &pb.BuyReply{
				Status: "不存种子",
			}, nil
		}

		if user.ID == seed.UserId {
			return &pb.BuyReply{
				Status: "不允许购买自己的",
			}, nil
		}
		if 0 >= seed.SellAmount {
			return &pb.BuyReply{
				Status: "金额错误",
			}, nil
		}

		if user.AmountUsdt < seed.SellAmount {
			return &pb.BuyReply{
				Status: "usdt余额不足",
			}, nil
		}
		// 种子
		tmpGet := seed.SellAmount - seed.SellAmount*feeRate
		if 0 >= tmpGet {
			return &pb.BuyReply{
				Status: "金额错误",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.BuySeed(ctx, seed.SellAmount, tmpGet, seed.UserId, user.ID, seed.ID)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您购买了种子，花费"+fmt.Sprintf("%.2f", seed.SellAmount)+"USDT",
				"You've pay "+fmt.Sprintf("%.2f", seed.SellAmount)+" USDT for seed",
			)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				seed.UserId,
				"您出售了种子，获得"+fmt.Sprintf("%.2f", tmpGet)+"USDT",
				"You've get "+fmt.Sprintf("%.2f", tmpGet)+" USDT for seed",
			)
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			fmt.Println(err, "buySeed", user)
			return &pb.BuyReply{
				Status: "购买失败",
			}, nil
		}
	} else if 2 == req.SendBody.BuyType {
		var (
			prop *Prop
		)
		prop, err = ac.userRepo.GetPropByID(ctx, req.SendBody.Id, 4)
		if nil != err || nil == prop {
			return &pb.BuyReply{
				Status: "不存道具",
			}, nil
		}

		if user.ID == prop.UserId {
			return &pb.BuyReply{
				Status: "不允许购买自己的",
			}, nil
		}

		if 0 >= prop.SellAmount {
			return &pb.BuyReply{
				Status: "金额错误",
			}, nil
		}

		if user.GitNew < prop.SellAmount {
			return &pb.BuyReply{
				Status: "充值ispay余额不足",
			}, nil
		}

		// 种子
		tmpGet := prop.SellAmount - prop.SellAmount*feeRate
		if 0 >= tmpGet {
			return &pb.BuyReply{
				Status: "金额错误",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.BuyProp(ctx, prop.SellAmount, tmpGet, prop.UserId, user.ID, prop.ID)
			if nil != err {
				return err
			}
			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您购买了道具，花费"+fmt.Sprintf("%.2f", prop.SellAmount)+"ISPAY",
				"You've pay "+fmt.Sprintf("%.2f", prop.SellAmount)+" ISPAY for prop",
			)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				prop.UserId,
				"您出售了道具，获得"+fmt.Sprintf("%.2f", tmpGet)+"ISPAY",
				"You've get "+fmt.Sprintf("%.2f", tmpGet)+" ISPAY for prop",
			)
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			fmt.Println(err, "buyProp", user)
			return &pb.BuyReply{
				Status: "购买失败",
			}, nil
		}
	} else if 3 == req.SendBody.BuyType {
		var (
			land *Land
		)
		land, err = ac.userRepo.GetLandByID(ctx, req.SendBody.Id)
		if nil != err || nil == land {
			return &pb.BuyReply{
				Status: "不存道具",
			}, nil
		}

		if user.ID == land.UserId {
			return &pb.BuyReply{
				Status: "不允许购买自己的",
			}, nil
		}

		if 4 != land.Status {
			return &pb.BuyReply{
				Status: "未出售",
			}, nil
		}

		if 0 >= land.SellAmount {
			return &pb.BuyReply{
				Status: "金额错误",
			}, nil
		}

		if user.AmountUsdt < land.SellAmount {
			return &pb.BuyReply{
				Status: "usdt余额不足",
			}, nil
		}

		// 土地
		tmpGet := land.SellAmount - land.SellAmount*feeRate
		if 0 >= tmpGet {
			return &pb.BuyReply{
				Status: "金额错误",
			}, nil
		}

		usersMap := make(map[uint64]*User, 0)
		tmpRecommendUserIds := make([]string, 0)
		// 直推奖
		if 1 == land.CanReward {
			// 推荐
			var (
				userRecommend *UserRecommend
			)
			userRecommend, err = ac.userRepo.GetUserRecommendByUserId(ctx, user.ID)
			if nil == userRecommend || nil != err {
				return &pb.BuyReply{
					Status: "查询推荐错误",
				}, nil
			}
			if "" != userRecommend.RecommendCode {
				tmpRecommendUserIds = strings.Split(userRecommend.RecommendCode, "D")
			}

			userIds := make([]uint64, 0)
			tmpIi := 0
			for i := len(tmpRecommendUserIds) - 1; i >= 0; i-- {
				if 3 <= tmpIi {
					break
				}
				tmpIi++

				tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIds[i], 10, 64) // 最后一位是直推人
				if 0 >= tmpUserId {
					continue
				}

				userIds = append(userIds, tmpUserId)
			}

			if 0 < len(userIds) {
				usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
				if nil != err {
					return &pb.BuyReply{
						Status: "查询推荐错误",
					}, nil
				}
			}

		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.BuyLand(ctx, land.SellAmount, tmpGet, land.UserId, user.ID, land.ID)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				land.UserId,
				"您购买了土地，花费"+strconv.FormatFloat(land.SellAmount, 'f', -1, 64)+"USDT",
				"You've pay "+strconv.FormatFloat(land.SellAmount, 'f', -1, 64)+" USDT for land",
			)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您出售了土地，获得"+strconv.FormatFloat(tmpGet, 'f', -1, 64)+"USDT",
				"You've get "+strconv.FormatFloat(tmpGet, 'f', -1, 64)+" USDT for land",
			)
			if nil != err {
				return err
			}

			tmpI := 0
			for i := len(tmpRecommendUserIds) - 1; i >= 0; i-- {
				if 3 <= tmpI {
					break
				}
				tmpI++

				tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIds[i], 10, 64) // 最后一位是直推人
				if 0 >= tmpUserId {
					continue
				}

				if _, ok := usersMap[tmpUserId]; !ok {
					continue
				}

				tmpReward := float64(0)

				tmpNum := uint64(41)
				tmpReward = land.SellAmount * buyLandOne
				if 1 == tmpI {

				} else if 2 == tmpI {
					tmpReward = land.SellAmount * buyLandTwo
					tmpNum = 42
				} else if 3 == tmpI {
					tmpReward = land.SellAmount * buyLandThree
					tmpNum = 43
				} else {
					break
				}

				// 奖励
				err = ac.userRepo.PlantPlatTwoTwoLL(ctx, tmpUserId, user.ID, tmpNum, tmpReward)
				if nil != err {
					return err
				}

				err = ac.userRepo.CreateNotice(
					ctx,
					tmpUserId,
					"您下级购买土地，收获了"+fmt.Sprintf("%.2f", tmpReward)+"USDT",
					"Partner buy land, You've harvest "+fmt.Sprintf("%.2f", tmpReward)+" USDT",
				)
				if nil != err {
					return err
				}
			}

			return nil
		}); nil != err {
			fmt.Println(err, "buyLand", user)
			return &pb.BuyReply{
				Status: "购买失败",
			}, nil
		}
	} else {
		return &pb.BuyReply{
			Status: "参数错误",
		}, nil
	}

	return &pb.BuyReply{
		Status: "ok",
	}, nil
}

func (ac *AppUsecase) Sell(ctx context.Context, address string, req *pb.SellRequest) (*pb.SellReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.SellReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.SellReply{
			Status: "锁定用户",
		}, nil
	}

	tmpSellAmount := req.SendBody.Amount
	if 1 == req.SendBody.Num {
		if 0 >= tmpSellAmount {
			return &pb.SellReply{
				Status: "售价不能为0",
			}, nil
		}

		if 1 == req.SendBody.SellType {
			if 1 != user.CanSellProp {
				return &pb.SellReply{
					Status: "暂未开放",
				}, nil
			}

			if 0 < req.SendBody.Id {
				var (
					seed *Seed
				)
				seed, err = ac.userRepo.GetSeedBuyByID(ctx, req.SendBody.Id, 0)
				if nil != err || nil == seed {
					return &pb.SellReply{
						Status: "不存在种子",
					}, nil
				}

				if user.ID != seed.UserId {
					return &pb.SellReply{
						Status: "不是自己的种子",
					}, nil
				}

				if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
					return ac.userRepo.SellSeed(ctx, seed.ID, user.ID, tmpSellAmount)
				}); nil != err {
					fmt.Println(err, "sellSeed", user)
					return &pb.SellReply{
						Status: "上架失败",
					}, nil
				}
			} else if 0 < len(req.SendBody.LandIds) {
				partsIds := strings.Split(req.SendBody.LandIds, "&")

				if 0 >= len(partsIds) {
					return &pb.SellReply{
						Status: "参数错误，id为空",
					}, nil
				}

				for _, v := range partsIds {
					perLandId, _ := strconv.ParseUint(v, 10, 64)

					if perLandId == 0 {
						continue
					}

					var (
						seed *Seed
					)
					seed, err = ac.userRepo.GetSeedBuyByID(ctx, perLandId, 0)
					if nil != err || nil == seed {
						return &pb.SellReply{
							Status: "不存在种子",
						}, nil
					}

					if user.ID != seed.UserId {
						return &pb.SellReply{
							Status: "不是自己的种子",
						}, nil
					}

					if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
						return ac.userRepo.SellSeed(ctx, seed.ID, user.ID, tmpSellAmount)
					}); nil != err {
						fmt.Println(err, "sellSeed", user)
						return &pb.SellReply{
							Status: "上架失败",
						}, nil
					}
				}
			} else {
				return &pb.SellReply{
					Status: "参数错误",
				}, nil
			}
		} else if 2 == req.SendBody.SellType {
			if 1 != user.CanSellProp {
				return &pb.SellReply{
					Status: "暂未开放",
				}, nil
			}

			if 0 < req.SendBody.Id {
				var (
					prop *Prop
				)
				prop, err = ac.userRepo.GetPropByIDSell(ctx, req.SendBody.Id, 2)
				if nil != err || nil == prop {
					return &pb.SellReply{
						Status: "不存在道具",
					}, nil
				}

				if user.ID != prop.UserId {
					return &pb.SellReply{
						Status: "不是自己的",
					}, nil
				}

				if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
					return ac.userRepo.SellProp(ctx, prop.ID, user.ID, tmpSellAmount)
				}); nil != err {
					fmt.Println(err, "sellProp", user)
					return &pb.SellReply{
						Status: "上架失败",
					}, nil
				}
			} else if 0 < len(req.SendBody.LandIds) {
				partsIds := strings.Split(req.SendBody.LandIds, "&")

				if 0 >= len(partsIds) {
					return &pb.SellReply{
						Status: "参数错误，id为空",
					}, nil
				}

				for _, v := range partsIds {
					perLandId, _ := strconv.ParseUint(v, 10, 64)

					if perLandId == 0 {
						continue
					}

					var (
						prop *Prop
					)
					prop, err = ac.userRepo.GetPropByIDSell(ctx, perLandId, 2)
					if nil != err || nil == prop {
						return &pb.SellReply{
							Status: "不存在道具",
						}, nil
					}

					if user.ID != prop.UserId {
						return &pb.SellReply{
							Status: "不是自己的",
						}, nil
					}

					if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
						return ac.userRepo.SellProp(ctx, prop.ID, user.ID, tmpSellAmount)
					}); nil != err {
						fmt.Println(err, "sellProp", user)
						return &pb.SellReply{
							Status: "上架失败",
						}, nil
					}
				}

			} else {
				return &pb.SellReply{
					Status: "参数错误",
				}, nil
			}
		} else if 3 == req.SendBody.SellType {
			if 1 != user.CanSell {
				return &pb.SellReply{
					Status: "暂未开放",
				}, nil
			}

			var (
				configs  []*Config
				sellLand uint64
			)

			// 配置
			configs, err = ac.userRepo.GetConfigByKeys(ctx,
				"sell_land",
			)
			if nil != err || nil == configs {
				return &pb.SellReply{
					Status: "配置错误",
				}, nil
			}
			for _, vConfig := range configs {
				if "sell_land" == vConfig.KeyName {
					sellLand, _ = strconv.ParseUint(vConfig.Value, 10, 64)
				}
			}

			if 0 >= sellLand {
				return &pb.SellReply{
					Status: "暂未开放",
				}, nil
			}

			if 0 < req.SendBody.Id {
				var (
					land *Land
				)
				land, err = ac.userRepo.GetLandByID(ctx, req.SendBody.Id)
				if nil != err || nil == land {
					return &pb.SellReply{
						Status: "不存在土地",
					}, nil
				}

				if user.ID != land.UserId {
					return &pb.SellReply{
						Status: "不是自己的",
					}, nil
				}

				if 0 != land.LocationNum {
					return &pb.SellReply{
						Status: "土地布置中",
					}, nil
				}

				if 0 != land.Status {
					return &pb.SellReply{
						Status: "不符合上架状态",
					}, nil
				}

				if 1 != land.One {
					return &pb.SellReply{
						Status: "不可出售土地",
					}, nil
				}

				if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
					return ac.userRepo.SellLand(ctx, land.ID, user.ID, tmpSellAmount)
				}); nil != err {
					fmt.Println(err, "sellProp", user)
					return &pb.SellReply{
						Status: "上架失败",
					}, nil
				}
			} else if 0 < len(req.SendBody.LandIds) {
				partsIds := strings.Split(req.SendBody.LandIds, "&")

				if 0 >= len(partsIds) {
					return &pb.SellReply{
						Status: "参数错误，id为空",
					}, nil
				}

				for _, v := range partsIds {
					perLandId, _ := strconv.ParseUint(v, 10, 64)

					if perLandId == 0 {
						continue
					}
					var (
						land *Land
					)
					land, err = ac.userRepo.GetLandByID(ctx, perLandId)
					if nil != err || nil == land {
						return &pb.SellReply{
							Status: "不存在土地",
						}, nil
					}

					if user.ID != land.UserId {
						return &pb.SellReply{
							Status: "不是自己的",
						}, nil
					}

					if 0 != land.LocationNum {
						return &pb.SellReply{
							Status: "土地布置中",
						}, nil
					}

					if 0 != land.Status {
						return &pb.SellReply{
							Status: "不符合上架状态",
						}, nil
					}

					if 1 != land.One {
						return &pb.SellReply{
							Status: "不可出售土地",
						}, nil
					}

					if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
						return ac.userRepo.SellLand(ctx, land.ID, user.ID, tmpSellAmount)
					}); nil != err {
						fmt.Println(err, "sellProp", user)
						return &pb.SellReply{
							Status: "上架失败",
						}, nil
					}

				}
			} else {
				return &pb.SellReply{
					Status: "参数错误",
				}, nil
			}
		} else {
			return &pb.SellReply{
				Status: "参数错误",
			}, nil
		}
	} else {
		if 1 == req.SendBody.SellType {
			var (
				seed *Seed
			)
			seed, err = ac.userRepo.GetSeedBuyByID(ctx, req.SendBody.Id, 4)
			if nil != err || nil == seed {
				return &pb.SellReply{
					Status: "不存在种子",
				}, nil
			}

			if user.ID != seed.UserId {
				return &pb.SellReply{
					Status: "不是自己的种子",
				}, nil
			}

			if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
				return ac.userRepo.UnSellSeed(ctx, seed.ID, user.ID)
			}); nil != err {
				fmt.Println(err, "unSellSeed", user)
				return &pb.SellReply{
					Status: "下架失败",
				}, nil
			}
		} else if 2 == req.SendBody.SellType {
			var (
				prop *Prop
			)
			prop, err = ac.userRepo.GetPropByID(ctx, req.SendBody.Id, 4)
			if nil != err || nil == prop {
				return &pb.SellReply{
					Status: "不存在道具",
				}, nil
			}

			if user.ID != prop.UserId {
				return &pb.SellReply{
					Status: "不是自己的",
				}, nil
			}

			if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
				return ac.userRepo.UnSellProp(ctx, prop.ID, user.ID)
			}); nil != err {
				fmt.Println(err, "unSellProp", user)
				return &pb.SellReply{
					Status: "下架失败",
				}, nil
			}
		} else if 3 == req.SendBody.SellType {
			var (
				land *Land
			)
			land, err = ac.userRepo.GetLandByIDTwo(ctx, req.SendBody.Id)
			if nil != err || nil == land {
				return &pb.SellReply{
					Status: "不存在土地",
				}, nil
			}

			if user.ID != land.UserId {
				return &pb.SellReply{
					Status: "不是自己的",
				}, nil
			}

			if 0 != land.LocationNum {
				return &pb.SellReply{
					Status: "土地布置中",
				}, nil
			}

			if 4 != land.Status {
				return &pb.SellReply{
					Status: "不符合下架要求",
				}, nil
			}

			if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
				return ac.userRepo.UnSellLand(ctx, land.ID, user.ID)
			}); nil != err {
				fmt.Println(err, "unSellLand", user)
				return &pb.SellReply{
					Status: "下架失败",
				}, nil
			}
		} else {
			return &pb.SellReply{
				Status: "参数错误",
			}, nil
		}
	}

	return &pb.SellReply{
		Status: "ok",
	}, nil
}

var stakeGitLock sync.Mutex

func (ac *AppUsecase) StakeGit(ctx context.Context, address string, req *pb.StakeGitRequest) (*pb.StakeGitReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.StakeGitReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.StakeGitReply{
			Status: "锁定用户",
		}, nil
	}

	stakeGitLock.Lock()
	defer stakeGitLock.Unlock()

	if 1 == req.SendBody.Num {
		var (
			configs      []*Config
			stakePrice   float64
			stakePriceOn uint64
			stakeRateNew float64
			//rentRateTwo   float64
			//rentRateThree float64
		)

		// 配置
		configs, err = ac.userRepo.GetConfigByKeys(ctx,
			"stake_price",
			"stake_price_on",
			"stake_rate_new",
		)
		if nil != err || nil == configs {
			return &pb.StakeGitReply{
				Status: "配置错误",
			}, nil
		}
		for _, vConfig := range configs {
			if "stake_price" == vConfig.KeyName {
				stakePrice, _ = strconv.ParseFloat(vConfig.Value, 10)
			}
			if "stake_price_on" == vConfig.KeyName {
				stakePriceOn, _ = strconv.ParseUint(vConfig.Value, 10, 64)
			}
			if "stake_rate_new" == vConfig.KeyName {
				stakeRateNew, _ = strconv.ParseFloat(vConfig.Value, 10)
			}
		}

		if 0.01 > req.SendBody.Amount {
			return &pb.StakeGitReply{
				Status: "ispay>=0.01",
			}, nil
		}

		if req.SendBody.Amount > user.GitNew {
			return &pb.StakeGitReply{
				Status: "ispay not enough|ispay余额不足",
			}, nil
		}

		//if 0.001 >= user.StakeIspayAmount {
		//	return &pb.StakeGitReply{
		//		Status: "max stake|达到质押上限",
		//	}, nil
		//}

		var (
			//tmp0             float64
			//tmp1             float64
			usdtAmount       float64
			usdtAmountOrigin float64
		)
		//tmp0, tmp1, err = GetReservers()
		//if nil != err || 1 >= tmp0 || 1 >= tmp1 {
		//	return &pb.StakeGitReply{
		//		Status: "获取交易池数据失败",
		//	}, nil
		//}

		tmpPrice := float64(0)
		if 1 == stakePriceOn {
			usdtAmount = req.SendBody.Amount * stakePrice
			usdtAmountOrigin = usdtAmount
			usdtAmount = usdtAmount * stakeRateNew / 30
			if 0.00000001 >= usdtAmount {
				return &pb.StakeGitReply{
					Status: "获取交易池数据失败，价格错误",
				}, nil
			}
			tmpPrice = stakePrice
		} else {
			var (
				newIspayPrice float64
			)
			newIspayPrice, err = GetIspayPrice()
			if nil != err || 0.0000001 > newIspayPrice {
				fmt.Println(err, newIspayPrice, "err stake ispay price")
				return &pb.StakeGitReply{
					Status: "获取交易池数据失败",
				}, nil
			}

			usdtAmount = req.SendBody.Amount * newIspayPrice
			usdtAmountOrigin = usdtAmount
			usdtAmount = usdtAmount * stakeRateNew / 30
			if 0.00000001 >= usdtAmount {
				return &pb.StakeGitReply{
					Status: "获取交易池数据失败，价格错误",
				}, nil
			}
			tmpPrice = newIspayPrice
		}

		dayLimit := uint64(30)
		//if 30 == req.SendBody.Day {
		//
		//} else if 60 == req.SendBody.Day {
		//	dayLimit = 60
		//} else if 90 == req.SendBody.Day {
		//	dayLimit = 90
		//} else if 120 == req.SendBody.Day {
		//	dayLimit = 120
		//} else if 360 == req.SendBody.Day {
		//	dayLimit = 360
		//} else {
		//	return &pb.StakeGitReply{
		//		Status: "time limit err|参数错误",
		//	}, nil
		//}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.SetStakeGit(ctx, user.ID, req.SendBody.Amount, usdtAmount, usdtAmountOrigin, tmpPrice, dayLimit)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您向粮仓质押"+fmt.Sprintf("%.5f", req.SendBody.Amount)+"ISPAY",
				"You've deposit "+fmt.Sprintf("%.5f", req.SendBody.Amount)+" ISPAY to granary",
			)
			if nil != err {
				return err
			}
			return nil
		}); nil != err {
			return &pb.StakeGitReply{
				Status: "stakeISPAY失败",
			}, nil
		}
	} else if 2 == req.SendBody.Num {
		return &pb.StakeGitReply{
			Status: "错误参数",
		}, nil
		//var (
		//	record *StakeGitRecord
		//)
		//record, err = ac.userRepo.GetStakeGitRecordsByID(ctx, req.SendBody.Id, user.ID) // 查询用户
		//if nil != err || nil == record {
		//	return &pb.StakeGitReply{
		//		Status: "不存在记录",
		//	}, nil
		//}
		//
		//if 30 > record.Day {
		//	return &pb.StakeGitReply{
		//		Status: "30 days limit|30天最少",
		//	}, nil
		//}
		//
		//if time.Now().Before(record.CreatedAt.Add(time.Duration(record.Day) * 24 * 3600 * time.Second)) {
		//	return &pb.StakeGitReply{
		//		Status: "time limit|未到解锁时间",
		//	}, nil
		//}
		//
		//if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		//	err = ac.userRepo.SetUnStakeGit(ctx, record.ID, user.ID, record.Amount)
		//	if nil != err {
		//		return err
		//	}
		//
		//	err = ac.userRepo.CreateNotice(
		//		ctx,
		//		user.ID,
		//		"您从粮仓解押"+fmt.Sprintf("%.5f", record.Amount)+"ISPAY",
		//		"You've withdraw "+fmt.Sprintf("%.5f", record.Amount)+" ISPAY from granary",
		//	)
		//	if nil != err {
		//		return err
		//	}
		//	return nil
		//}); nil != err {
		//	return &pb.StakeGitReply{
		//		Status: "stakeISPAY失败",
		//	}, nil
		//}
	} else {
		return &pb.StakeGitReply{
			Status: "错误参数",
		}, nil
	}

	return &pb.StakeGitReply{Status: "ok"}, nil
}

var rentLock sync.Mutex

func (ac *AppUsecase) RentLand(ctx context.Context, address string, req *pb.RentLandRequest) (*pb.RentLandReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.RentLandReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.RentLandReply{
			Status: "锁定用户",
		}, nil
	}

	rentLock.Lock()
	defer rentLock.Unlock()

	var (
		configs     []*Config
		rentRateOne float64
		//rentRateTwo   float64
		//rentRateThree float64
	)

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"rent_rate_one",
		"rent_rate_three",
		"rent_rate_two",
	)
	if nil != err || nil == configs {
		return &pb.RentLandReply{
			Status: "配置错误",
		}, nil
	}
	for _, vConfig := range configs {
		if "rent_rate_one" == vConfig.KeyName {
			rentRateOne, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		//if "rent_rate_three" == vConfig.KeyName {
		//	rentRateThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
		//if "rent_rate_two" == vConfig.KeyName {
		//	rentRateTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
	}

	//user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	//if nil != err || nil == user {
	//	return &pb.RentLandReply{
	//		Status: "不存在用户",
	//	}, nil
	//}

	rentRate := float64(0)
	if 1 == req.SendBody.Rate {
		rentRate = rentRateOne
	} else {
		return &pb.RentLandReply{
			Status: "比例错误",
		}, nil
	}

	//else if 2 == req.SendBody.Rate {
	//	rentRate = rentRateTwo
	//} else if 3 == req.SendBody.Rate {
	//	rentRate = rentRateThree
	//}

	if 1 == req.SendBody.Num {
		//if 1 != user.CanRent {
		//	return &pb.RentLandReply{
		//		Status: "暂未开放",
		//	}, nil
		//}

		if 0 < req.SendBody.LandId {
			var (
				land *Land
			)
			land, err = ac.userRepo.GetLandByID(ctx, req.SendBody.LandId)
			if nil != err || nil == land {
				return &pb.RentLandReply{
					Status: "不存在土地",
				}, nil
			}

			if user.ID != land.UserId {
				return &pb.RentLandReply{
					Status: "不是自己的",
				}, nil
			}

			if 1 != land.Status {
				return &pb.RentLandReply{
					Status: "请将土地布置在农场",
				}, nil
			}

			if 1 != land.Two {
				return &pb.RentLandReply{
					Status: "不允许出租类型",
				}, nil
			}

			//if land.PerHealth > land.MaxHealth {
			//	return &pb.RentLandReply{
			//		Status:    "肥沃度不足",
			//		StatusTwo: "Insufficient fertility.",
			//	}, nil
			//}

			if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
				return ac.userRepo.RentLand(ctx, land.ID, user.ID, rentRate)
			}); nil != err {
				fmt.Println(err, "rendLand", user)
				return &pb.RentLandReply{
					Status: "上架失败",
				}, nil
			}
		} else if 0 < len(req.SendBody.LandIds) {

			partsIds := strings.Split(req.SendBody.LandIds, "&")

			if 0 >= len(partsIds) {
				return &pb.RentLandReply{
					Status: "参数错误，id为空",
				}, nil
			}

			for _, v := range partsIds {
				perLandId, _ := strconv.ParseUint(v, 10, 64)

				if perLandId == 0 {
					continue
				}

				var (
					land *Land
				)
				land, err = ac.userRepo.GetLandByID(ctx, perLandId)
				if nil != err || nil == land {
					return &pb.RentLandReply{
						Status: "不存在土地",
					}, nil
				}

				if user.ID != land.UserId {
					return &pb.RentLandReply{
						Status: "不是自己的",
					}, nil
				}

				if 1 != land.Status {
					return &pb.RentLandReply{
						Status: "请将土地布置在农场",
					}, nil
				}

				if 1 != land.Two {
					return &pb.RentLandReply{
						Status: "不允许出租类型",
					}, nil
				}

				//if land.PerHealth > land.MaxHealth {
				//	return &pb.RentLandReply{
				//		Status:    "肥沃度不足",
				//		StatusTwo: "Insufficient fertility.",
				//	}, nil
				//}

				if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
					return ac.userRepo.RentLand(ctx, land.ID, user.ID, rentRate)
				}); nil != err {
					fmt.Println(err, "rendLand", user)
					return &pb.RentLandReply{
						Status: "上架失败",
					}, nil
				}
			}
		} else {
			return &pb.RentLandReply{
				Status: "参数错误",
			}, nil
		}

	} else if 2 == req.SendBody.Num {
		var (
			land *Land
		)
		land, err = ac.userRepo.GetLandByIDTwo(ctx, req.SendBody.LandId)
		if nil != err || nil == land {
			return &pb.RentLandReply{
				Status: "不存在土地",
			}, nil
		}

		if user.ID != land.UserId {
			return &pb.RentLandReply{
				Status: "不是自己的",
			}, nil
		}

		if 3 != land.Status {
			return &pb.RentLandReply{
				Status: "土地使用中",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			return ac.userRepo.UnRentLand(ctx, land.ID, user.ID)
		}); nil != err {
			fmt.Println(err, "unRendLand", user)
			return &pb.RentLandReply{
				Status: "下架失败",
			}, nil
		}
	} else {
		return &pb.RentLandReply{
			Status: "错误参数",
		}, nil
	}

	return &pb.RentLandReply{Status: "ok"}, nil
}

var LandPlay sync.Mutex

func (ac *AppUsecase) LandPlay(ctx context.Context, address string, req *pb.LandPlayRequest) (*pb.LandPlayReply, error) {
	var (
		user      *User
		userTwo   *User
		userTwoId uint64
		//box  *BoxRecord
		err error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandPlayReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandPlayReply{
			Status: "锁定用户",
		}, nil
	}

	if 10 <= len(req.SendBody.UserAddress) {
		if 1 == user.CanLand {
			userTwo, err = ac.userRepo.GetUserByAddress(ctx, req.SendBody.UserAddress) // 查询用户
			if nil != err || nil == userTwo {
				return &pb.LandPlayReply{
					Status: "不存在用户",
				}, nil
			}
			userTwoId = userTwo.ID
		}
	}

	LandPlay.Lock()
	defer LandPlay.Unlock()

	if 1 == req.SendBody.Num {
		var (
			land *Land
		)
		land, err = ac.userRepo.GetLandByIDTwo(ctx, req.SendBody.LandId)
		if nil != err || nil == land {
			return &pb.LandPlayReply{
				Status: "不存在土地",
			}, nil
		}

		if user.ID != land.UserId {
			return &pb.LandPlayReply{
				Status: "不是自己的",
			}, nil
		}

		if 1 != land.Status {
			return &pb.LandPlayReply{
				Status: "请将土地布置在农场",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			return ac.userRepo.LandPull(ctx, land.ID, user.ID)
		}); nil != err {
			fmt.Println(err, "LandPull", user)
			return &pb.LandPlayReply{
				Status: "下架失败",
			}, nil
		}
	} else if 2 == req.SendBody.Num {
		if 0 < userTwoId {
			return &pb.LandPlayReply{
				Status: "在他人农场布置土地不支持替换",
			}, nil
		}

		var (
			land  *Land
			land2 *Land
		)
		land, err = ac.userRepo.GetLandByIDTwo(ctx, req.SendBody.LandId)
		if nil != err || nil == land {
			return &pb.LandPlayReply{
				Status: "不存在土地",
			}, nil
		}

		if 1 <= land.LocationNum && 9 >= land.LocationNum {

		} else {
			return &pb.LandPlayReply{
				Status: "非布置土地",
			}, nil
		}

		land2, err = ac.userRepo.GetLandByID(ctx, req.SendBody.LandTwoId)
		if nil != err || nil == land2 {
			return &pb.LandPlayReply{
				Status: "不存在土地",
			}, nil
		}

		if 0 != land2.LocationNum {
			return &pb.LandPlayReply{
				Status: "已布置土地",
			}, nil
		}

		if user.ID != land.UserId {
			return &pb.LandPlayReply{
				Status: "不是自己的",
			}, nil
		}

		if user.ID != land2.UserId {
			return &pb.LandPlayReply{
				Status: "不是自己的",
			}, nil
		}

		if 1 != land.Status {
			return &pb.LandPlayReply{
				Status: "请将土地布置在农场",
			}, nil
		}

		if 0 != land2.Status {
			return &pb.LandPlayReply{
				Status: "土地使用中",
			}, nil
		}

		if int64(land2.LimitDate) <= time.Now().Unix() {
			return &pb.LandPlayReply{
				Status: "土地已过期",
			}, nil
		}

		if 1 > land.LocationNum || 9 < land.LocationNum {
			return &pb.LandPlayReply{
				Status: "位置参数错误",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.LandPull(ctx, land.ID, user.ID)
			if nil != err {
				return err
			}

			return ac.userRepo.LandPush(ctx, land2.ID, user.ID, userTwoId, req.SendBody.LocationNum)
		}); nil != err {
			fmt.Println(err, "LandPullPush", user)
			return &pb.LandPlayReply{
				Status: "替换失败",
			}, nil
		}
	} else if 3 == req.SendBody.Num {
		if 1 > req.SendBody.LocationNum || 9 < req.SendBody.LocationNum {
			return &pb.LandPlayReply{
				Status: "位置参数错误",
			}, nil
		}

		var (
			tmpLand    *Land
			tmpLandTwo *Land
			land       *Land
		)
		if 0 < userTwoId {
			// 自己
			tmpLand, err = ac.userRepo.GetLandByUserIdLocationNum(ctx, userTwoId, req.SendBody.LocationNum)
			if nil != err {
				return &pb.LandPlayReply{
					Status: "错误查询",
				}, nil
			}

			if nil != tmpLand {
				return &pb.LandPlayReply{
					Status: "存在布置土地",
				}, nil
			}

			// 别人
			tmpLandTwo, err = ac.userRepo.GetLandByUserIdLocationUserId(ctx, req.SendBody.LocationNum, userTwoId)
			if nil != err {
				return &pb.LandPlayReply{
					Status: "错误查询",
				}, nil
			}

			if nil != tmpLandTwo {
				return &pb.LandPlayReply{
					Status: "存在他人布置土地",
				}, nil
			}

		} else {
			// 自己
			tmpLand, err = ac.userRepo.GetLandByUserIdLocationNum(ctx, user.ID, req.SendBody.LocationNum)
			if nil != err {
				return &pb.LandPlayReply{
					Status: "错误查询",
				}, nil
			}

			if nil != tmpLand {
				return &pb.LandPlayReply{
					Status: "存在布置土地",
				}, nil
			}

			// 别人
			tmpLandTwo, err = ac.userRepo.GetLandByUserIdLocationUserId(ctx, req.SendBody.LocationNum, user.ID)
			if nil != err {
				return &pb.LandPlayReply{
					Status: "错误查询",
				}, nil
			}

			if nil != tmpLandTwo {
				return &pb.LandPlayReply{
					Status: "存在他人布置土地",
				}, nil
			}
		}

		land, err = ac.userRepo.GetLandByID(ctx, req.SendBody.LandId)
		if nil != err || nil == land {
			return &pb.LandPlayReply{
				Status: "不存在土地",
			}, nil
		}

		if 0 < land.LocationUserId {
			return &pb.LandPlayReply{
				Status: "数据错误",
			}, nil
		}

		if user.ID != land.UserId {
			return &pb.LandPlayReply{
				Status: "不是自己的",
			}, nil
		}

		if 0 != land.LocationNum {
			return &pb.LandPlayReply{
				Status: "不是空闲的土地",
			}, nil
		}

		if 0 != land.Status {
			return &pb.LandPlayReply{
				Status: "不是空闲的土地",
			}, nil
		}

		//if land.PerHealth > land.MaxHealth {
		//	return &pb.LandPlayReply{
		//		Status:    "肥沃度不足",
		//		StatusTwo: "Insufficient fertility.",
		//	}, nil
		//}

		if int64(land.LimitDate) <= time.Now().Unix() {
			return &pb.LandPlayReply{
				Status: "土地已过期",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			return ac.userRepo.LandPush(ctx, land.ID, user.ID, userTwoId, req.SendBody.LocationNum)
		}); nil != err {
			fmt.Println(err, "LandPush", user)
			return &pb.LandPlayReply{
				Status: "失败",
			}, nil
		}
	} else {
		return &pb.LandPlayReply{
			Status: "错误参数",
		}, nil
	}

	return &pb.LandPlayReply{Status: "ok"}, nil
}

func (ac *AppUsecase) LandAddOutRate(ctx context.Context, address string, req *pb.LandAddOutRateRequest) (*pb.LandAddOutRateReply, error) {
	return &pb.LandAddOutRateReply{Status: "ok"}, nil
	var (
		user *User
		//box  *BoxRecord
		err error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.LandAddOutRateReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.LandAddOutRateReply{
			Status: "锁定用户",
		}, nil
	}

	var (
		land *Land
	)
	land, err = ac.userRepo.GetLandByID(ctx, req.SendBody.LandId)
	if nil != err || nil == land {
		return &pb.LandAddOutRateReply{
			Status: "土地不存在或已失效，撤销布置",
		}, nil
	}

	if user.ID != land.UserId {
		return &pb.LandAddOutRateReply{
			Status: "不是自己的",
		}, nil
	}

	if 1 != land.Status && 0 != land.Status && 3 != land.Status {
		return &pb.LandAddOutRateReply{
			Status: "土地不符合培育条件",
		}, nil
	}

	// 化肥道具
	var (
		prop *Prop
	)
	prop, err = ac.userRepo.GetPropByID(ctx, req.SendBody.Id, 1)
	if nil != err || nil == prop {
		return &pb.LandAddOutRateReply{
			Status: "不存道具",
		}, nil
	}

	if user.ID != prop.UserId {
		return &pb.LandAddOutRateReply{
			Status: "不是自己的道具",
		}, nil
	}

	if 11 != prop.PropType {
		return &pb.LandAddOutRateReply{
			Status: "不是化肥",
		}, nil
	}

	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		return ac.userRepo.LandAddOutRate(ctx, prop.ID, land.ID, user.ID)
	}); nil != err {
		fmt.Println(err, "LandAddOutRate", user)
		return &pb.LandAddOutRateReply{
			Status: "培育失败",
		}, nil
	}

	return &pb.LandAddOutRateReply{Status: "ok"}, nil
}

var GetLandLock sync.Mutex

func (ac *AppUsecase) GetLand(ctx context.Context, address string, req *pb.GetLandRequest) (*pb.GetLandReply, error) {
	var (
		user      *User
		landInfos map[uint64]*LandInfo
		err       error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.GetLandReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.GetLandReply{
			Status: "锁定用户",
		}, nil
	}

	GetLandLock.Lock()
	defer GetLandLock.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.GetLandReply{
			Status: "不存在用户",
		}, nil
	}

	landInfos, err = ac.userRepo.GetLandInfoByLevels(ctx)
	if nil != err {
		return &pb.GetLandReply{
			Status: "信息错误",
		}, nil
	}

	if 0 >= len(landInfos) {
		return &pb.GetLandReply{
			Status: "配置信息错误",
		}, nil
	}

	now := time.Now().Unix()
	if 1 == req.SendBody.Num {

		var (
			prop []*Prop
		)
		// 11化肥，12水，13手套，14除虫剂，15铲子，16盲盒，17地契
		propType := []uint64{11, 17}
		prop, err = ac.userRepo.GetPropsByUserIDPropType(ctx, user.ID, propType)
		if nil != err {
			return &pb.GetLandReply{
				Status: "道具错误",
			}, nil
		}

		one := uint64(0)
		two := make([]uint64, 0)
		propIds := make([]uint64, 0)
		for _, vProp := range prop {
			if vProp.PropType == 17 {
				one = vProp.ID
				propIds = append(propIds, vProp.ID)
				break
			}
		}

		for _, vProp := range prop {
			if vProp.PropType == 11 {
				two = append(two, vProp.ID)
				if 5 <= len(two) {
					propIds = append(propIds, vProp.ID)
					break
				}
			}
		}

		if 0 >= one {
			return &pb.GetLandReply{
				Status: "缺少地契",
			}, nil
		}

		if 5 > len(two) {
			return &pb.GetLandReply{
				Status: "缺少化肥",
			}, nil
		}

		if 6 > len(propIds) {
			return &pb.GetLandReply{
				Status: "缺少化肥和地契",
			}, nil
		}

		tmpLevel := uint64(1)
		if _, ok := landInfos[tmpLevel]; !ok {
			return &pb.GetLandReply{
				Status: "不存在级别土地的配置信息",
			}, nil
		}

		rngTmp := rand2.New(rand2.NewSource(time.Now().UnixNano()))
		outMin := int64(landInfos[tmpLevel].OutPutRateMin)
		outMax := int64(landInfos[tmpLevel].OutPutRateMax)

		// 计算随机范围
		tmpNum := outMax - outMin
		if tmpNum <= 0 {
			tmpNum = 1 // 避免 Int63n(0) panic
		}

		// 生成随机数
		randomNumber := outMin + rngTmp.Int63n(tmpNum)

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			// 地契和化肥扣除
			for _, vPropIds := range propIds {
				err = ac.userRepo.PropStatusThree(ctx, vPropIds)
				if nil != err {
					return err
				}
			}

			_, err = ac.userRepo.CreateLand(ctx, &Land{
				UserId:     user.ID,
				Level:      landInfos[tmpLevel].Level,
				OutPutRate: float64(randomNumber),
				MaxHealth:  landInfos[tmpLevel].MaxHealth,
				PerHealth:  landInfos[tmpLevel].PerHealth,
				LimitDate:  uint64(now) + landInfos[tmpLevel].LimitDateMax*3600*24,
				Status:     0,
				One:        1,
				Two:        1,
				Three:      1,
			})
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			return &pb.GetLandReply{
				Status: "培育失败",
			}, nil
		}
	} else if 2 == req.SendBody.Num {
		if 0 >= req.SendBody.LandOneId || 0 >= req.SendBody.LandTwoId {
			return &pb.GetLandReply{
				Status: "不存在土地",
			}, nil
		}

		if req.SendBody.LandOneId == req.SendBody.LandTwoId {
			return &pb.GetLandReply{
				Status: "请选择两块土地",
			}, nil
		}

		var (
			land *Land
		)
		land, err = ac.userRepo.GetLandByID(ctx, req.SendBody.LandOneId)
		if nil != err || nil == land {
			return &pb.GetLandReply{
				Status: "不存在土地",
			}, nil
		}

		if user.ID != land.UserId {
			return &pb.GetLandReply{
				Status: "不是自己的",
			}, nil
		}

		if 0 != land.Status {
			return &pb.GetLandReply{
				Status: "土地不符合合成条件",
			}, nil
		}

		if 1 != land.Three {
			return &pb.GetLandReply{
				Status: "不可合成土地类型",
			}, nil
		}

		var (
			land2 *Land
		)
		land2, err = ac.userRepo.GetLandByID(ctx, req.SendBody.LandTwoId)
		if nil != err || nil == land2 {
			return &pb.GetLandReply{
				Status: "不存在土地",
			}, nil
		}

		if user.ID != land2.UserId {
			return &pb.GetLandReply{
				Status: "不是自己的",
			}, nil
		}

		if 0 != land2.Status {
			return &pb.GetLandReply{
				Status: "土地不符合合成条件",
			}, nil
		}

		if 1 != land2.Three {
			return &pb.GetLandReply{
				Status: "不可合成土地类型",
			}, nil
		}

		if land.Level != land2.Level {
			return &pb.GetLandReply{
				Status: "土地等级不一致",
			}, nil
		}

		if 10 <= land.Level {
			return &pb.GetLandReply{
				Status: "土地已到最高级别",
			}, nil
		}

		tmpLevel := land.Level + 1
		if _, ok := landInfos[tmpLevel]; !ok {
			return &pb.GetLandReply{
				Status: "不存在级别土地的配置信息",
			}, nil
		}

		rngTmp := rand2.New(rand2.NewSource(time.Now().UnixNano()))
		outMin := int64(landInfos[tmpLevel].OutPutRateMin)
		outMax := int64(landInfos[tmpLevel].OutPutRateMax)

		// 计算随机范围
		tmpNum := outMax - outMin
		if tmpNum <= 0 {
			tmpNum = 1 // 避免 Int63n(0) panic
		}

		// 生成随机数
		randomNumber := outMin + rngTmp.Int63n(tmpNum)

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.GetLand(ctx, land.ID, land2.ID, user.ID)
			if nil != err {
				return err
			}

			_, err = ac.userRepo.CreateLand(ctx, &Land{
				UserId:     user.ID,
				Level:      landInfos[tmpLevel].Level,
				OutPutRate: float64(randomNumber),
				MaxHealth:  landInfos[tmpLevel].MaxHealth,
				PerHealth:  landInfos[tmpLevel].PerHealth,
				LimitDate:  uint64(now) + landInfos[tmpLevel].LimitDateMax*3600*24,
				Status:     0,
				One:        1,
				Two:        1,
				Three:      1,
			})
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			return &pb.GetLandReply{
				Status: "培育失败",
			}, nil
		}
	} else {
		return &pb.GetLandReply{
			Status: "参数错误",
		}, nil
	}

	return &pb.GetLandReply{Status: "ok"}, nil
}

var stakeAndPlay sync.Mutex

func (ac *AppUsecase) StakeGet(ctx context.Context, address string, req *pb.StakeGetRequest) (*pb.StakeGetReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.StakeGetReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.StakeGetReply{
			Status: "锁定用户",
		}, nil
	}

	stakeAndPlay.Lock()
	defer stakeAndPlay.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.StakeGetReply{
			Status: "不存在用户",
		}, nil
	}

	var (
		stakeGetTotal *StakeGetTotal
	)
	stakeGetTotal, err = ac.userRepo.GetStakeGetTotal(ctx)
	if nil == stakeGetTotal || nil != err {
		return &pb.StakeGetReply{
			Status: "放大器总额错误查询",
		}, nil
	}

	var (
		stakeGet *StakeGet
	)
	stakeGet, err = ac.userRepo.GetUserStakeGet(ctx, user.ID)
	if nil == stakeGet || nil != err {
		return &pb.StakeGetReply{
			Status: "我的放大器错误查询",
		}, nil
	}

	var (
		configs    []*Config
		maxStake   float64
		minStake   float64
		minUnStake float64
	)
	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"max_stake",
		"min_stake",
		"min_stake_two",
	)
	if nil != err || nil == configs {
		return &pb.StakeGetReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "max_stake" == vConfig.KeyName {
			maxStake, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "min_stake" == vConfig.KeyName {
			minStake, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "min_stake_two" == vConfig.KeyName {
			minUnStake, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	// 质押
	if 1 == req.SendBody.Num {
		if uint64(minStake) > req.SendBody.Amount {
			return &pb.StakeGetReply{
				Status: "ispay金额低于限制",
			}, nil
		}

		if uint64(maxStake) < req.SendBody.Amount {
			return &pb.StakeGetReply{
				Status: "ispay金额要高于限制",
			}, nil
		}

		if req.SendBody.Amount > uint64(user.Git) {
			return &pb.StakeGetReply{
				Status: "ispay余额不足",
			}, nil
		}

		var mintedShares float64
		tmpAmount := float64(req.SendBody.Amount)
		if 0 >= stakeGetTotal.Balance || 0 >= stakeGetTotal.Amount {
			mintedShares = tmpAmount
		} else {
			mintedShares = tmpAmount * stakeGetTotal.Amount / stakeGetTotal.Balance
		}
		if 0 >= mintedShares {
			return &pb.StakeGetReply{
				Status: "份额计算不足",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.SetStakeGetTotal(ctx, mintedShares, tmpAmount)
			if nil != err {
				return err
			}

			err = ac.userRepo.SetStakeGet(ctx, user.ID, tmpAmount, mintedShares)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您向果实放大器质押"+fmt.Sprintf("%.2f", tmpAmount)+"ISPAY",
				"You've deposit "+fmt.Sprintf("%.2f", tmpAmount)+" ISPAY to game",
			)
			if nil != err {
				return err
			}
			return nil
		}); nil != err {
			return &pb.StakeGetReply{
				Status: "ispay余额不足",
			}, nil
		}
	} else if 2 == req.SendBody.Num {

		if 0 >= stakeGetTotal.Balance || 0 >= stakeGetTotal.Amount {
			return &pb.StakeGetReply{
				Status: "池子为空",
			}, nil
		}

		if uint64(minUnStake) > req.SendBody.Amount {
			return &pb.StakeGetReply{
				Status: "ispay最小提现限制",
			}, nil
		}

		if 0 >= stakeGet.StakeRate {
			return &pb.StakeGetReply{
				Status: "用户无可提ispay",
			}, nil
		}

		// 每份价值
		valuePerShare := stakeGetTotal.Balance / stakeGetTotal.Amount
		// 用户最大可提取金额
		maxWithdraw := stakeGet.StakeRate * valuePerShare
		if req.SendBody.Amount > uint64(maxWithdraw) {
			return &pb.StakeGetReply{
				Status: "可提ispay不足",
			}, nil
		}

		sharesToRemove := float64(req.SendBody.Amount) / valuePerShare

		tmpGit := float64(req.SendBody.Amount)

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.SetStakeGetTotalSub(ctx, sharesToRemove, tmpGit)
			if nil != err {
				return err
			}

			err = ac.userRepo.SetStakeGetSub(ctx, user.ID, tmpGit, sharesToRemove)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您在果实放大器解押"+fmt.Sprintf("%.2f", tmpGit)+"ISPAY",
				"You've withdraw "+fmt.Sprintf("%.2f", tmpGit)+" ISPAY from game",
			)
			if nil != err {
				return err
			}
			return nil
		}); nil != err {
			return &pb.StakeGetReply{
				Status: "ispay余额不足",
			}, nil
		}
	} else {
		return &pb.StakeGetReply{
			Status: "错误参数",
		}, nil
	}

	return &pb.StakeGetReply{
		Status: "ok",
	}, nil
}

func (ac *AppUsecase) StakeGetPlay(ctx context.Context, address string, req *pb.StakeGetPlayRequest) (*pb.StakeGetPlayReply, error) {
	var (
		user *User
		err  error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.StakeGetPlayReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.StakeGetPlayReply{
			Status: "锁定用户",
		}, nil
	}

	stakeAndPlay.Lock()
	defer stakeAndPlay.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.StakeGetPlayReply{
			Status: "不存在用户",
		}, nil
	}

	if req.SendBody.Amount > uint64(user.Git) {
		return &pb.StakeGetPlayReply{
			Status: "ispay余额不足",
		}, nil
	}

	var (
		configs       []*Config
		maxPlay       float64
		minPlay       float64
		winRate       float64
		stakeOverRate float64
	)
	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"max_play",
		"min_play",
		"stake_over_rate",
		"win_rate",
	)
	if nil != err || nil == configs {
		return &pb.StakeGetPlayReply{
			Status: "配置错误",
		}, nil
	}

	for _, vConfig := range configs {
		if "max_play" == vConfig.KeyName {
			maxPlay, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "min_play" == vConfig.KeyName {
			minPlay, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "win_rate" == vConfig.KeyName {
			winRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "stake_over_rate" == vConfig.KeyName {
			stakeOverRate, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	if uint64(minPlay) > req.SendBody.Amount {
		return &pb.StakeGetPlayReply{
			Status: "最少限制",
		}, nil
	}

	if uint64(maxPlay) < req.SendBody.Amount {
		return &pb.StakeGetPlayReply{
			Status: "最大限制",
		}, nil
	}

	var (
		stakeGetTotal *StakeGetTotal
	)
	stakeGetTotal, err = ac.userRepo.GetStakeGetTotal(ctx)
	if nil == stakeGetTotal || nil != err {
		return &pb.StakeGetPlayReply{
			Status: "放大器总额错误查询",
		}, nil
	}

	if 0 == uint64(stakeGetTotal.Balance) {
		return &pb.StakeGetPlayReply{
			Status: "资金池不足",
		}, nil
	}

	if uint64(stakeGetTotal.Balance) < req.SendBody.Amount {
		return &pb.StakeGetPlayReply{
			Status: "资金池不足",
		}, nil
	}

	if nil == rngPlay {
		var (
			seedInt     int64
			randomSeeds []*RandomSeed
		)
		randomSeeds, err = ac.userRepo.GetAllRandomSeeds(ctx)
		if nil != err {
			return &pb.StakeGetPlayReply{
				Status: "异常",
			}, nil
		}

		for _, v := range randomSeeds {
			if 3 == v.Scene {
				seedInt = int64(v.SeedValue)
				break
			}
		}

		if 0 >= seedInt {
			seedInt = time.Now().UnixNano()
			err = ac.userRepo.UpdateSeedValue(ctx, 3, uint64(seedInt))
			if nil != err {
				return &pb.StakeGetPlayReply{
					Status: "异常",
				}, nil
			}
		}

		rngPlay = rand2.New(rand2.NewSource(seedInt))
	}

	r := rngPlay.Float64()

	if r < winRate { // 赢：需要池子中有足够资金支付奖金
		tmpGit := float64(req.SendBody.Amount) - float64(req.SendBody.Amount)*stakeOverRate
		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.SetStakeGetPlay(ctx, user.ID, tmpGit, float64(req.SendBody.Amount))
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您在果实放大器赢得"+fmt.Sprintf("%.2f", tmpGit)+"ISPAY",
				"You've win "+fmt.Sprintf("%.2f", tmpGit)+" ISPAY from game",
			)
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			return &pb.StakeGetPlayReply{
				Status: "ispay余额不足",
			}, nil
		}

		return &pb.StakeGetPlayReply{Status: "ok", PlayStatus: 1, Amount: tmpGit}, nil
	} else { // 输：下注金额加入池子
		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.SetStakeGetPlaySub(ctx, user.ID, float64(req.SendBody.Amount))
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您在果实放大器输了"+fmt.Sprintf("%.2f", float64(req.SendBody.Amount))+"ISPAY",
				"You've lost "+fmt.Sprintf("%.2f", float64(req.SendBody.Amount))+" ISPAY from game",
			)
			if nil != err {
				return err
			}
			return nil
		}); nil != err {
			return &pb.StakeGetPlayReply{
				Status: "ispay余额不足",
			}, nil
		}

		return &pb.StakeGetPlayReply{Status: "ok", PlayStatus: 2}, nil
	}
}

func (ac *AppUsecase) SetGiw(ctx context.Context, req *pb.SetGiwRequest) (*pb.SetGiwReply, error) {
	return &pb.SetGiwReply{Status: "ok"}, ac.userRepo.SetGiw(ctx, req.Address, req.Giw)
}

func (ac *AppUsecase) SetGit(ctx context.Context, req *pb.SetGitRequest) (*pb.SetGitReply, error) {
	return &pb.SetGitReply{Status: "ok"}, ac.userRepo.SetGit(ctx, req.Address, req.Git)
}

var toAmount sync.Mutex

func (ac *AppUsecase) ToAmount(ctx context.Context, address string, req *pb.ToAmountRequest) (*pb.ToAmountReply, error) {
	var (
		user    *User
		userTwo *User
		err     error
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.ToAmountReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.ToAmountReply{
			Status: "锁定用户",
		}, nil
	}

	userTwo, err = ac.userRepo.GetUserByAddress(ctx, req.SendBody.Address) // 查询用户
	if nil != err || nil == userTwo {
		return &pb.ToAmountReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == userTwo.LockUse {
		return &pb.ToAmountReply{
			Status: "锁定用户",
		}, nil
	}

	if req.SendBody.Amount > uint64(user.AmountUsdt) {
		return &pb.ToAmountReply{
			Status: "usdt余额不足",
		}, nil
	}

	toAmount.Lock()
	defer toAmount.Unlock()

	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		err = ac.userRepo.Transfer(ctx, user.ID, userTwo.ID, float64(req.SendBody.Amount))
		if nil != err {
			return err
		}

		err = ac.userRepo.CreateNotice(
			ctx,
			user.ID,
			"转账"+fmt.Sprintf("%.2f", float64(req.SendBody.Amount))+" USDT 到 "+req.SendBody.Address,
			"transfer "+fmt.Sprintf("%.2f", float64(req.SendBody.Amount))+" USDT to "+req.SendBody.Address,
		)
		if nil != err {
			return err
		}
		return nil
	}); nil != err {
		return &pb.ToAmountReply{
			Status: "转账错误",
		}, nil
	}

	return &pb.ToAmountReply{
		Status: "ok",
	}, nil
}

func (ac *AppUsecase) Exchange(ctx context.Context, address string, req *pb.ExchangeRequest) (*pb.ExchangeReply, error) {
	return &pb.ExchangeReply{
		Status: "ok",
	}, nil

	//var (
	//	user *User
	//	err  error
	//)
	//
	//user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	//if nil != err || nil == user {
	//	return &pb.ExchangeReply{
	//		Status: "不存在用户",
	//	}, nil
	//}
	//
	//if 1 == user.LockUse {
	//	return &pb.ExchangeReply{
	//		Status: "锁定用户",
	//	}, nil
	//}
	//
	//if req.SendBody.Amount > uint64(user.AmountUsdt) {
	//	return &pb.ExchangeReply{
	//		Status: "usdt余额不足",
	//	}, nil
	//}
	//
	//var (
	//	configs            []*Config
	//	exchangeThree      uint64
	//	exchangeMaxThree   float64
	//	exchangeMinThree   float64
	//	exchangeThreeRate  float64
	//	exchangePrice      float64
	//	exchangePriceOpen  uint64
	//	exchangePriceStake float64
	//)
	//
	//// 配置
	//configs, err = ac.userRepo.GetConfigByKeys(ctx,
	//	"exchange_fee_rate",
	//	"exchange_fee_rate_two",
	//	"exchange_fee_rate_three",
	//	"b_price",
	//	"u_price",
	//	"exchange_three",
	//	"exchange_max_three",
	//	"exchange_min_three",
	//	"exchange_three_rate",
	//	"exchange_price",
	//	"exchange_price_open",
	//	"exchange_stake_rate",
	//)
	//if nil != err || nil == configs {
	//	return &pb.ExchangeReply{
	//		Status: "配置错误",
	//	}, nil
	//}
	//for _, vConfig := range configs {
	//	if "exchange_three" == vConfig.KeyName {
	//		exchangeThree, _ = strconv.ParseUint(vConfig.Value, 10, 64)
	//	}
	//	if "exchange_max_three" == vConfig.KeyName {
	//		exchangeMaxThree, _ = strconv.ParseFloat(vConfig.Value, 10)
	//	}
	//	if "exchange_min_three" == vConfig.KeyName {
	//		exchangeMinThree, _ = strconv.ParseFloat(vConfig.Value, 10)
	//	}
	//	if "exchange_three_rate" == vConfig.KeyName {
	//		exchangeThreeRate, _ = strconv.ParseFloat(vConfig.Value, 10)
	//	}
	//
	//	if "exchange_price" == vConfig.KeyName {
	//		exchangePrice, _ = strconv.ParseFloat(vConfig.Value, 10)
	//	}
	//
	//	if "exchange_price_open" == vConfig.KeyName {
	//		exchangePriceOpen, _ = strconv.ParseUint(vConfig.Value, 10, 64)
	//	}
	//
	//	if "exchange_stake_rate" == vConfig.KeyName {
	//		exchangePriceStake, _ = strconv.ParseFloat(vConfig.Value, 10)
	//	}
	//
	//	//if "u_price" == vConfig.KeyName {
	//	//	uPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
	//	//}
	//}
	//
	//if 0 == exchangePriceOpen {
	//	if 0.000000001 > exchangePrice {
	//		return &pb.ExchangeReply{
	//			Status: "价格查询错误，请稍后~",
	//		}, nil
	//	}
	//}
	//
	//if 1 != exchangeThree {
	//	return &pb.ExchangeReply{
	//		Status: "暂未开放",
	//	}, nil
	//}
	//
	//if exchangeMaxThree < float64(req.SendBody.Amount) {
	//	return &pb.ExchangeReply{
	//		Status: "大于最大值",
	//	}, nil
	//}
	//
	//if exchangeMinThree > float64(req.SendBody.Amount) {
	//	return &pb.ExchangeReply{
	//		Status: "低于最小值",
	//	}, nil
	//}
	//
	//var (
	//	withdrawList []*Exchange
	//)
	//
	//withdrawList, err = ac.userRepo.GetExchangeTodayRecordsByUserID(ctx, user.ID)
	//if err != nil {
	//	return &pb.ExchangeReply{
	//		Status: "查询错误",
	//	}, nil
	//}
	//
	//if 0 != len(withdrawList) {
	//	return &pb.ExchangeReply{
	//		Status: "每24小时可兑换1次",
	//	}, nil
	//}
	//
	//if user.OpenBoxAmount*exchangePriceStake < float64(req.SendBody.Amount) {
	//	return &pb.ExchangeReply{
	//		Status: "stake ispay not enough|质押ispay额度太少",
	//	}, nil
	//}
	//
	//var ispay float64
	//usdtAmount := float64(req.SendBody.Amount) - float64(req.SendBody.Amount)*exchangeThreeRate
	//if 0 == exchangePriceOpen {
	//	ispay = usdtAmount * exchangePrice
	//} else {
	//	var (
	//		tmp0 float64
	//		tmp1 float64
	//	)
	//	tmp0, tmp1, err = GetReservers()
	//	if nil != err || 1 >= tmp0 || 1 >= tmp1 {
	//		return &pb.ExchangeReply{
	//			Status: "获取交易池数据失败",
	//		}, nil
	//	}
	//
	//	ispay = usdtAmount * tmp1 / tmp0
	//}
	//
	//if 0 >= ispay {
	//	return &pb.ExchangeReply{
	//		Status: "配置错误",
	//	}, nil
	//}
	//
	//if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
	//	err = ac.userRepo.ExchangeNew(ctx, user.ID, usdtAmount, ispay, float64(req.SendBody.Amount))
	//	if nil != err {
	//		return err
	//	}
	//
	//	err = ac.userRepo.CreateNotice(
	//		ctx,
	//		user.ID,
	//		"兑换"+fmt.Sprintf("%.2f", float64(req.SendBody.Amount))+" USDT 获得 "+strconv.FormatFloat(ispay, 'f', -1, 64)+" ISPAY",
	//		"exchange "+fmt.Sprintf("%.2f", float64(req.SendBody.Amount))+" USDT for "+strconv.FormatFloat(ispay, 'f', -1, 64)+" ISPAY",
	//	)
	//	if nil != err {
	//		return err
	//	}
	//	return nil
	//}); nil != err {
	//	return &pb.ExchangeReply{
	//		Status: "兑换错误",
	//	}, nil
	//}
	//
	//return &pb.ExchangeReply{
	//	Status: "ok",
	//}, nil
}

type SymbolThumb struct {
	Symbol  string  `json:"symbol"`
	Close   float64 `json:"close"`
	UsdRate float64 `json:"usdRate"`
}

// GetIspayPrice 获取 ISPAY 当前 U 价格
func GetIspayPrice() (float64, error) {
	url := "https://ex.ispay.vip/market/symbol-thumb"

	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		return 0, err
	}

	req.Header.Set("Accept", "application/json")
	req.Header.Set("User-Agent", "Mozilla/5.0")

	resp, err := client.Do(req)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return 0, fmt.Errorf("request failed, status: %d", resp.StatusCode)
	}

	var list []SymbolThumb
	if err := json.NewDecoder(resp.Body).Decode(&list); err != nil {
		return 0, err
	}

	for _, item := range list {
		if strings.EqualFold(item.Symbol, "ISPAY/USDT") {
			// 优先返回 usdRate，它表示折合 U / USD 的价格
			if item.UsdRate > 0 {
				return item.UsdRate, nil
			}

			// 兜底返回 close
			if item.Close > 0 {
				return item.Close, nil
			}

			return 0, fmt.Errorf("ISPAY/USDT price is zero")
		}
	}

	return 0, fmt.Errorf("ISPAY/USDT not found")
}

func GetReservers() (float64, float64, error) {
	urls := []string{
		"https://bsc-dataseed4.binance.org/",
		"https://binance.llamarpc.com/",
		"https://bscrpc.com/",
		"https://bsc-pokt.nodies.app/",
		"https://data-seed-prebsc-1-s3.binance.org:8545/",
	}

	var (
		tmp0 float64
		tmp1 float64
	)

	for _, urlTmp := range urls {
		client, err := ethclient.Dial(urlTmp)
		if err != nil {
			fmt.Println("client error:", err)
			continue
		}

		contractAddress := "0x3c987dA0C102f5E7e9a3282568e41a90f7ceD424"

		tokenAddress := common.HexToAddress(contractAddress)
		instance, err := NewPair(tokenAddress, client)
		if err != nil {
			fmt.Println("GetBoxNew error:", err)
			continue
		}

		// 获取认购盲盒记录
		tmp, errOne := instance.GetReserves(&bind.CallOpts{})
		if errOne != nil {
			continue
		}

		tmp0, _ = tmp.Reserve0.Float64()
		tmp1, _ = tmp.Reserve1.Float64()
		break
	}

	return tmp0, tmp1, nil
}

var buyTwo sync.Mutex

func (ac *AppUsecase) BuyTwo(ctx context.Context, address string, req *pb.BuyTwoRequest) (*pb.BuyTwoReply, error) {
	var (
		user      *User
		configs   []*Config
		err       error
		recommend float64
		uPrice    float64
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.BuyTwoReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.BuyTwoReply{
			Status: "锁定用户",
		}, nil
	}

	buyTwo.Lock()
	defer buyTwo.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.BuyTwoReply{
			Status: "不存在用户",
		}, nil
	}

	if 0 < user.Amount {
		return &pb.BuyTwoReply{
			Status: "已认购",
		}, nil
	}

	// 推荐
	var (
		userRecommend       *UserRecommend
		tmpRecommendUserIds []string
	)
	userRecommend, err = ac.userRepo.GetUserRecommendByUserId(ctx, user.ID)
	if nil == userRecommend || nil != err {
		return &pb.BuyTwoReply{
			Status: "上级查询错误",
		}, nil
	}
	if "" != userRecommend.RecommendCode {
		tmpRecommendUserIds = strings.Split(userRecommend.RecommendCode, "D")
	}

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"u_price",
		"recommend",
	)
	if nil != err || nil == configs {
		return &pb.BuyTwoReply{
			Status: "配置错误",
		}, nil
	}
	for _, vConfig := range configs {
		if "recommend" == vConfig.KeyName {
			recommend, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "u_price" == vConfig.KeyName {
			uPrice, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
	}

	tmpU := float64(0)
	tmpB := float64(0)
	amount := float64(0)
	if 100 == req.SendBody.Amount {
		tmpU = 50
		tmpB = 50 / uPrice
		amount = 100
	} else if 300 == req.SendBody.Amount {
		tmpU = 150
		tmpB = 150 / uPrice
		amount = 300
	} else if 500 == req.SendBody.Amount {
		tmpU = 250
		tmpB = 250 / uPrice
		amount = 500
	} else if 1000 == req.SendBody.Amount {
		tmpU = 500
		tmpB = 500 / uPrice
		amount = 1000
	} else if 5000 == req.SendBody.Amount {
		tmpU = 2500
		tmpB = 2500 / uPrice
		amount = 5000
	} else if 10000 == req.SendBody.Amount {
		tmpU = 5000
		tmpB = 5000 / uPrice
		amount = 10000
	} else if 15000 == req.SendBody.Amount {
		tmpU = 7500
		tmpB = 7500 / uPrice
		amount = 15000
	} else if 30000 == req.SendBody.Amount {
		tmpU = 15000
		tmpB = 15000 / uPrice
		amount = 30000
	} else {
		return &pb.BuyTwoReply{
			Status: "金额错误",
		}, nil
	}

	if tmpU > user.AmountUsdt {
		return &pb.BuyTwoReply{
			Status: "usdt余额不足",
		}, nil
	}

	if tmpB > user.GiwTwo {
		return &pb.BuyTwoReply{
			Status: "充值biw余额不足",
		}, nil
	}

	var (
		userRecommends    []*UserRecommend
		userRecommendsMap map[uint64]*UserRecommend
	)
	userRecommends, err = ac.userRepo.GetUserRecommends(ctx)
	if nil != err {
		return &pb.BuyTwoReply{
			Status: "错误",
		}, nil
	}

	myLowUser := make(map[uint64][]*UserRecommend, 0)
	userRecommendsMap = make(map[uint64]*UserRecommend, 0)
	for _, vUr := range userRecommends {
		userRecommendsMap[vUr.UserId] = vUr

		// 我的直推
		var (
			myUserRecommendUserId  uint64
			tmpRecommendUserIdsTmp []string
		)

		tmpRecommendUserIdsTmp = strings.Split(vUr.RecommendCode, "D")
		if 2 <= len(tmpRecommendUserIdsTmp) {
			myUserRecommendUserId, _ = strconv.ParseUint(tmpRecommendUserIdsTmp[len(tmpRecommendUserIdsTmp)-1], 10, 64) // 最后一位是直推人
		}

		if 0 >= myUserRecommendUserId {
			continue
		}

		if _, ok := myLowUser[myUserRecommendUserId]; !ok {
			myLowUser[myUserRecommendUserId] = make([]*UserRecommend, 0)
		}

		myLowUser[myUserRecommendUserId] = append(myLowUser[myUserRecommendUserId], vUr)
	}

	var (
		users    []*User
		usersMap map[uint64]*User
	)
	users, err = ac.userRepo.GetAllUsers(ctx)
	if nil == users {
		return &pb.BuyTwoReply{
			Status: "错误",
		}, nil
	}

	usersMap = make(map[uint64]*User, 0)
	for _, vUsers := range users {
		usersMap[vUsers.ID] = vUsers
	}

	if 0 < len(tmpRecommendUserIds) {
		tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIds[0], 10, 64) // 最后一位是直推人
		if 0 < tmpUserId {
			if _, ok := usersMap[tmpUserId]; ok {
				if 0 >= usersMap[tmpUserId].Amount && 0 >= usersMap[tmpUserId].OutNum {
					return &pb.BuyTwoReply{
						Status: "上级未激活",
					}, nil
				}
			}
		}
	}

	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		err = ac.userRepo.UpdateUserNewTwoNew(ctx, user.ID, amount, tmpB, uint64(tmpU))
		if nil != err {
			return err
		}

		//err = ac.userRepo.CreateNotice(
		//	ctx,
		//	user.ID,
		//	"认购金额"+fmt.Sprintf("%.2f", float64(req.SendBody.Amount))+"U",
		//	"You've pay "+fmt.Sprintf("%.2f", float64(req.SendBody.Amount))+" U",
		//)
		//if nil != err {
		//	return err
		//}

		return nil
	}); nil != err {
		return &pb.BuyTwoReply{
			Status: "认购错误",
		}, nil
	}

	if 0 >= len(tmpRecommendUserIds) {
		return &pb.BuyTwoReply{
			Status: "ok",
		}, nil
	}

	totalTmp := len(tmpRecommendUserIds) - 1
	for i := totalTmp; i >= 0; i-- {

		tmpUserId, _ := strconv.ParseUint(tmpRecommendUserIds[i], 10, 64) // 最后一位是直推人
		if 0 >= tmpUserId {
			continue
		}

		if _, ok := usersMap[tmpUserId]; !ok {
			fmt.Println("buy遍历，信息缺失,user：", err, tmpUserId, user)
			continue
		}

		// 增加业绩
		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.UpdateUserMyTotalAmount(ctx, tmpUserId, amount)
			if err != nil {
				return err
			}

			return nil
		}); nil != err {
			fmt.Println("遍历业绩：", err, tmpUserId, user)
			continue
		}

		if 1 == user.LockReward {
			continue
		}

		tmpRecommendUser := usersMap[tmpUserId]
		if i == totalTmp {
			// 入金
			if 0 < tmpRecommendUser.Amount {
				var (
					num float64
				)
				num = 2.5

				amountRecommendTmp := amount * recommend
				var (
					stopRecommend bool
				)

				tmpMaxB := tmpRecommendUser.Amount * num / uPrice
				tmpCurrentB := amountRecommendTmp / uPrice

				if tmpRecommendUser.AmountGet >= tmpMaxB {
					tmpCurrentB = 0
					stopRecommend = true
				} else if tmpCurrentB+tmpRecommendUser.AmountGet >= tmpMaxB {
					tmpCurrentB = math.Abs(tmpMaxB - tmpRecommendUser.AmountGet)
					stopRecommend = true
				}

				amountRecommendTmp = math.Round(amountRecommendTmp*10000000) / 10000000
				tmpCurrentB = math.Round(tmpCurrentB*10000000) / 10000000

				amountRecommendTmp2 := amountRecommendTmp * 0.1
				amountRecommendTmp2 = math.Round(amountRecommendTmp2*10000000) / 10000000

				amountRecommendTmpBiw := tmpCurrentB * 0.9
				amountRecommendTmpBiw = math.Round(amountRecommendTmpBiw*10000000) / 10000000

				fmt.Println("直推奖奖励：", amount, uPrice, recommend, amountRecommendTmp, tmpCurrentB, amountRecommendTmp2, amountRecommendTmpBiw, user, tmpRecommendUser)

				if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
					err = ac.userRepo.UpdateUserRewardRecommend2(ctx, tmpUserId, amountRecommendTmpBiw, amountRecommendTmp2, tmpCurrentB, tmpRecommendUser.Amount, stopRecommend, user.Address)
					if err != nil {
						fmt.Println("错误分红直推：", err)
					}

					return nil
				}); nil != err {
					fmt.Println("err reward recommend", err, amount, amountRecommendTmp, tmpCurrentB, user, tmpRecommendUser)
				}

				if stopRecommend {
					// 推荐人
					var (
						userRecommendArea *UserRecommend
					)
					if _, ok := userRecommendsMap[tmpRecommendUser.ID]; ok {
						userRecommendArea = userRecommendsMap[tmpRecommendUser.ID]
					} else {
						fmt.Println("错误分红业绩变更，信息缺失7：", err, amount, amountRecommendTmp, tmpCurrentB, user, tmpRecommendUser)
						continue
					}

					if nil != userRecommendArea && "" != userRecommendArea.RecommendCode {
						var tmpRecommendAreaUserIds []string
						tmpRecommendAreaUserIds = strings.Split(userRecommendArea.RecommendCode, "D")

						for j := len(tmpRecommendAreaUserIds) - 1; j >= 0; j-- {
							if 0 >= len(tmpRecommendAreaUserIds[j]) {
								continue
							}

							myUserRecommendAreaUserId, _ := strconv.ParseInt(tmpRecommendAreaUserIds[j], 10, 64) // 最后一位是直推人
							if 0 >= myUserRecommendAreaUserId {
								continue
							}
							if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { //
								// 减掉业绩
								err = ac.userRepo.UpdateUserMyTotalAmountSub(ctx, myUserRecommendAreaUserId, tmpRecommendUser.Amount)
								if err != nil {
									fmt.Println("错误分红社区：", err, amount, amountRecommendTmp, tmpCurrentB, user, tmpRecommendUser)
								}

								return nil
							}); nil != err {
								fmt.Println("err reward recommend 2", err, amount, amountRecommendTmp, tmpCurrentB, user, tmpRecommendUser)
							}
						}
					}

				}
			}
		}
	}

	return &pb.BuyTwoReply{
		Status: "ok",
	}, nil
}

func (ac *AppUsecase) Withdraw(ctx context.Context, address string, req *pb.WithdrawRequest) (*pb.WithdrawReply, error) {
	var (
		user              *User
		configs           []*Config
		err               error
		withdrawMinThree  float64
		withdrawMaxThree  float64
		withdrawMinTwo    float64
		withdrawMaxTwo    float64
		withdrawRateThree float64
		withdrawRateTwo   float64
		//exchangePriceStake float64
		canWithdraw uint64
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, address) // 查询用户
	if nil != err || nil == user {
		return &pb.WithdrawReply{
			Status: "不存在用户",
		}, nil
	}

	if 1 == user.LockUse {
		return &pb.WithdrawReply{
			Status: "锁定用户",
		}, nil
	}

	// 配置
	configs, err = ac.userRepo.GetConfigByKeys(ctx,
		"withdraw_amount_min",
		"withdraw_amount_max",
		"withdraw_amount_min_two",
		"withdraw_amount_max_two",
		"withdraw_rate",
		"withdraw_rate_two",
		"can_withdraw",
		"withdraw_amount_min_three",
		"withdraw_amount_max_three",
		"withdraw_rate_three",
		"exchange_stake_rate",
	)
	if nil != err || nil == configs {
		return &pb.WithdrawReply{
			Status: "配置错误",
		}, nil
	}
	for _, vConfig := range configs {
		if "can_withdraw" == vConfig.KeyName {
			canWithdraw, _ = strconv.ParseUint(vConfig.Value, 10, 64)
		}

		if "withdraw_amount_min_three" == vConfig.KeyName {
			withdrawMinThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "withdraw_amount_max_three" == vConfig.KeyName {
			withdrawMaxThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "withdraw_amount_min_two" == vConfig.KeyName {
			withdrawMinTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		}
		if "withdraw_amount_max_two" == vConfig.KeyName {
			withdrawMaxTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "withdraw_rate_two" == vConfig.KeyName {
			withdrawRateTwo, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		if "withdraw_rate_three" == vConfig.KeyName {
			withdrawRateThree, _ = strconv.ParseFloat(vConfig.Value, 10)
		}

		//if "exchange_stake_rate" == vConfig.KeyName {
		//	exchangePriceStake, _ = strconv.ParseFloat(vConfig.Value, 10)
		//}
	}

	if 1 != canWithdraw {
		return &pb.WithdrawReply{
			Status: "升级维护中~",
		}, nil
	}

	if 4 == req.SendBody.WithdrawType {
		var (
			withdrawList []*Withdraw
		)

		withdrawList, err = ac.userRepo.GetWithdrawTodayRecordsByUserID(ctx, user.ID, "usdt")
		if err != nil {
			return &pb.WithdrawReply{
				Status: "查询错误",
			}, nil
		}

		if 0 != len(withdrawList) {
			return &pb.WithdrawReply{
				Status: "24 hours limit|每24小时可提现1次",
			}, nil
		}

		var (
			stakeGitRecord    []*StakeGitRecord
			tmpTotalAmountTwo float64
		)
		stakeGitRecord, err = ac.userRepo.GetStakeGitRecordsByUserID(ctx, user.ID, nil)
		if nil != err {
			return &pb.WithdrawReply{
				Status: "粮仓错误查询",
			}, nil
		}

		for _, v := range stakeGitRecord {
			if v.CreatedAt.Before(time.Now().Add(-time.Duration(v.Day) * 24 * time.Hour)) {
				continue
			}

			tmpTotalAmountTwo += v.AmountTwo
		}

		if tmpTotalAmountTwo < req.SendBody.Amount {
			return &pb.WithdrawReply{
				Status: "stake ispay not enough, usdt limit:" + strconv.FormatFloat(tmpTotalAmountTwo, 'f', -1, 64) + " | 质押ispay额度太少，usdt额度：" + strconv.FormatFloat(tmpTotalAmountTwo, 'f', -1, 64),
			}, nil
		}

		if withdrawMaxTwo < req.SendBody.Amount {
			return &pb.WithdrawReply{
				Status: "大于最大值",
			}, nil
		}

		if withdrawMinTwo > req.SendBody.Amount {
			return &pb.WithdrawReply{
				Status: "低于最小值",
			}, nil
		}

		if req.SendBody.Amount > user.AmountUsdt {
			return &pb.WithdrawReply{
				Status: "可提USDT余额不足",
			}, nil
		}

		if 0 >= withdrawRateTwo {
			return &pb.WithdrawReply{
				Status: "手续费错误",
			}, nil
		}

		tmpAmount := req.SendBody.Amount - req.SendBody.Amount*withdrawRateTwo
		if 0 >= tmpAmount {
			return &pb.WithdrawReply{
				Status: "手续费错误",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.WithdrawTwo(ctx, user.ID, req.SendBody.Amount, tmpAmount)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"提现金额"+fmt.Sprintf("%.2f", req.SendBody.Amount)+"USDT",
				"You've withdraw "+fmt.Sprintf("%.2f", req.SendBody.Amount)+" USDT",
			)
			if nil != err {
				return err
			}
			return nil
		}); nil != err {
			return &pb.WithdrawReply{
				Status: "提现错误",
			}, nil
		}
	} else {
		var (
			withdrawList []*Withdraw
		)

		withdrawList, err = ac.userRepo.GetWithdrawTodayRecordsByUserID(ctx, user.ID, "ispay_new")
		if err != nil {
			return &pb.WithdrawReply{
				Status: "查询错误",
			}, nil
		}

		if 0 != len(withdrawList) {
			return &pb.WithdrawReply{
				Status: "每24小时可提现1次|24 hours limit",
			}, nil
		}

		if withdrawMaxThree < req.SendBody.Amount {
			return &pb.WithdrawReply{
				Status: "大于最大值",
			}, nil
		}

		if withdrawMinThree > req.SendBody.Amount {
			return &pb.WithdrawReply{
				Status: "低于最小值",
			}, nil
		}

		if req.SendBody.Amount > user.GitNewNew {
			return &pb.WithdrawReply{
				Status: "ispay balance could withdraw:" + strconv.FormatFloat(user.GitNewNew, 'f', -1, 64) + " | 可提ISPAY余额不足，当前余额:" + strconv.FormatFloat(user.GitNewNew, 'f', -1, 64),
			}, nil
		}

		if 0 >= withdrawRateThree {
			return &pb.WithdrawReply{
				Status: "手续费错误",
			}, nil
		}

		tmpAmount := req.SendBody.Amount - req.SendBody.Amount*withdrawRateThree
		if 0 >= tmpAmount {
			return &pb.WithdrawReply{
				Status: "手续费错误",
			}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.WithdrawThree(ctx, user.ID, req.SendBody.Amount, tmpAmount)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"提现金额"+fmt.Sprintf("%.2f", req.SendBody.Amount)+"ISPAY",
				"You've withdraw "+fmt.Sprintf("%.2f", req.SendBody.Amount)+" ISPAY",
			)
			if nil != err {
				return err
			}
			return nil
		}); nil != err {
			return &pb.WithdrawReply{
				Status: "提现错误",
			}, nil
		}

	}
	return &pb.WithdrawReply{
		Status: "ok",
	}, nil
}

func (ac *AppUsecase) SetLand(ctx context.Context, req *pb.SetLandRequest) (*pb.SetLandReply, error) {
	return nil, nil
	var (
		user *User
		err  error

		landInfos map[uint64]*LandInfo
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, req.Address)
	if nil != err {
		return &pb.SetLandReply{Status: "地址不存在用户"}, nil
	}

	if nil == user {
		return &pb.SetLandReply{Status: "地址不存在用户"}, nil
	}

	landInfos, err = ac.userRepo.GetLandInfoByLevels(ctx)
	if nil != err {
		return &pb.SetLandReply{
			Status: "信息错误",
		}, nil
	}

	if 0 >= len(landInfos) {
		return &pb.SetLandReply{
			Status: "配置信息错误",
		}, nil
	}

	tmpLevel := req.Level
	if _, ok := landInfos[tmpLevel]; !ok {
		return &pb.SetLandReply{
			Status: "级别错误",
		}, nil
	}

	rngTmp := rand2.New(rand2.NewSource(time.Now().UnixNano()))
	outMin := int64(landInfos[tmpLevel].OutPutRateMin)
	outMax := int64(landInfos[tmpLevel].OutPutRateMax)

	// 计算随机范围
	tmpNum := outMax - outMin
	if tmpNum <= 0 {
		tmpNum = 1 // 避免 Int63n(0) panic
	}

	// 生成随机数
	randomNumber := outMin + rngTmp.Int63n(tmpNum)

	now := time.Now().Unix()
	if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
		_, err = ac.userRepo.CreateLand(ctx, &Land{
			UserId:     user.ID,
			Level:      landInfos[tmpLevel].Level,
			OutPutRate: float64(randomNumber),
			MaxHealth:  landInfos[tmpLevel].MaxHealth,
			PerHealth:  landInfos[tmpLevel].PerHealth,
			LimitDate:  uint64(now) + landInfos[tmpLevel].LimitDateMax*3600*24,
			Status:     0,
			One:        1,
			Two:        1,
			Three:      1,
		})
		if nil != err {
			return err
		}

		return nil
	}); nil != err {
		fmt.Println(err, "setLand", user)
		return &pb.SetLandReply{
			Status: "发放失败",
		}, nil
	}

	return &pb.SetLandReply{
		Status: "ok",
	}, nil
}

func (ac *AppUsecase) GetBuyLand(ctx context.Context, addreses string, req *pb.GetBuyLandRequest) (*pb.GetBuyLandReply, error) {
	var (
		user          *User
		err           error
		landBuy       *BuyLand
		landRecord    []*BuyLandRecord
		newLandRecord *BuyLandRecord
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, addreses)
	if nil != err {
		return &pb.GetBuyLandReply{Status: "地址不存在用户"}, nil
	}
	if nil == user {
		return &pb.GetBuyLandReply{Status: "地址不存在用户"}, nil
	}

	landBuy, err = ac.userRepo.GetBuyLandById(ctx)
	if nil != err {
		return &pb.GetBuyLandReply{Status: "不存在拍卖信息"}, nil
	}

	now := time.Now().Unix()
	if nil == landBuy || uint64(now) >= landBuy.Limit {
		return &pb.GetBuyLandReply{
			Status:    "ok",
			Amount:    0,
			AmountOne: 0,
			Limit:     uint64(now),
		}, nil
	}

	landRecord, err = ac.userRepo.GetAllBuyLandRecords(ctx, landBuy.ID)
	if nil != err {
		return &pb.GetBuyLandReply{Status: "记录错误"}, nil
	}

	if 1 <= len(landRecord) {
		newLandRecord = landRecord[0]
		return &pb.GetBuyLandReply{
			Status:    "ok",
			Amount:    newLandRecord.Amount,
			AmountOne: landBuy.AmountTwo,
			Limit:     landBuy.Limit,
			Level:     landBuy.Level,
			Now:       uint64(now),
		}, nil
	} else {
		return &pb.GetBuyLandReply{
			Status:    "ok",
			Amount:    landBuy.Amount,
			AmountOne: landBuy.AmountTwo,
			Limit:     landBuy.Limit,
			Level:     landBuy.Level,
			Now:       uint64(now),
		}, nil
	}
}

func (ac *AppUsecase) SetBuyLand(ctx context.Context, req *pb.SetBuyLandRequest) (*pb.SetBuyLandReply, error) {
	var (
		err        error
		landBuy    *BuyLand
		landRecord []*BuyLandRecord
		landInfos  map[uint64]*LandInfo
	)

	landBuy, err = ac.userRepo.GetSetBuyLandById(ctx)
	if nil != err {
		return &pb.SetBuyLandReply{}, nil
	}

	now := time.Now().Unix()
	if nil == landBuy {
		return &pb.SetBuyLandReply{}, nil
	}

	if 3 == landBuy.Status {
		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.SetBuyLandOver(ctx, landBuy.ID)
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			return &pb.SetBuyLandReply{}, nil
		}

		landRecord, err = ac.userRepo.GetAllBuyLandRecords(ctx, landBuy.ID)
		if nil != err {
			return &pb.SetBuyLandReply{}, nil
		}

		userIdTmp := uint64(0)
		tmpAmount := float64(0)
		for _, v := range landRecord {
			if 3 == v.Status {
				userIdTmp = v.UserID
				tmpAmount = v.Amount
				continue
			}

			if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
				err = ac.userRepo.BackUserGit(ctx, v.UserID, v.ID, v.Amount)
				if nil != err {
					return err
				}

				err = ac.userRepo.CreateNotice(
					ctx,
					v.UserID,
					"未竞拍到物品，退还"+fmt.Sprintf("%.2f", v.Amount)+"USDT",
					"You've get "+fmt.Sprintf("%.2f", v.Amount)+" USDT from auction",
				)
				if nil != err {
					return err
				}

				return nil
			}); nil != err {
				return &pb.SetBuyLandReply{}, nil
			}
		}

		if 0 == userIdTmp {
			return &pb.SetBuyLandReply{}, nil
		}

		landInfos, err = ac.userRepo.GetLandInfoByLevels(ctx)
		if nil != err {
			return &pb.SetBuyLandReply{}, nil
		}

		if 0 >= len(landInfos) {
			return &pb.SetBuyLandReply{}, nil
		}

		tmpLevel := landBuy.Level
		if _, ok := landInfos[tmpLevel]; !ok {
			return &pb.SetBuyLandReply{}, nil
		}

		rngTmp := rand2.New(rand2.NewSource(time.Now().UnixNano()))
		outMin := int64(landInfos[tmpLevel].OutPutRateMin)
		outMax := int64(landInfos[tmpLevel].OutPutRateMax)

		// 计算随机范围
		tmpNum := outMax - outMin
		if tmpNum <= 0 {
			tmpNum = 1 // 避免 Int63n(0) panic
		}

		// 生成随机数
		randomNumber := outMin + rngTmp.Int63n(tmpNum)

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			var (
				land *Land
			)
			land, err = ac.userRepo.CreateLand(ctx, &Land{
				UserId:     userIdTmp,
				Level:      landInfos[tmpLevel].Level,
				OutPutRate: float64(randomNumber),
				MaxHealth:  landInfos[tmpLevel].MaxHealth,
				PerHealth:  landInfos[tmpLevel].PerHealth,
				LimitDate:  uint64(now) + landInfos[tmpLevel].LimitDateMax*3600*24,
				Status:     0,
				One:        1,
				Two:        1,
				Three:      1,
			})
			if nil != err {
				return err
			}

			err = ac.userRepo.BuyLandReward(ctx, userIdTmp, land.ID, tmpAmount)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				userIdTmp,
				"您竞拍到物品，级别"+strconv.FormatUint(landInfos[tmpLevel].Level, 10),
				"You've get land level "+strconv.FormatUint(landInfos[tmpLevel].Level, 10),
			)
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			return &pb.SetBuyLandReply{}, nil
		}

	} else if 1 == landBuy.Status {
		if uint64(now) <= landBuy.Limit {
			return &pb.SetBuyLandReply{}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.SetBuyLandOver(ctx, landBuy.ID)
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			return &pb.SetBuyLandReply{}, nil
		}

		landRecord, err = ac.userRepo.GetAllBuyLandRecords(ctx, landBuy.ID)
		if nil != err {
			return &pb.SetBuyLandReply{}, nil
		}

		userIdTmp := uint64(0)
		tmpAmount := float64(0)
		for k, v := range landRecord {
			if 0 == k {
				userIdTmp = v.UserID
				tmpAmount = v.Amount
				continue
			}

			if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
				err = ac.userRepo.BackUserGit(ctx, v.UserID, v.ID, v.Amount)
				if nil != err {
					return err
				}

				err = ac.userRepo.CreateNotice(
					ctx,
					v.UserID,
					"未竞拍到物品，退还"+fmt.Sprintf("%.2f", v.Amount)+"USDT",
					"You've get "+fmt.Sprintf("%.2f", v.Amount)+" USDT from auction",
				)
				if nil != err {
					return err
				}

				return nil
			}); nil != err {
				return &pb.SetBuyLandReply{}, nil
			}
		}

		if 0 == userIdTmp {
			return &pb.SetBuyLandReply{}, nil
		}

		landInfos, err = ac.userRepo.GetLandInfoByLevels(ctx)
		if nil != err {
			return &pb.SetBuyLandReply{}, nil
		}

		if 0 >= len(landInfos) {
			return &pb.SetBuyLandReply{}, nil
		}

		tmpLevel := landBuy.Level
		if _, ok := landInfos[tmpLevel]; !ok {
			return &pb.SetBuyLandReply{}, nil
		}

		rngTmp := rand2.New(rand2.NewSource(time.Now().UnixNano()))
		outMin := int64(landInfos[tmpLevel].OutPutRateMin)
		outMax := int64(landInfos[tmpLevel].OutPutRateMax)

		// 计算随机范围
		tmpNum := outMax - outMin
		if tmpNum <= 0 {
			tmpNum = 1 // 避免 Int63n(0) panic
		}

		// 生成随机数
		randomNumber := outMin + rngTmp.Int63n(tmpNum)

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			var (
				land *Land
			)
			land, err = ac.userRepo.CreateLand(ctx, &Land{
				UserId:     userIdTmp,
				Level:      landInfos[tmpLevel].Level,
				OutPutRate: float64(randomNumber),
				MaxHealth:  landInfos[tmpLevel].MaxHealth,
				PerHealth:  landInfos[tmpLevel].PerHealth,
				LimitDate:  uint64(now) + landInfos[tmpLevel].LimitDateMax*3600*24,
				Status:     0,
				One:        1,
				Two:        1,
				Three:      1,
			})
			if nil != err {
				return err
			}

			err = ac.userRepo.BuyLandReward(ctx, userIdTmp, land.ID, tmpAmount)
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				userIdTmp,
				"您竞拍到物品，级别"+strconv.FormatUint(landInfos[tmpLevel].Level, 10),
				"You've get land level "+strconv.FormatUint(landInfos[tmpLevel].Level, 10),
			)
			if nil != err {
				return err
			}
			return nil
		}); nil != err {
			return &pb.SetBuyLandReply{}, nil
		}
	}

	return &pb.SetBuyLandReply{}, nil

}

func (ac *AppUsecase) BuyLandRecord(ctx context.Context, addreses string, req *pb.BuyLandRecordRequest) (*pb.BuyLandRecordReply, error) {
	var (
		user       *User
		err        error
		landBuy    *BuyLand
		landRecord []*BuyLandRecord
	)

	res := make([]*pb.BuyLandRecordReply_List, 0)
	user, err = ac.userRepo.GetUserByAddress(ctx, addreses)
	if nil != err {
		return &pb.BuyLandRecordReply{Status: "地址不存在用户"}, nil
	}
	if nil == user {
		return &pb.BuyLandRecordReply{Status: "地址不存在用户"}, nil
	}

	landBuy, err = ac.userRepo.GetBuyLandById(ctx)
	if nil != err {
		return &pb.BuyLandRecordReply{Status: "不存在拍卖信息"}, nil
	}

	now := time.Now().Unix()
	if nil == landBuy || uint64(now) >= landBuy.Limit {
		return &pb.BuyLandRecordReply{Status: "ok", List: res}, nil
	}

	landRecord, err = ac.userRepo.GetAllBuyLandRecords(ctx, landBuy.ID)
	if nil != err {
		return &pb.BuyLandRecordReply{Status: "记录错误"}, nil
	}

	if 0 == len(landRecord) {
		return &pb.BuyLandRecordReply{Status: "ok", List: res}, nil
	}

	userIds := make([]uint64, 0)
	for _, v := range landRecord {
		userIds = append(userIds, v.UserID)
	}

	var (
		usersMap map[uint64]*User
	)
	usersMap, err = ac.userRepo.GetUserByUserIds(ctx, userIds)
	if nil != err {
		return &pb.BuyLandRecordReply{Status: "不存在用户信息"}, nil
	}
	if 0 == len(usersMap) {
		return &pb.BuyLandRecordReply{Status: "ok", List: res}, nil
	}

	for _, v := range landRecord {
		address := ""
		if _, ok := usersMap[v.UserID]; ok {
			address = usersMap[v.UserID].Address
		}

		res = append(res, &pb.BuyLandRecordReply_List{
			Address:   address,
			Amount:    v.Amount,
			CreatedAt: v.CreatedAt.Add(8 * time.Hour).Format("2006-01-02 15:04:05"),
		})
	}

	return &pb.BuyLandRecordReply{Status: "ok", List: res}, nil
}

var BuyLandR sync.Mutex

func (ac *AppUsecase) BuyLand(ctx context.Context, addreses string, req *pb.BuyLandRequest) (*pb.BuyLandReply, error) {
	var (
		user          *User
		err           error
		landBuy       *BuyLand
		landRecord    []*BuyLandRecord
		newLandRecord *BuyLandRecord
	)

	user, err = ac.userRepo.GetUserByAddress(ctx, addreses)
	if nil != err {
		return &pb.BuyLandReply{Status: "地址不存在用户"}, nil
	}
	if nil == user {
		return &pb.BuyLandReply{Status: "地址不存在用户"}, nil
	}

	if 1 == user.LockUse {
		return &pb.BuyLandReply{
			Status: "锁定用户",
		}, nil
	}

	BuyLandR.Lock()
	defer BuyLandR.Unlock()

	user, err = ac.userRepo.GetUserByAddress(ctx, addreses)
	if nil != err {
		return &pb.BuyLandReply{Status: "地址不存在用户"}, nil
	}
	if nil == user {
		return &pb.BuyLandReply{Status: "地址不存在用户"}, nil
	}

	landBuy, err = ac.userRepo.GetBuyLandById(ctx)
	if nil != err {
		return &pb.BuyLandReply{Status: "不存在拍卖信息"}, nil
	}

	if nil == landBuy {
		return &pb.BuyLandReply{Status: "暂无拍卖信息"}, nil
	}

	now := time.Now().Unix()
	if uint64(now) >= landBuy.Limit {
		return &pb.BuyLandReply{Status: "拍卖结束"}, nil
	}

	landRecord, err = ac.userRepo.GetAllBuyLandRecords(ctx, landBuy.ID)
	if nil != err {
		return &pb.BuyLandReply{Status: "记录错误"}, nil
	}

	if 1 <= len(landRecord) {
		newLandRecord = landRecord[0]
	}

	if 1 == req.SendBody.BuyType {
		if 0 >= landBuy.AmountTwo {
			return &pb.BuyLandReply{Status: "未设定一口价"}, nil
		}

		amountTmp := landBuy.AmountTwo
		if nil != newLandRecord {
			if newLandRecord.Amount >= amountTmp {
				return &pb.BuyLandReply{Status: "当前最高价已经高于一口价"}, nil
			}
		}

		if user.AmountUsdt < amountTmp {
			return &pb.BuyLandReply{Status: "usdt余额不足"}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.CreateBuyLandRecordOne(ctx, &BuyLandRecord{
				BuyLandID: landBuy.ID,
				Amount:    float64(amountTmp),
				Status:    3,
				UserID:    user.ID,
			})
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您参与了拍卖土地，使用"+fmt.Sprintf("%.2f", amountTmp)+"USDT",
				"You've used "+fmt.Sprintf("%.2f", amountTmp)+" USDT to auction",
			)
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			return &pb.BuyLandReply{
				Status: "竞拍失败",
			}, nil
		}
	} else {
		amountTmp := req.SendBody.Amount

		if nil != newLandRecord {
			if newLandRecord.Amount >= float64(amountTmp) {
				return &pb.BuyLandReply{Status: "出价低于当前最高价"}, nil
			}
		} else {
			if landBuy.Amount >= float64(amountTmp) {
				return &pb.BuyLandReply{Status: "出价低于当前竞拍价"}, nil
			}
		}

		if uint64(user.AmountUsdt) < amountTmp {
			return &pb.BuyLandReply{Status: "ISPAY余额不足"}, nil
		}

		if err = ac.tx.ExecTx(ctx, func(ctx context.Context) error { // 事务
			err = ac.userRepo.CreateBuyLandRecord(ctx, uint64(now)+1200, &BuyLandRecord{
				BuyLandID: landBuy.ID,
				Amount:    float64(amountTmp),
				Status:    1,
				UserID:    user.ID,
			})
			if nil != err {
				return err
			}

			err = ac.userRepo.CreateNotice(
				ctx,
				user.ID,
				"您参与了拍卖土地，使用"+strconv.FormatUint(amountTmp, 10)+"USDT",
				"You've used "+strconv.FormatUint(amountTmp, 10)+" USDT to auction",
			)
			if nil != err {
				return err
			}

			return nil
		}); nil != err {
			return &pb.BuyLandReply{
				Status: "竞拍失败",
			}, nil
		}
	}

	return &pb.BuyLandReply{
		Status: "ok",
	}, nil
}

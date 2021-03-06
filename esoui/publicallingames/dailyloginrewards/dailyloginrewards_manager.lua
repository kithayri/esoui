--
--[[ DailyLoginRewards_Manager ]]--
--

local DailyLoginRewards_Manager = ZO_Object:Subclass()

function DailyLoginRewards_Manager:New(...)
    local manager = ZO_Object.New(self)
    manager:Initialize(...)
    return manager
end

function DailyLoginRewards_Manager:Initialize()
    EVENT_MANAGER:RegisterForEvent("DailyLoginRewardsManager", EVENT_SHOW_DAILY_LOGIN_REWARDS_SCENE, function() self:ShowDailyLoginRewardsScene() end)
end

function DailyLoginRewards_Manager:ShowDailyLoginRewardsScene()
    if IsInGamepadPreferredMode() then
        SYSTEMS:GetObject("mainMenu"):ShowDailyLoginRewardsEntry()
    else
        SYSTEMS:GetObject("mainMenu"):ShowSceneGroup("marketSceneGroup", "dailyLoginRewards")
    end
end

function DailyLoginRewards_Manager:GetDailyLoginRewardIndex()
	local dailyRewardIndex = GetDailyLoginClaimableRewardIndex()
    -- Daily reward has been claimed, get index for tomorrows reward if applicable
    if not dailyRewardIndex and self:IsClaimableRewardInMonth() then
        dailyRewardIndex = self:GetNextPotentialReward()
    end
	
	return dailyRewardIndex
end

function DailyLoginRewards_Manager:GetNextPotentialReward()
    local nextPotentialRewardIndex = GetDailyLoginNumRewardsClaimedInMonth() + 1
    if nextPotentialRewardIndex <= GetNumRewardsInCurrentDailyLoginMonth() then
        return nextPotentialRewardIndex
    end

    return nil
end

function DailyLoginRewards_Manager:IsClaimableRewardInMonth()
    return GetDailyLoginNumRewardsClaimedInMonth() < GetNumRewardsInCurrentDailyLoginMonth() and GetTimeUntilNextDailyLoginMonthS() > ZO_ONE_DAY_IN_SECONDS
end

ZO_DAILYLOGINREWARDS_MANAGER = DailyLoginRewards_Manager:New()
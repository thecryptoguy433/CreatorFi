import { describe, it, expect, beforeEach } from "vitest"

type Subscription = {
  owner: string
  tier: number
  expiresAt: number
}

const DURATION_BLOCKS = 52500

const mockContract = {
  admin: "ST1ADMIN",
  passCounter: 0,
  blockHeight: 100000,
  subscriptions: new Map<number, Subscription>(),
  userSubs: new Map<string, number>(),

  isAdmin(caller: string) {
    return caller === this.admin
  },

  mintPass(caller: string, recipient: string, tier: number) {
    if (!this.isAdmin(caller)) return { error: 100 }
    if (![1, 2, 3].includes(tier)) return { error: 101 }
    const newId = ++this.passCounter
    const expiresAt = this.blockHeight + DURATION_BLOCKS
    this.subscriptions.set(newId, { owner: recipient, tier, expiresAt })
    this.userSubs.set(recipient, newId)
    return { value: newId }
  },

  renewPass(caller: string) {
    const subId = this.userSubs.get(caller)
    if (!subId) return { error: 104 }
    const sub = this.subscriptions.get(subId)
    if (!sub) return { error: 104 }
    if (sub.owner !== caller) return { error: 102 }
    sub.expiresAt += DURATION_BLOCKS
    this.subscriptions.set(subId, sub)
    return { value: sub.expiresAt }
  },

  redeemBenefit(caller: string) {
    const subId = this.userSubs.get(caller)
    if (!subId) return { error: 104 }
    const sub = this.subscriptions.get(subId)
    if (!sub) return { error: 104 }
    if (sub.owner !== caller) return { error: 102 }
    if (sub.expiresAt <= this.blockHeight) return { error: 103 }
    return { value: { tier: sub.tier, expiresAt: sub.expiresAt } }
  },

  incrementBlock(height: number = 1) {
    this.blockHeight += height
  }
}

describe("Subscription Pass Contract", () => {
  beforeEach(() => {
    mockContract.passCounter = 0
    mockContract.blockHeight = 100000
    mockContract.subscriptions = new Map()
    mockContract.userSubs = new Map()
  })

  it("should allow admin to mint subscription", () => {
    const result = mockContract.mintPass("ST1ADMIN", "ST2USER", 2)
    expect(result).toEqual({ value: 1 })
    const sub = mockContract.subscriptions.get(1)
    expect(sub?.tier).toBe(2)
    expect(sub?.owner).toBe("ST2USER")
  })

  it("should reject non-admin minting", () => {
    const result = mockContract.mintPass("ST2USER", "ST2USER", 1)
    expect(result).toEqual({ error: 100 })
  })

  it("should reject invalid tier", () => {
    const result = mockContract.mintPass("ST1ADMIN", "ST2USER", 5)
    expect(result).toEqual({ error: 101 })
  })

  it("should allow renewal", () => {
    mockContract.mintPass("ST1ADMIN", "ST2USER", 1)
    const renew = mockContract.renewPass("ST2USER")
    expect(renew.value).toBeGreaterThan(100000 + DURATION_BLOCKS)
  })

  it("should not allow redemption if expired", () => {
    mockContract.mintPass("ST1ADMIN", "ST2USER", 3)
    mockContract.incrementBlock(DURATION_BLOCKS + 1)
    const result = mockContract.redeemBenefit("ST2USER")
    expect(result).toEqual({ error: 103 })
  })

  it("should allow redemption if active", () => {
    mockContract.mintPass("ST1ADMIN", "ST2USER", 1)
    const result = mockContract.redeemBenefit("ST2USER")
    expect(result.value.tier).toBe(1)
  })
})

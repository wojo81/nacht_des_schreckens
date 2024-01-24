class zmd_Drawing : zmd_Interactable {
    String weaponName;
    String upgradedWeaponName;

    int weaponCost;
    int ammoCost;
    const upgradedAmmoCost = 4500;

    String weaponMessage;
    String ammoMessage;
    String upgradedAmmoMessage;

    property weaponName: weaponName;
    property weaponCost: weaponCost;

    Default {
        +wallSprite;
        +noGravity;
    }

    override void beginPlay() {
        super.beginPlay();

        upgradedWeaponName = "Upgraded"..weaponName;

        ammoCost = weaponCost / 2;

        weaponMessage = zmd_Interactable.costOf(weaponCost);
        ammoMessage = zmd_Interactable.costOf(ammoCost);
        upgradedAmmoMessage = zmd_Interactable.costOf(upgradedAmmoCost);
    }

    override void doTouch(zmd_Player player) {
        if (player.countInv(weaponName)) {
            player.setMessage(ammoMessage);
        } else if (player.countInv(upgradedWeaponName)) {
            player.setMessage(upgradedAmmoMessage);
        } else {
            player.setMessage(weaponMessage);
        }
    }

    override bool doUse(zmd_Player player) {
        bool bought = false;
        if (player.countInv(weaponName)) {
            if (player.maybePurchase(ammoCost))
                bought = player.a_giveInventory(weaponName.."Ammo", 999);
        } else if (player.countInv(upgradedWeaponName)) {
            if (player.maybePurchase(upgradedAmmoCost))
                bought = player.a_giveInventory(upgradedWeaponName.."Ammo", 999);
        } else {
            if (player.maybePurchase(weaponCost))
                bought = player.a_giveInventory(weaponName);
        }

        if (bought) {
            player.a_startSound("game/purchase");
            return true;
        }
        return false;
    }
}

class MinigunDrawing : zmd_Drawing {
    Default {
        zmd_Drawing.weaponName "ZChaingun";
        zmd_Drawing.weaponCost 1200;
    }

    States {
    Spawn:
        mink a 1 bright;
        loop;
    }
}
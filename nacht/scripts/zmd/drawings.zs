class zmd_Drawing : zmd_Interactable {
    const upgradedAmmoCost = 4500;

    String weaponName;
    String upgradedWeaponName;

    int weaponCost;
    int ammoCost;

    String weaponMessage;
    String ammoMessage;
    String upgradedAmmoMessage;

    property weaponName: weaponName;
    property weaponCost: weaponCost;
    property ammoCost: weaponCost;

    Default {
        +wallSprite;
        +noGravity;
    }

    override void beginPlay() {
        super.beginPlay();

        // self.upgradedWeaponName = 'Upgraded'..self.weaponName;
        self.ammoCost = self.weaponCost / 2;

        self.weaponMessage = self.costOf(weaponCost);
        self.ammoMessage = self.costOf(ammoCost);
        self.upgradedAmmoMessage = self.costOf(upgradedAmmoCost);
    }

    override void doTouch(zmd_Player player) {
        if (player.countInv(self.weaponName))
            player.hintHud.setMessage(self.ammoMessage);
        else if (player.countInv(self.upgradedWeaponName))
            player.hintHud.setMessage(self.upgradedAmmoMessage);
        else
            player.hintHud.setMessage(self.weaponMessage);
    }

    override bool doUse(zmd_Player player) {
        bool bought = false;
        if (player.countInv(self.weaponName)) {
            if (player.purchase(ammoCost))
                bought = player.a_giveInventory(self.weaponName..'Ammo', 999);
        } else if (player.countInv(self.upgradedWeaponName)) {
            if (player.purchase(self.upgradedAmmoCost))
                bought = player.a_giveInventory(self.upgradedWeaponName..'Ammo', 999);
        } else {
            if (player.purchase(self.weaponCost))
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
        zmd_Drawing.weaponName "M1Garand";
        zmd_Drawing.weaponCost 1200;
    }

    States {
    Spawn:
        mink a 1 bright;
        loop;
    }
}
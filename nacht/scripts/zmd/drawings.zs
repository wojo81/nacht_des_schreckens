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

    override void doTouch(PlayerPawn player) {
        if (player.countInv(self.weaponName))
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage(self.ammoMessage);
        else if (player.countInv(self.upgradedWeaponName))
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage(self.upgradedAmmoMessage);
        else
            zmd_HintHud(player.findInventory('zmd_HintHud')).setMessage(self.weaponMessage);
    }

    override bool doUse(PlayerPawn player) {
        if (player.countInv(self.weaponName) && zmd_Points.takeFrom(player, ammoCost) && player.a_giveInventory(self.weaponName..'Ammo', 999))
            player.a_startSound("game/purchase");
        else if (player.countInv(self.upgradedWeaponName) && zmd_Points.takeFrom(player, self.upgradedAmmoCost) && player.a_giveInventory(self.upgradedWeaponName..'Ammo', 999))
            player.a_startSound("game/purchase");
        else if (zmd_Points.takeFrom(player, self.weaponCost) && player.a_giveInventory(weaponName))
            player.a_startSound("game/purchase");
        else
            return false;
        return true;
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
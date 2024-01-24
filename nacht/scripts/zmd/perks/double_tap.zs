class zmd_DoubleTapMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 2000;
        zmd_PerkMachine.perk 'zmd_DoubleTap';
    }

    States {
    Spawn:
        qkrv a 1;
        loop;
    }
}

class zmd_DoubleTap : zmd_Perk {
    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_Player(owner).enableWeaponPerks();
    }
}
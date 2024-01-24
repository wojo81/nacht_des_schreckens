class zmd_SpeedColaMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 3000;
        zmd_PerkMachine.perk 'zmd_SpeedCola';
    }

    States {
    Spawn:
        qkrv a 1;
        loop;
    }
}

class zmd_SpeedCola : zmd_Perk {
    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_Player(owner).enableWeaponPerks();
    }
}
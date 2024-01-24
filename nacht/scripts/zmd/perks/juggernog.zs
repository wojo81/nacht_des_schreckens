class zmd_JuggernogMachine : zmd_PerkMachine {
    Default {
        zmd_PerkMachine.cost 2500;
        zmd_PerkMachine.perk 'zmd_Juggernog';
    }

    States {
    Spawn:
        qkrv a 1;
        loop;
    }
}

class zmd_Juggernog : zmd_Perk {
    override void attachToOwner(Actor other) {
        super.attachToOwner(other);
        zmd_Player(owner).healthMin = zmd_Player.juggHealthMin;
    }

    override void detachFromOwner() {
        super.detachFromOwner();
        zmd_Player(owner).healthMin = zmd_Player.regularHealthMin;
    }
}
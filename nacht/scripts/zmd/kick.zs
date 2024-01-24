class NTM_QuickMelee : CustomInventory {
    int inuse;

    States {
    Use:
        TNT1 A 0 A_Overlay(-2,"QuickMelee");
        TNT1 A 0 A_OverlayOffset(-2,0,32);
        Fail;
    QuickMelee:
        QKCK ABCDE 2;
        QKCK F 2 A_CustomPunch(40, noRandom: true, flags: 0, puffType: "NTM_QuickPuff", meleeSound: "player/male/fist");
        QKCK EDCBA 2;
        Stop;
    }

    Override void DoEffect() {
        Super.DoEffect();
        if (inuse > 0) {
            inuse--;
        }
        if (owner.GetPlayerInput(MODINPUT_BUTTONS) & BT_ALTATTACK && inuse==0) {
            owner.UseInventory(self);
            inuse=22;
        }
    }
}

class NTM_QuickPuff : BulletPuff {
    Default {
        AttackSound "player/male/fist";
        DamageType 'kick';
        +NODECAL;
    }
}
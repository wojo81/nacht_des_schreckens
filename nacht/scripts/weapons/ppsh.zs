class Ppsh : zmd_Weapon {
    Default {
        attackSound "weapons/ppsh_fire1";
        Weapon.ammoUse 1;
        Weapon.ammoGive 142;
        Weapon.ammoType 'PpshAmmo';

        zmd_Weapon.clipCapacity 71;
    }

    States {
    Ready:
        ppsi A 1 readyWeapon;
        loop;

    Deselect:
        tnt1 A 0 cancelZoom;
        ppsi A 1 a_lower;
        wait;

    Select:
        ppsi A 1 a_raise;
        wait;

    Fire:
        tnt1 a 0 jumpIfZoomed('Zoom.Fire');
        tnt1 a 0 jumpIfClipEmpty('Ready');
        ppsf a 1 doubleFire(0);
        ppsf b 1 shoot(4, 1, 40);
        ppsf c 1;
        tnt1 a 0 a_refire;
        goto Ready;

    Reload:
        tnt1 A 0 cancelZoom;
        tnt1 A 0 jumpIfAmmoEmpty('Ready');
        ppsr abc 3 fastReload(2);
        ppsr d 3 {a_startSound("weapons/ppsh_magout"); fastReload(2);}
        ppsr efghij 3 fastReload(2);
        ppsr k 3 {a_startSound("weapons/ppsh_magin"); fastReload(2);}

        ppsr lmn 3 fastReload(2);
        ppsr o 3 {a_startSound("weapons/ppsh_magtap"); fastReload(2);}
        ppsr pqrstu 3 fastReload(2);
        ppsr v 3 {a_startSound("weapons/ppsh_slide_forward"); fastReload(2);}
        ppsr wxyz 3 fastReload(2);
        tnt1 A 0 reload;
        goto Ready;

    Zoom:
        tnt1 a 0 toggleZoom;

    Zoom.In:
        ppsz a 2 a_zoomFactor(1.5);
        ppsz bc 2;

    Zoom.Ready:
        tnt1 a 0 maybeCancelZoom;
        ppsz c 1 readyWeapon;
        loop;

    Zoom.Fire:
        tnt1 a 0 jumpIfClipEmpty('Zoom.Ready');
        ppsv a 1;
        ppsv b 1 shoot(0.25, 1, 40);
        ppsv c 1;
        tnt1 a 0 a_refire;
        goto Zoom.Ready;

    Zoom.Out:
        ppsz c 2 cancelZoom;
        ppsz b 2;
        goto Ready;

    Spawn:
        ppsp a 1;
        stop;
    }
}

class PpshAmmo : Ammo {
    Default {
        Inventory.maxAmount 355;
    }
}
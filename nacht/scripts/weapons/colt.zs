class Colt : zmd_Weapon {
    Default {
        attackSound "weapons/colt";
        Weapon.ammoUse 1;
        Weapon.ammoGive 40;
        Weapon.ammoType "ColtAmmo";

        zmd_Weapon.clipCapacity 8;
    }

    States {
    Ready:
        coli A 1 readyWeapon;
        loop;

    Deselect:
        tnt1 A 0 cancelZoom;
        coli A 1 a_lower;
        wait;

    Select:
        coli A 1 a_raise;
        wait;

    Fire:
        tnt1 a 0 jumpIfZoomed("Zoom.Fire");
        tnt1 a 0 jumpIfClipEmpty("Ready");
        colf a 2 doubleFire(1);
        colf b 2 shoot(5, 1, 10);
        colf c 2 doubleFire(1);
        goto Ready;

    Reload:
        tnt1 A 0 cancelZoom;
        tnt1 A 0 jumpIfAmmoEmpty("Ready");
        colr AB 3 fastReload(2);
        tnt1 a 0 a_startSound("weapons/coltReload1");
        colr CDEFGHIJKLMNOPQRSTu 3 fastReload(2);
        tnt1 a 0 a_startSound("weapons/coltReload2");
        colr VWXYZ 3 fastReload(2);
        co1r ABCDEFGHI 3 fastReload(2);
        tnt1 A 0 reload;
        goto Ready;

    Zoom:
        tnt1 a 0 toggleZoom;

    Zoom.In:
        colz a 1 a_zoomFactor(1.5);
        colz bcdef 1;

    Zoom.Ready:
        tnt1 a 0 maybeCancelZoom;
        colz f 1 readyWeapon;
        loop;

    Zoom.Fire:
        tnt1 a 0 jumpIfClipEmpty("Zoom.Ready");
        colv a 2;
        colv b 2 shoot(0.25, 1, 10);
        colv c 2;
        goto Zoom.Ready;

    Zoom.Out:
        colz e 1 cancelZoom;
        colz dcb 1;
        goto Ready;
    }
}

class ColtAmmo : Ammo {
    Default {
        Inventory.maxAmount 72;
    }
}
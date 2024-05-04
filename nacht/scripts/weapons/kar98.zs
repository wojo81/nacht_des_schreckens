class Kar98 : zmd_Weapon {
    Default {
        Weapon.ammoGive 30;
        Weapon.ammoType 'Kar98Ammo';
        zmd_Weapon.activeAmmo 5;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
    }

    States {
    Spawn:
        kra0 a -1;
        loop;
    Select:
    Raise:
        krc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('Zoom.Ready');
    Idle:
        krc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        krc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('Zoom.Fire');
        tnt1 a 0 whenLastActiveAmmo('Fire.Last');
        tnt1 a 0 a_startSound("weapons/kar98_fire1");
        kre0 a 2 ff;
        tnt1 a 0 shootBullets(1, 15, 1);
        kre0 bcdefgh 2 ff;
        tnt1 a 0 a_startSound("weapons/kar98_bolt_up");
        kre0 ij 2 ff;
        tnt1 a 0 a_startSound("weapons/kar98_bolt_back");
        kre0 kl 2 ff;
        tnt1 a 0 a_startSound("weapons/kar98_bolt_forward");
        kre0 mnopqrstuv 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        krd0 abc 3 fr;
        tnt1 a 0 a_startSound("weapons/kar98_bolt_back");
        krd0 defghijklmnopqrstuvwxyz 3 fr;
        krd1 abcd 3 fr;
        tnt1 a 0 a_startSound("weapons/kar98_bolt_forward");
        krd1 efghijklmn 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    Zoom.In:
        tnt1 a 0 zoomIn;
        krb0 abcde 2;
    Zoom.Ready:
    Zoom.Idle:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        krh0 a 2 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        krb0 edcba 2;
        goto Ready;
    Zoom.Fire:
        tnt1 a 0 whenLastActiveAmmo('Zoom.Fire.Last');
        tnt1 a 0 a_startSound("weapons/kar98_fire1");
        kri0 a 2 ff;
        tnt1 a 0 shootBullets(0.25, 15, 1);
        kri0 bcdefgh 2 ff;
        tnt1 a 0 a_startSound("weapons/kar98_bolt_up");
        kri0 ij 2 ff;
        tnt1 a 0 a_startSound("weapons/kar98_bolt_back");
        kri0 kl 2 ff;
        tnt1 a 0 a_startSound("weapons/kar98_bolt_forward");
        kri0 mnopqrstuv 2 ff;
        goto Ready;
    Fire.Last:
        tnt1 a 0 a_startSound("weapons/kar98_fire1");
        krg0 a 2 ff;
        tnt1 a 0 shootBullets(1, 15, 1);
        krg0 bcdef 2 ff;
        goto Ready;
    Zoom.Fire.Last:
        tnt1 a 0 a_startSound("weapons/kar98_fire1");
        krk0 a 2 ff;
        tnt1 a 0 shootBullets(0.25, 15, 1);
        krk0 bcdef 2 ff;
        goto Ready;
    }
}

class Kar98Ammo : Ammo {
    Default {
        Inventory.maxAmount 60;
    }
}

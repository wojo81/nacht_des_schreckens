class CarbineAmmo : Ammo {
    Default {
        Inventory.maxAmount 120;
    }
}

class Carbine : zmd_Weapon {
    Default {
        Weapon.ammoGive 60;
        Weapon.ammoType 'CarbineAmmo';
        zmd_Weapon.activeAmmo 15;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
    }

    States {
    Spawn:
        mca0 a -1;
        loop;
    Select:
        tnt1 a 0 whenNoActiveAmmo('EmptyRaise');
    Raise:
        mcc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
        tnt1 a 0 whenNoActiveAmmo('EmptyIdle');
    Idle:
        mcc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('EmptyLower');
    Lower:
        mcc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        tnt1 a 0 whenLastActiveAmmo('LastFire');
        mcf0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/carbine_fire");
        tnt1 a 0 shootBullets(3, 15, 1);
        mcf0 bcd 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('PartialReload');
        mcd0 abcdefghi 3 fr;
        tnt1 a 0 a_startSound("weapons/carbine_mag_out");
        mcd0 jklmnopqrstuvwxy 3 fr;
        tnt1 a 0 a_startSound("weapons/carbine_futz");
        mcd0 z 3 fr;
        mcd1 abcdef 3 fr;
        tnt1 a 0 a_startSound("weapons/carbine_mag_in");
        mcd1 ghijklmnopq 3 fr;
        tnt1 a 0 a_startSound("weapons/carbine_charge");
        mcd1 rstuvwxyz 3 fr;
        mcd2 abcd 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomIn');
        mcb0 abcdefgh 2;
    ZoomReady:
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomIdle');
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        mch0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomOut');
        mcb0 hgfedcba 2;
        goto Ready;
    ZoomFire:
        tnt1 a 0 whenLastActiveAmmo('LastZoomFire');
        mci0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/carbine_fire");
        tnt1 a 0 shootBullets(0.5, 15, 1);
        mci0 bcd 2 ff;
        goto Ready;
    LastFire:
        mcg0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/carbine_fire");
        tnt1 a 0 shootBullets(3, 15, 1);
        mcg0 bcd 2 ff;
        goto Ready;
    LastZoomFire:
        mcj0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/carbine_fire");
        tnt1 a 0 shootBullets(0.5, 15, 1);
        mcj0 bcd 2 ff;
        goto Ready;
    PartialReload:
        mce0 abcdefghi 2 fr;
        tnt1 a 0 a_startSound("weapons/carbine_mag_out");
        mce0 jklmnopqrstuvwxy 2 fr;
        tnt1 a 0 a_startSound("weapons/carbine_futz");
        mce0 z 2 fr;
        mce1 abcdef 2 fr;
        tnt1 a 0 a_startSound("weapons/carbine_mag_in");
        mce1 ghijklmnopqrstuv 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    EmptyRaise:
        mcl0 a 1 a_raise;
        loop;
    EmptyIdle:
        mcl0 a 1 readyWeapon;
        loop;
    EmptyLower:
        mcl0 a 1 a_lower;
        loop;
    EmptyZoomIn:
        mck0 abcdefgh 2;
    EmptyZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        mcm0 a 1 readyWeapon;
        loop;
    EmptyZoomOut:
        mck0 hgfedcba 2;
        goto Ready;
    }
}
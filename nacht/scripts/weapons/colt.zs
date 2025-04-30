class ColtAmmo : Ammo {
    Default {
        Inventory.maxAmount 72;
    }
}

class Colt : zmd_Weapon {
    Default {
        Weapon.ammoGive 32;
        Weapon.ammoType 'ColtAmmo';
        zmd_Weapon.activeAmmo 8;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload true;
    }

    States {
    Spawn:
        cla0 a -1;
        loop;
    Select:
        tnt1 a 0 whenNoActiveAmmo('EmptyRaise');
    Raise:
        clc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
        tnt1 a 0 whenNoActiveAmmo('EmptyIdle');
    Idle:
        clc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('EmptyLower');
    Lower:
        clc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        tnt1 a 0 whenLastActiveAmmo('LastFire');
        clf0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/colt");
        tnt1 a 0 shootBullets(3, 5, 1);
        clf0 bc 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('PartialReload');
        cld0 ab 3 fr;
        tnt1 a 0 a_startSound("weapons/coltReload1");
        cld0 cdefghijklmnopqrstuv 3 fr;
        tnt1 a 0 a_startSound("weapons/coltReload2");
        cld0 wxyz 3 fr;
        cld1 abcdefghij 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomIn');
        clb0 abcdef 2;
    ZoomReady:
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomIdle');
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        clh0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('EmptyZoomOut');
        clb0 fedcba 2;
        goto Ready;
    ZoomFire:
        tnt1 a 0 whenLastActiveAmmo('LastZoomFire');
        cli0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/colt");
        tnt1 a 0 shootBullets(0.25, 5, 1);
        cli0 bc 2 ff;
        goto Ready;
    LastFire:
        clg0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/colt");
        tnt1 a 0 shootBullets(3, 5, 1);
        clg0 bc 2 ff;
        goto Ready;
    LastZoomFire:
        clj0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/colt");
        tnt1 a 0 shootBullets(0.25, 5, 1);
        clj0 bc 2 ff;
        goto Ready;
    PartialReload:
        cle0 ab 2 fr;
        tnt1 a 0 a_startSound("weapons/coltReload1");
        cle0 cdefghijklmnopqrstuv 2 fr;
        tnt1 a 0 a_startSound("weapons/coltReload2");
        cle0 wxyz 2 fr;
        cle1 abcdef 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    EmptyRaise:
        cll0 a 1 a_raise;
        loop;
    EmptyIdle:
        cll0 a 1 readyWeapon;
        loop;
    EmptyLower:
        cll0 a 1 a_lower;
        loop;
    EmptyZoomIn:
        clk0 abcdef 2;
    EmptyZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        clm0 a 1 readyWeapon;
        loop;
    EmptyZoomOut:
        clk0 fedcba 2;
        goto Ready;
    }
}
class Ppsh : zmd_Weapon {
    Default {
        Weapon.ammoGive 142;
        Weapon.ammoType 'PpshAmmo';
        zmd_Weapon.activeAmmo 71;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
    }

    States {
    Spawn:
        ppa0 a -1;
        loop;
    Select:
    Raise:
        ppc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
    Idle:
        ppc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        ppc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        tnt1 a 0 whenLastActiveAmmo('LastFire');
        ppf0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/ppsh_fire1");
        tnt1 a 0 shootBullets(3, 20, 1);
        ppf0 b 2 ff;
        tnt1 a 0 a_refire;
        ppf0 c 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('PartialReload');
        ppd0 abcd 3 fr;
        tnt1 a 0 a_startSound("weapons/ppsh_magout");
        ppd0 efghijkl 3 fr;
        tnt1 a 0 a_startSound("weapons/ppsh_magin");
        ppd0 mnopqrst 3 fr;
        tnt1 a 0 a_startSound("weapons/ppsh_magtap");
        ppd0 uvwxyz 3 fr;
        ppd1 abcd 3 fr;
        tnt1 a 0 a_startSound("weapons/ppsh_slide_forward");
        ppd1 efghijklm 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        ppb0 abcde 2;
    ZoomReady:
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        pph0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        ppb0 edcba 2;
        goto Ready;
    ZoomFire:
        tnt1 a 0 whenLastActiveAmmo('LastZoomFire');
        ppi0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/ppsh_fire1");
        tnt1 a 0 shootBullets(1, 20, 1);
        ppi0 b 2 ff;
        tnt1 a 0 a_refire;
        ppi0 c 2 ff;
        goto Ready;
    LastFire:
        ppg0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/ppsh_fire1");
        tnt1 a 0 shootBullets(3, 20, 1);
        ppg0 bc 2 ff;
        goto Ready;
    LastZoomFire:
        ppj0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/ppsh_fire1");
        tnt1 a 0 shootBullets(1, 20, 1);
        ppj0 bc 2 ff;
        goto Ready;
    PartialReload:
        ppe0 abcdefghijklmnopqrstuvwxyz 2 fr;
        ppe1 abcd 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    }
}

class PpshAmmo : Ammo {
    Default {
        Inventory.maxAmount 355;
    }
}

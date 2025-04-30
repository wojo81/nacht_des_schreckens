class Type100Ammo : Ammo {
    Default {
        Inventory.maxAmount 355;
    }
}

class Type100 : zmd_Weapon {
    Default {
        Weapon.ammoGive 142;
        Weapon.ammoType 'Type100Ammo';
        zmd_Weapon.activeAmmo 71;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload true;
    }

    States {
    Spawn:
        t1a0 a -1;
        loop;
    Select:
    Raise:
        t1c0 abc 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
    Idle:
        t1c0 abc 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        t1c0 abc 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        tnt1 a 0 whenLastActiveAmmo('LastFire');
        t1f0 a 2 ff;
        tnt1 a 0 shootBullets(3, 17, 1);
        t1f0 b 2 ff;
        tnt1 a 0 a_refire;
        t1f0 c 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('PartialReload');
        t1d0 abcdefghijklmnopqrstuvwxyz 3 fr;
        t1d1 abcdefghijklmnopqrstu 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        t1b0 abcde 2;
    ZoomReady:
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        t1h0 abc 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        t1b0 edcba 2;
        goto Ready;
    ZoomFire:
        tnt1 a 0 whenLastActiveAmmo('LastZoomFire');
        t1i0 a 2 ff;
        tnt1 a 0 shootBullets(1, 17, 1);
        t1i0 b 2 ff;
        tnt1 a 0 a_refire;
        t1i0 c 2 ff;
        goto Ready;
    LastFire:
        t1g0 a 2 ff;
        tnt1 a 0 shootBullets(3, 17, 1);
        t1g0 bc 2 ff;
        goto Ready;
    LastZoomFire:
        t1j0 a 2 ff;
        tnt1 a 0 shootBullets(1, 17, 1);
        t1j0 bc 2 ff;
        goto Ready;
    PartialReload:
        t1e0 abcdefghijklmnopqrstuvwxyz 2 fr;
        t1e1 abcdefghij 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    }
}
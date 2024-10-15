class MagnumAmmo : Ammo {
    Default {
        Inventory.maxAmount 66;
    }
}

class Magnum : zmd_Weapon {
    Default {
        Weapon.ammoGive 30;
        Weapon.ammoType 'MagnumAmmo';
        zmd_Weapon.activeAmmo 6;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
    }

    States {
    Spawn:
        swa0 a -1;
        loop;
    Select:
    Raise:
        swc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
    Idle:
        swc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        swc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        swf0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/magnum_fire");
        tnt1 a 0 shootBullets(3, 10, 1);
        swf0 bcde 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        swd0 abcdefghi 3 fr;
        tnt1 a 0 a_startSound("weapons/magnum_open");
        swd0 jklmnop 3 fr;
        tnt1 a 0 a_startSound("weapons/magnum_empty");
        swd0 qrstuvwxyz 3 fr;
        swd1 abcd 3 fr;
        tnt1 a 0 a_startSound("weapons/magnum_load");
        swd1 efghijk 3 fr;
        tnt1 a 0 a_startSound("weapons/magnum_close");
        swd1 lmnopqrs 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        swb0 abcdefg 2;
    ZoomReady:
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        swg0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        swb0 gfedcba 2;
        goto Ready;
    ZoomFire:
        swh0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/magnum_fire");
        tnt1 a 0 shootBullets(0.25, 10, 1);
        swh0 bcde 2 ff;
        goto Ready;
    }
}
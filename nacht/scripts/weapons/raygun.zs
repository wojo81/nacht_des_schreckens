class Raygun : zmd_Weapon {
    Default {
        Weapon.ammoGive 60;
        Weapon.ammoType 'RaygunAmmo';
        zmd_Weapon.activeAmmo 20;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
    }

    States {
    Spawn:
        rga0 a -1;
        loop;
    Select:
    Raise:
        rgc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
    Idle:
        rgc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        rgc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        rge0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/raygun");
        tnt1 a 0 shootProjectile('Rayflux');
        rge0 b 2 ff;
        tnt1 a 0 a_refire;
        rge0 cdefg 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        rgd0 abcdefghijklmn 3 fr;
        tnt1 a 0 a_startSound("weapons/raygunReload1");
        rgd0 opqrstuvwxyz 3 fr;
        rgd1 abcdefghijklmnopqrstu 3 fr;
        tnt1 a 0 a_startSound("weapons/raygunReload2");
        rgd1 v 3 fr;
        tnt1 a 0 a_startSound("weapons/raygunReload3");
        rgd1 wxyz 3 fr;
        rgd2 abcdefgh 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        rgb0 abcde 2;
    ZoomReady:
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        rgf0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        rgb0 edcba 2;
        goto Ready;
    ZoomFire:
        rgg0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/raygun");
        tnt1 a 0 shootProjectile('Rayflux');
        rgg0 b 2 ff;
        tnt1 a 0 a_refire;
        rgg0 cdefg 2 ff;
        goto Ready;
    }
}

class RaygunAmmo : Ammo {
    Default {
        Inventory.maxAmount 200;
    }
}

class zmd_DoubleBarrelShotgunAmmo : Ammo {
    Default {
        Inventory.maxAmount 60;
    }
}

class zmd_DoubleBarrelShotgun : zmd_Weapon {
    Default {
        Weapon.ammoGive 28;
        Weapon.ammoType 'zmd_DoubleBarrelShotgunAmmo';
        zmd_Weapon.activeAmmo 2;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload true;
    }

    States {
    Spawn:
        dba0 a -1;
        loop;
    Select:
    Raise:
        dbc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
    Idle:
        dbc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        dbc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        tnt1 a 0 a_startSound("weapons/shotgun_fire");
        dbf0 a 2 ff;
        tnt1 a 0 shootBullets(5, 30, 4);
        dbf0 bcdef 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('PartialReload');
        dbd0 abcdefghij 3 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_pull");
        dbd0 klmnopqrstuvwxyz 3 fr;
        dbd1 abcdefghijklmnopqrstuv 3 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_push");
        dbd1 wxyz 3 fr;
        dbd2 abcd 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        dbb0 abcdefgh 2;
    ZoomReady:
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        dbg0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        dbb0 hgfedcba 2;
        goto Ready;
    ZoomFire:
        tnt1 a 0 a_startSound("weapons/shotgun_fire");
        dbh0 a 2 ff;
        tnt1 a 0 shootBullets(3, 30, 4);
        dbh0 bcdef 2 ff;
        goto Ready;
    PartialReload:
        dbe0 abcdefgh 2 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_pull");
        dbe0 ijklmnopqrstuvwxyz 2 fr;
        dbe1 abcdefghijklmno 2 fr;
        tnt1 a 0 a_startSound("weapons/shotgun_push");
        dbe1 pqrstuv 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    }
}
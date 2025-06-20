class zmd_ThompsonAmmo : Ammo {
    Default {
        Inventory.maxAmount 200;
    }
}

class zmd_Thompson : zmd_Weapon {
    Default {
        Weapon.ammoGive 80;
        Weapon.ammoType 'zmd_ThompsonAmmo';
        zmd_Weapon.activeAmmo 20;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload true;
    }

    States {
    Spawn:
        tpa0 a -1;
        loop;
    Select:
    Raise:
        tpc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('ZoomReady');
    Idle:
        tpc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
    Lower:
        tpc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('ZoomFire');
        tnt1 a 0 whenLastActiveAmmo('LastFire');
        tpf0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/thompson_fire");
        tnt1 a 0 shootBullets(3, 12, 1);
        tpf0 bc 2 ff;
        tnt1 a 0 a_refire;
        tpf0 de 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenFullAmmo('Ready');
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('PartialReload');
        tpd0 abcd 3 fr;
        tnt1 a 0 a_startSound("weapons/thompson_magout");
        tpd0 efghijklm 3 fr;
        tnt1 a 0 a_startSound("weapons/thompson_magin");
        tpd0 nopqrstuvw 3 fr;
        tnt1 a 0 a_startSound("weapons/thompson_charge");
        tpd0 xyz 3 fr;
        tpd1 abcdefghijklm 3 fr;
        tnt1 a 0 reload;
        goto Ready;
    Zoom:
        tnt1 a 0 toggleZoom;
    ZoomIn:
        tnt1 a 0 zoomIn;
        tpb0 abcd 2;
    ZoomReady:
    ZoomIdle:
        tnt1 a 0 whenShouldZoomOut('ZoomOut');
        tph0 a 2 readyWeapon;
        loop;
    ZoomOut:
        tnt1 a 0 zoomOut;
        tpb0 dcba 2;
        goto Ready;
    ZoomFire:
        tnt1 a 0 whenLastActiveAmmo('LastZoomFire');
        tpi0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/thompson_fire");
        tnt1 a 0 shootBullets(1, 12, 1);
        tpi0 bc 2 ff;
        tnt1 a 0 a_refire;
        tpi0 de 2 ff;
        goto Ready;
    LastFire:
        tpg0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/thompson_fire");
        tnt1 a 0 shootBullets(3, 12, 1);
        tpg0 bcde 2 ff;
        goto Ready;
    LastZoomFire:
        tpj0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/thompson_fire");
        tnt1 a 0 shootBullets(1, 12, 1);
        tpj0 bcde 2 ff;
        goto Ready;
    PartialReload:
        tpe0 abcde 2 fr;
        tnt1 a 0 a_startSound("weapons/thompson_magout");
        tpe0 fghijklmnopqrstu 2 fr;
        tnt1 a 0 a_startSound("weapons/thompson_magin");
        tpe0 vwxyz 2 fr;
        tpe1 abcd 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    }
}
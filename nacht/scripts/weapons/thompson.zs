class Thompson : zmd_Weapon {
    Default {
        Weapon.ammoGive 80;
        Weapon.ammoType 'ThompsonAmmo';
        zmd_Weapon.activeAmmo 20;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
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
        tnt1 a 0 whenZoomed('Zoom.Ready');
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
        tnt1 a 0 whenZoomed('Zoom.Fire');
        tnt1 a 0 whenLastActiveAmmo('Fire.Last');
        tpf0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/thompson_fire");
        tnt1 a 0 shootBullets(3, 12, 1);
        tpf0 bc 2 ff;
        tnt1 a 0 a_refire;
        tpf0 de 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('Reload.Partial');
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
    Zoom.In:
        tnt1 a 0 zoomIn;
        tpb0 abcd 2;
    Zoom.Ready:
    Zoom.Idle:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        tph0 a 2 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        tpb0 dcba 2;
        goto Ready;
    Zoom.Fire:
        tnt1 a 0 whenLastActiveAmmo('Zoom.Fire.Last');
        tpi0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/thompson_fire");
        tnt1 a 0 shootBullets(1, 12, 1);
        tpi0 bc 2 ff;
        tnt1 a 0 a_refire;
        tpi0 de 2 ff;
        goto Ready;
    Fire.Last:
        tpg0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/thompson_fire");
        tnt1 a 0 shootBullets(3, 12, 1);
        tpg0 bcde 2 ff;
        goto Ready;
    Zoom.Fire.Last:
        tpj0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/thompson_fire");
        tnt1 a 0 shootBullets(1, 12, 1);
        tpj0 bcde 2 ff;
        goto Ready;
    Reload.Partial:
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

class ThompsonAmmo : Ammo {
    Default {
        Inventory.maxAmount 200;
    }
}

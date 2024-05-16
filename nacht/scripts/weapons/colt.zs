class Colt : zmd_Weapon {
    Default {
        Weapon.ammoGive 32;
        Weapon.ammoType 'ColtAmmo';
        zmd_Weapon.activeAmmo 8;
        zmd_Weapon.reloadFrameRate 3;
        zmd_Weapon.fireFrameRate 2;
        zmd_Weapon.keepPartialReload false;
    }

    States {
    Spawn:
        cla0 a -1;
        loop;
    Select:
        tnt1 a 0 whenNoActiveAmmo('Raise.Empty');
    Raise:
        clc0 a 1 a_raise;
        loop;
    Ready:
        tnt1 a 0 whenZoomed('Zoom.Ready');
        tnt1 a 0 whenNoActiveAmmo('Idle.Empty');
    Idle:
        clc0 a 1 readyWeapon;
        loop;
    Deselect:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('Lower.Empty');
    Lower:
        clc0 a 1 a_lower;
        loop;
    Fire:
        tnt1 a 0 whenNoActiveAmmo('Ready');
        tnt1 a 0 whenZoomed('Zoom.Fire');
        tnt1 a 0 whenLastActiveAmmo('Fire.Last');
        clf0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/colt");
        tnt1 a 0 shootBullets(3, 5, 1);
        clf0 bc 2 ff;
        goto Ready;
    Reload:
        tnt1 a 0 whenNoAmmo('Ready');
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenAnyActiveAmmo('Reload.Partial');
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
    Zoom.In:
        tnt1 a 0 zoomIn;
        tnt1 a 0 whenNoActiveAmmo('Zoom.In.Empty');
        clb0 abcdef 2;
    Zoom.Ready:
        tnt1 a 0 whenNoActiveAmmo('Zoom.Idle.Empty');
    Zoom.Idle:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        clh0 a 2 readyWeapon;
        loop;
    Zoom.Out:
        tnt1 a 0 zoomOut;
        tnt1 a 0 whenNoActiveAmmo('Zoom.Out.Empty');
        clb0 fedcba 2;
        goto Ready;
    Zoom.Fire:
        tnt1 a 0 whenLastActiveAmmo('Zoom.Fire.Last');
        cli0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/colt");
        tnt1 a 0 shootBullets(0.25, 5, 1);
        cli0 bc 2 ff;
        goto Ready;
    Fire.Last:
        clg0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/colt");
        tnt1 a 0 shootBullets(3, 5, 1);
        clg0 bc 2 ff;
        goto Ready;
    Zoom.Fire.Last:
        clj0 a 2 ff;
        tnt1 a 0 a_startSound("weapons/colt");
        tnt1 a 0 shootBullets(0.25, 5, 1);
        clj0 bc 2 ff;
        goto Ready;
    Reload.Partial:
        cle0 ab 2 fr;
        tnt1 a 0 a_startSound("weapons/coltReload1");
        cle0 cdefghijklmnopqrstuv 2 fr;
        tnt1 a 0 a_startSound("weapons/coltReload2");
        cle0 wxyz 2 fr;
        cle1 abcdef 2 fr;
        tnt1 a 0 reload;
        goto Ready;
    Raise.Empty:
        cll0 a 1 a_raise;
        loop;
    Idle.Empty:
        cll0 a 1 readyWeapon;
        loop;
    Lower.Empty:
        cll0 a 1 a_lower;
        loop;
    Zoom.In.Empty:
        clk0 abcdef 2;
    Zoom.Idle.Empty:
        tnt1 a 0 whenShouldZoomOut('Zoom.Out');
        clm0 a 1 readyWeapon;
        loop;
    Zoom.Out.Empty:
        clk0 fedcba 2;
        goto Ready;
    }
}

class ColtAmmo : Ammo {
    Default {
        Inventory.maxAmount 72;
    }
}

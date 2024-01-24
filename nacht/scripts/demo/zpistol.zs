class PistolCasing : ZCasing
{
    Default
    {
        Scale 0.18;
        BounceSound "weapons/casing1";
    }

    States
    {
    Spawn:
        CAS2 ABCDEFGH 2;
        Loop;
    Death:
        CAS2 G -1;
        Stop;
    }
}

class PistolEmptyMag : ZCasing
{
    Default
    {
        Scale 0.5;
        BounceSound "weapons/emptyMagazine";
    }

    States
    {
    Spawn:
        CLP1 ABCDEF 3;
    Death:
        CLP1 A -1;
        Stop;
    }
}

class PistolTracer : ZMeshTracer
{
    Default
    {
        Speed 40;
        Decal "";
        ZBullet.AirFriction 1;
        ZBullet.PuffType "";
        +NoGravity
    }
}


class ZPistol : ZWeapon replaces Pistol {
	Default {
		Weapon.SelectionOrder 1900;
		Weapon.AmmoUse1 1;
		Weapon.AmmoType1 "ZPistolAmmo";
		Weapon.AmmoGive 40;

        ZWeapon.MagazineSize 8;
        ZWeapon.ReloadSound "misc/w_pkup";
        ZWeapon.ClickSound "weapons/emptyClick";

		Obituary "$OB_MPPISTOL";
		+WEAPON.WIMPY_WEAPON
		Inventory.Pickupmessage "$PICKUP_PISTOL_DROPPED";
		Tag "$TAG_PISTOL";

        AttackSound "weapons/pistol";
	}
	
	States
	{
	Ready:
		PKPI A 1 ZWL_WeaponReady;
		Loop;
	Deselect:
		PKPI A 1 A_Lower;
		Loop;
	Select:
		PIST A 2 ZWL_QuickRaise;
        PIST BCD 2;
		Goto Ready;
	Fire:
		PKPF A 2 Bright
        {
            ZWL_FireHitscan(2, 5 * Random(1, 3), tracerType: "PistolTracer");
            A_Light(1);
        }
		PKPI B 2
        {
            ZWL_EjectCasing("PistolCasing");
            A_Light(0);

            return ZWL_JumpIfEmpty("Fire.Empty");
        }
		PKPI C 2;
        PKPI DDEEFF 1 ZWL_ReFire(null, false);
		Goto Ready;
    Fire.Empty:
        PKPE ABCD 2;
        PKPE E 8;
        Goto Ready;
    Reload:
        PKR2 ABCDE 2 ZWL_JumpIfDepleted("Ready");
        PKR2 F 2 ZWL_EjectCasing("PistolEmptyMag", true, 45, 2, 16, (24, 0, -24));
        PKR2 GHI 2;
        PKR2 J 2 ZWL_Reload(wasteRemaining: true);
        PKR2 KL 2;
        PKPR MNOPQ 2;
        Goto Ready;
 	Spawn:
		23PT A -1;
		Stop;
	}
}

class ZPistolAmmo : Ammo {
	Default {
		Inventory.maxAmount 72;
	}
}
## Tekka

https://docs.google.com/document/d/16pixFZje1Dmrgej8HoE79nyTAU2_zX1VaUHGtIj563Y/edit#

Ask TankNut for access

### Hooks
Try to stick to the naming convention, makes our life a lot easier

**Hook running:**

``gm.realm.func``


``hook.Run("CC.SH.InitEnts")``

**Hooking in:**

``realm.file.func``

``hook.Add("CC.SH.InitEnts", "SV.Items.InitEnts", function() end)``

### Currently implemented hooks:
**Client:**

``CC.CL.DrawHUDBars (y, w)``

**Shared:**

``CC.SH.InitEnts``

``CC.SH.LoadCharacter (ply)``

``CC.SH.SetupPlayerAccessors``

``CC.SH.Think``

**Server:**

``CC.SV.InitialSpawn (ply)``

``CC.SV.InitSQL``

``CC.SV.LoadCharacterData (ply, data)``

``CC.SV.PlayerDeath (ply)``

``CC.SV.PlayerThink (ply)``

``CC.SV.ShutDown``

``CC.SV.SpeedThink``

``CC.SV.UnloadCharacter (ply)``

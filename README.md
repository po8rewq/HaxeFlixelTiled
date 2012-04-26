HaxeFlixelTiled
===============

FlxTiled port to Haxe based on Matt Tuttle and Thomas Jahn's works

Example based on the Flixel Mode demo :

```bash
var tmx : TmxMap = new TmxMap( nme.Assets.getText('levels/map01.tmx') );
  	
// Basic level structure
var t:FlxTilemap = new FlxTilemap();
		
// Generate a CSV from the layer 'map' with all the tiles from the TileSet 'tiles'
var mapCsv:String = tmx.getLayer('map').toCsv( tmx.getTileSet('tiles') );
		
t.loadMap(mapCsv, "gfx/tiles.png", 8, 8, FlxTilemap.OFF);
t.follow();
add(t);
```
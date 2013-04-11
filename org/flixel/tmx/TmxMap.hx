/*******************************************************************************
 * Copyright (c) 2012 by Adrien Fischer (original by Matt Tuttle based on Thomas Jahn's )
 * This content is released under the MIT License.
 * For questions mail me at adrien@revolugame.com
 ******************************************************************************/
package org.flixel.tmx;

import haxe.xml.Fast;

class TmxMap
{
    public var version      : String; 
	public var orientation  : String;
	
	public var width        : Int;
	public var height       : Int; 
	public var tileWidth    : Int; 
	public var tileHeight   : Int;
	
	//public var fullWidth  : Int;
	//public var fullHeight : Int;

	public var properties   : TmxPropertySet;
	public var tilesets     : Map<String, TmxTileSet>;
	public var layers       : Map<String, TmxLayer>;
	public var objectGroups : Map<String, TmxObjectGroup>;

    public function new(data: Dynamic)
    {
        properties = new TmxPropertySet();
		var source:Fast = null;
		var node:Fast = null;
		
        if (Std.is(data, String)) source = new Fast(Xml.parse(data));
		else if (Std.is(data, Xml)) source = new Fast(data);
//		else if (Std.is(data, ByteArray)) source = new Fast(Xml.parse(data.toString()));
		else throw "Unknown TMX map format";
        
		tilesets = new Map<String, TmxTileSet>();
		layers = new Map<String, TmxLayer>();
		objectGroups = new Map<String, TmxObjectGroup>();
		
		source = source.node.map;
		
		//map header
		version = source.att.version;
		if (version == null) version = "unknown";
		
		orientation = source.att.orientation;
		if (orientation == null) orientation = "orthogonal";
		
		width = Std.parseInt(source.att.width);
		height = Std.parseInt(source.att.height);
		tileWidth = Std.parseInt(source.att.tilewidth);
		tileHeight = Std.parseInt(source.att.tileheight);
		// Calculate the entire size
		//fullWidth = width * tileWidth;
		//fullHeight = height * tileHeight;
		
		//read properties
		for (node in source.nodes.properties)
			properties.extend(node);
		
		//load tilesets
		for (node in source.nodes.tileset)
			tilesets.set(node.att.name, new TmxTileSet(node));
		
		//load layer
		for (node in source.nodes.layer)
			layers.set(node.att.name, new TmxLayer(node, this));
		
		//load object group
		for (node in source.nodes.objectgroup)
			objectGroups.set(node.att.name, new TmxObjectGroup(node, this));
	}
		
	public function getTileSet(name:String):TmxTileSet
	{
		return tilesets.get(name);
	}
		
	public function getLayer(name:String):TmxLayer
	{
		return layers.get(name);
	}
		
	public function getObjectGroup(name:String):TmxObjectGroup
	{
		return objectGroups.get(name);
	}			
		
	//works only after TmxTileSet has been initialized with an image...
	public function getGidOwner(gid:Int):TmxTileSet
	{
		var last:TmxTileSet = null;
		var set:TmxTileSet;
		for (set in tilesets)
		{
			if(set.hasGid(gid))
				return set;
		}
		return null;
	}

}

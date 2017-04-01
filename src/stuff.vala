/*
 *  This file is part of Echogram, a Gtk+ echogram viewer application.
 *
 *  Copyright (C) 2017 Igor Goryachev <igor@goryachev.org>
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

public const float RAD_CONVERSION = 180 / (float)Math.PI;
public const float EARTH_RADIUS = (float)6356752.3142;
public const float METERS_IN_FOOT = (float)0.3048;
public const float KMPH_IN_KNOT = (float)1.852;

public static float feet_to_meters(float feet) {
	return feet * METERS_IN_FOOT;
}

public static float meters_to_feet(float meters) {
	return meters / METERS_IN_FOOT;
}

public static float knots_to_kmph(float knots) {
	return knots * KMPH_IN_KNOT;
}

public static float kmph_to_knots(float kmph) {
	return kmph / KMPH_IN_KNOT;
}

public static float mercator_to_longitude(uint32 mercator) {
	return (float)mercator / EARTH_RADIUS * RAD_CONVERSION;
}

public static uint32 longitude_to_mercator(float longitude) {
	return (uint32)(longitude * EARTH_RADIUS / RAD_CONVERSION);
}

public static float mercator_to_latitude(uint32 mercator) {
	return (float)((2 * Math.atanf(Math.expf((float)mercator / EARTH_RADIUS)) - (float)Math.PI_2) * RAD_CONVERSION);
}

public static uint32 latitude_to_mercator(float latitude) {
	return (uint32)(EARTH_RADIUS * Math.logf(Math.tanf((latitude / RAD_CONVERSION + (float)Math.PI_2) / 2)));
}

public static int round_int(float f) {
	return (int)(Math.ceilf(f));
}

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

public enum Channel {
	PRIMARY,
	SECONDARY,
	DOWNSCAN,
	SIDESCAN_LEFT,
	SIDESCAN_RIGHT,
	SIDESCAN;

	public string to_string() {
		switch (this) {

		case PRIMARY:
			return "primary";

		case SECONDARY:
			return "secondary";

		case DOWNSCAN:
			return "downscan";

		case SIDESCAN:
			return "sidescan";

		case SIDESCAN_LEFT:
			return "sidescan left";

		case SIDESCAN_RIGHT:
			return "sidescan right";

		default:
			assert_not_reached();
		}
	}
}

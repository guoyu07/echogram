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

public enum Frequency {
	200KHZ,
	50KHZ,
	83KHZ,
	455KHZ,
	800KHZ,
	38KHZ,
	28KHZ,
	130KHZ_210KHZ,
	90KHZ_150KHZ,
	40KHZ_60KHZ,
	25KHZ_45KHZ;

	public string to_string() {
		switch (this) {

		case 200KHZ:
			return "200 kHz";

		case 50KHZ:
			return "50 kHz";

		case 83KHZ:
			return "83 kHz";

		case 455KHZ:
			return "455 kHz";

		case 800KHZ:
			return "800 kHz";

		case 38KHZ:
			return "38 kHz";

		case 28KHZ:
			return "28 kHz";

		case 130KHZ_210KHZ:
			return "130-210 kHz";

		case 90KHZ_150KHZ:
			return "90-150 kHz";

		case 40KHZ_60KHZ:
			return "40-60 kHz";

		case 25KHZ_45KHZ:
			return "25-45 kHz";

		default:
			assert_not_reached();
		}
	}
}

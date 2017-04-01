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

public struct Limit {
	public int x;
	public float upper_old;
	public float upper_new;
	public float lower_old;
	public float lower_new;

	public Limit(int x, float upper_old, float upper_new, float lower_old, float lower_new) {
		this.x = x;
		this.upper_old = upper_old;
		this.upper_new = upper_new;
		this.lower_old = lower_old;
		this.lower_new = lower_new;
	}

	public string to_string() {
		return @"x=$x, upper_old=$upper_old, upper_new=$upper_new, lower_old=$lower_old, lower_new=$lower_new";
	}

	public static float upper_min(Limit[] limits) {
		float upper_min = 0;

		foreach (var limit in limits) {
			if (limit.upper_old < upper_min) {
				upper_min = limit.upper_old;
			}

			if (limit.upper_new < upper_min) {
				upper_min = limit.upper_new;
			}
		}

		return upper_min;
	}

	public static float lower_max(Limit[] limits) {
		float lower_max = 0;

		foreach (var limit in limits) {
			if (limit.lower_old > lower_max) {
				lower_max = limit.lower_old;
			}

			if (limit.lower_new > lower_max) {
				lower_max = limit.lower_new;
			}
		}

		return lower_max;
	}
}

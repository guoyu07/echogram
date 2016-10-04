/*
 *  This file is part of Echogram, a Gtk+ echogram viewer application.
 *  Copyright (C) 2016 Igor Goryachev <igor@goryachev.org>
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

public class View : Gtk.Image {
	public SonarLog sonar_log;

	public Channel channel;

	public int width;

	public int height;

	public Orientation orientation;

	public Gdk.Pixbuf pixbuf;

	public int position;

	public View(SonarLog sonar_log, Channel channel, int width, int height, Orientation orientation) {
		Object();
		this.sonar_log = sonar_log;
		this.channel = channel;
		this.width = width;
		this.height = height;
		this.orientation = orientation;
		pixbuf = new Gdk.Pixbuf(Gdk.Colorspace.RGB, false, 8, width, height);
		position = 0;
	}

	public int get_offset(int x, int y) {
		var offset = y * pixbuf.rowstride + x * pixbuf.n_channels;

		if (orientation == Orientation.VERTICAL) {
			offset = x * pixbuf.rowstride + y * pixbuf.n_channels;
		}

		return offset;
	}

	public void set_pixel(int x, int y, uint8 r, uint8 g, uint8 b) {
		uint8* dataPtr = pixbuf.get_pixels();

		dataPtr += get_offset(x, y);

		dataPtr[0] = r;
		dataPtr[1] = g;
		dataPtr[2] = b;
	}

	public Ping[] pings;

	public int[] heights;

	public int[] shifts;

	public void read() {
		float upper_limit = 0;
		float lower_limit = 0;

		int[] heights = {};
		int[] shifts = {};
		Ping[] pings = {};
		Limit[] limits = {};

		var width = this.width;
		var height = this.height;

		if (orientation == Orientation.VERTICAL) {
			var tmp = width;
			width = height;
			height = tmp;
		}

		for (var p = position; p < position + width; p++) {
			var x = p - position;
			heights += height;
			shifts += 0;
			var ping = sonar_log.ping(channel, p);
			pings += ping;

			if (x == 0 || x == width - 1) {
				limits += Limit(x, upper_limit, ping.upper_limit, lower_limit, ping.lower_limit);
			}

			if (ping.upper_limit != upper_limit || ping.lower_limit != lower_limit) {
				if (!(upper_limit == 0 && lower_limit == 0)) {
					limits += Limit(x, upper_limit, ping.upper_limit, lower_limit, ping.lower_limit);
				}
			}

			upper_limit = ping.upper_limit;
			lower_limit = ping.lower_limit;
		}

		// var upper_min = Limit.upper_min(limits);
		var lower_max = Limit.lower_max(limits);

		for (var i = 0; i < limits.length-1; i++) {
			var limit1 = limits[i];
			var limit2 = limits[i+1];

			// assert(limit1.upper_new == limit2.upper_old);
			// assert(limit1.lower_new == limit2.lower_old);

			var upper_cur = limit1.upper_new;
			var lower_cur = limit1.lower_new;

			if (lower_cur != lower_max) {
				var h = round_int(height * lower_cur / lower_max);

				for (var t = limit1.x; t < limit2.x; t++) {
					if (upper_cur != 0) {
					// if (orientation == Orientation.VERTICAL) {
						shifts[t] = (height - h) / 2;
						heights[t] = h;
						continue;
					}

					heights[t] = h;
				}
			}
		}

		this.pings = pings;
		this.heights = heights;
		this.shifts = shifts;
	}

	public void render() {
		Ping ping_first = pings[0];
		Ping ping_last = pings[pings.length-1];
		stderr.printf("channel: %s, first: %u, last: %u\n", channel.to_string(), ping_first.frame_index, ping_last.frame_index);

		//pixbuf.fill(0xffffff);
		pixbuf.fill(0);

		for (var x = 0; x < pings.length; x++) {
			var ping = pings[x];
			for (var y = 0; y < heights[x]; y++) {
				var i = y * ping.packet_size / heights[x];
				var p = ping.packet[i];
				var pos_x = x;
				var pos_y = y + shifts[x];

				if (orientation == Orientation.VERTICAL) {
					set_pixel(height-pos_x-1, pos_y, p, p, p);
					continue;
				}

				set_pixel(pos_x, pos_y, p, p, p);
			}
		}

		set_from_pixbuf(pixbuf);
	}

	public void backward(int dec) {
		var min = 0;
		position = position-dec > min ? position-dec : min;
		read();
		render();
	}

	public void forward(int inc) {
		var max = sonar_log.index.size(channel)-width;
		position = position+inc < max ? position+inc : max;
		read();
		render();
	}
}

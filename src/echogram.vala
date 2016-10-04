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

public class Echogram : Gtk.Window {
	public SonarLog sonar_log;

	public View view1;
	public View view2;
	public View view3;

	public Echogram() {
		this.title = "echogram";
		this.destroy.connect(Gtk.main_quit);

		var file = File.new_for_path("test.sl2");

		if (!file.query_exists()) {
			stderr.printf("File '%s' doesn't exist.\n", file.get_path());
		}

		//try {
			sonar_log = new SonarLog(file);

			sonar_log.header.read();
			if (!sonar_log.header.valid) {
				stderr.printf("File '%s' unknown format.\n", file.get_path());
			}

			sonar_log.index.read();

			// var ping = sonar_log.ping(Channel.PRIMARY, 0);
			// data = ping.packet;

			// for (int position = 0; position < (int)sonar_log.index.map[Channel.PRIMARY].size; position++) {
			// 	var ping = sonar_log.ping(Channel.PRIMARY, position);
			// 	stdout.printf("%s\n", (string)ping.packet);
			// }
		// }
		// catch (IOError e) {
		// 	stderr.printf("IOError: %s\n", e.message);
		// }
		// catch (Error e) {
		// 	stderr.printf("Error: %s\n", e.message);
		// }

		//view = new View(sonar_log, Channel.PRIMARY, 1000, 700, Orientation.HORIZONTAL);
		//view = new View(sonar_log, Channel.SIDESCAN, 1300, 700, Orientation.VERTICAL);
		//view = new View(sonar_log, Channel.DOWNSCAN, 1000, 600, Orientation.HORIZONTAL);
		//view.read();
		//view.render();

		view1 = new View(sonar_log, Channel.PRIMARY, 400, 300, Orientation.HORIZONTAL);
		view2 = new View(sonar_log, Channel.DOWNSCAN, 400, 300, Orientation.HORIZONTAL);
		view3 = new View(sonar_log, Channel.SIDESCAN, 600, 400, Orientation.VERTICAL);

		var hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 5);

		var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 5);

		vbox.pack_start(view1, true, true, 0);
		vbox.pack_start(view2, true, true, 0);

		hbox.pack_start(vbox, true, true, 0);
		hbox.pack_start(view3, true, true, 0);

		view1.read();
		view1.render();
		view2.read();
		view2.render();
		view3.read();
		view3.render();

		this.add(hbox);
	}

	protected override bool key_press_event (Gdk.EventKey event) {
		var key = Gdk.keyval_name(event.keyval);
		if (key == "Right") {
			view1.forward(50);
			view2.forward(50);
			view3.forward(50);
		}
		if (key == "Left") {
			view1.backward(50);
			view2.backward(50);
			view3.backward(50);
		}
		stdout.printf("|%s|\n", key);
		return true;
	}

	public static int main(string[] args) {
		Gtk.init(ref args);

		var window = new Echogram();
		window.show_all();

		Gtk.main();

		return 0;
	}
}


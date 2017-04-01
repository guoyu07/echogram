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

public class Header : Object {
	private DataInputStream data_stream;

	private const uint8 size = 8;

	private uint8[] header;

	public Header(DataInputStream data_stream) {
		this.data_stream = data_stream;

		header = new uint8[Header.size];
	}

	public void read() throws IOError, Error {
		data_stream.seek(0, SeekType.SET);

		data_stream.read(header);
	}

	public bool valid {
		get {
			return header[0] == 2;
		}
	}
}

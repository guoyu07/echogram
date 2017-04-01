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

public class SonarLog : Object {
	private File file;

	private FileInputStream file_stream;

	private DataInputStream data_stream;

	public Header header;

	public Index index;

	public SonarLog(File file) throws Error {
		this.file = file;

		file_stream = file.read();

		data_stream = new DataInputStream(this.file_stream);
		data_stream.set_byte_order(DataStreamByteOrder.LITTLE_ENDIAN);

		header = new Header(data_stream);

		var file_info = file.query_info("*", FileQueryInfoFlags.NONE);
		var file_size = file_info.get_size();
		index = new Index(data_stream, file_size);
	}

	public Ping ping(Channel channel, int position) throws IOError, Error {
		return new Ping(data_stream, index, channel, position);
	}
}

-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2-beta1
-- PostgreSQL version: 11.0
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: fossfiber | type: DATABASE --
-- -- DROP DATABASE IF EXISTS fossfiber;
-- CREATE DATABASE fossfiber;
-- -- ddl-end --
-- COMMENT ON DATABASE fossfiber IS 'Database Schema and format Licensed under the AGPL v 3.0, available at https://www.gnu.org/licenses/agpl-3.0-standalone.html . Note that for the purposes of this project, use over a network by a employer''s employees constitues distribution and causes the requirements for provision of source code for any modifications to apply. The author of this project specifically requires that the distribution of changed source be also made available to the public at large, minus any keys, passwords, or other access credentials that may be embedded in the source code. Making source code available in a publicly accessible github repository qualifies to meet this requirement.';
-- -- ddl-end --
-- 

-- object: postgis | type: EXTENSION --
-- DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis
;
-- ddl-end --

-- object: public.pole_attachment | type: TABLE --
-- DROP TABLE IF EXISTS public.pole_attachment CASCADE;
CREATE TABLE public.pole_attachment (
	id serial NOT NULL,
	height_meters real,
	utility_pole_id integer NOT NULL,
	f_permitting_requested bool DEFAULT false,
	f_permitting_granted bool NOT NULL DEFAULT false,
	built timestamptz DEFAULT NOW(),
	njuns_remarks text,
	njuns_ticket text,
	njuns_asset_uuid uuid,
	CONSTRAINT pole_attachement_id_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.pole_attachment OWNER TO postgres;
-- ddl-end --

-- object: public.strand_line | type: TABLE --
-- DROP TABLE IF EXISTS public.strand_line CASCADE;
CREATE TABLE public.strand_line (
	id serial NOT NULL,
	built timestamptz DEFAULT NOW(),
	CONSTRAINT strand_line_id_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.strand_line OWNER TO postgres;
-- ddl-end --

-- object: public.strand_guy_wire | type: TABLE --
-- DROP TABLE IF EXISTS public.strand_guy_wire CASCADE;
CREATE TABLE public.strand_guy_wire (
	id serial NOT NULL,
	sidewalk_standoff_pipe bool DEFAULT false,
	pole_attachment_id integer NOT NULL,
	azimuth_from_pole smallint,
	built timestamptz DEFAULT NOW(),
	CONSTRAINT azimuth_is_degrees CHECK (azimuth_from_pole >= 0 and azimuth_from_pole < 360),
	CONSTRAINT strand_guy_wire_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.strand_guy_wire OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_enclosure | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_enclosure CASCADE;
CREATE TABLE public.fiber_enclosure (
	id serial NOT NULL,
	longlat geography(POINT, 4326),
	manufacturer_name text,
	enclosure_model text,
	built timestamptz DEFAULT NOW(),
	CONSTRAINT fiber_enclosure_id PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.fiber_enclosure OWNER TO postgres;
-- ddl-end --

-- object: public.optical_splitter | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter CASCADE;
CREATE TABLE public.optical_splitter (
	id serial NOT NULL,
	inputs_count smallint NOT NULL DEFAULT 1,
	outputs_count smallint,
	splitter_type_id smallint DEFAULT 1,
	splitter_style_id smallint,
	containing_fiber_enclosure integer,
	built timestamptz DEFAULT NOW(),
	CONSTRAINT optical_splitter_id_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.optical_splitter OWNER TO postgres;
-- ddl-end --

-- object: public.enclosure_port | type: TABLE --
-- DROP TABLE IF EXISTS public.enclosure_port CASCADE;
CREATE TABLE public.enclosure_port (
	id serial NOT NULL,
	fiber_enclosure_id integer NOT NULL,
	port_label text,
	fiber_connection_id integer NOT NULL,
	CONSTRAINT enclosure_port_id_pk PRIMARY KEY (id),
	CONSTRAINT enclosure_port_uniquely_owns_inherited_fiber_connection UNIQUE (fiber_connection_id)

);
-- ddl-end --
COMMENT ON TABLE public.enclosure_port IS 'Inherited fiber_connection.fiber_end_a_id is considered the in side of the enclosure, inherited fiber_connection.fiber_end_b_id is considered the out side of the enclosure. This is by convention and not enforced by checks.';
-- ddl-end --
ALTER TABLE public.enclosure_port OWNER TO postgres;
-- ddl-end --

-- object: public.optical_connector_types | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_connector_types CASCADE;
CREATE TABLE public.optical_connector_types (
	id smallserial NOT NULL,
	name text NOT NULL,
	gender char DEFAULT 'M',
	CONSTRAINT optical_connector_types_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.optical_connector_types OWNER TO postgres;
-- ddl-end --

INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'SC/APC', E'M');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'SC/APC', E'F');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'SC/UPC', E'M');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'SC/UPC', E'F');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'LC/UPC', E'M');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'LC/UPC', E'F');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'LC/APC', E'M');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'LC/APC', E'F');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'fusion splice', E'F');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'mechanical splice', E'F');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'OptiTap SC/APC Port', E'F');
-- ddl-end --
INSERT INTO public.optical_connector_types (id, name, gender) VALUES (DEFAULT, E'OptiTap SC/APC Plug', E'M');
-- ddl-end --

-- object: public.fiber_cable | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_cable CASCADE;
CREATE TABLE public.fiber_cable (
	id serial NOT NULL,
	cable_start_length_measure real,
	cable_end_length_measure real,
	length_units smallint DEFAULT 1,
	fiber_groups_depth smallint DEFAULT 1,
	f_armored bool DEFAULT false,
	f_outdoor bool DEFAULT true,
	fiber_groups_top_level_count smallint DEFAULT 1,
	built timestamptz DEFAULT NOW(),
	CONSTRAINT fiber_cable_id_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.fiber_cable.fiber_groups_top_level_count IS 'Number/count of the fiber groups at the top level of the cable. For example, on a 48 count loose tube cable, this would be 4 for 4 buffer tubes. This is the same idea as the "subgroup_count" column in fiber_groups table, but it tells how many for the top level, since each level below the top would be stored in the "parent" fiber_group row.';
-- ddl-end --
ALTER TABLE public.fiber_cable OWNER TO postgres;
-- ddl-end --

-- object: public.length_units | type: TABLE --
-- DROP TABLE IF EXISTS public.length_units CASCADE;
CREATE TABLE public.length_units (
	id smallserial NOT NULL,
	unit_name text NOT NULL,
	unit_shortsymbol text NOT NULL,
	CONSTRAINT length_units_id_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.length_units OWNER TO postgres;
-- ddl-end --

INSERT INTO public.length_units (id, unit_name, unit_shortsymbol) VALUES (E'1', E'feet', E'ft');
-- ddl-end --
INSERT INTO public.length_units (id, unit_name, unit_shortsymbol) VALUES (E'2', E'meters', E'm');
-- ddl-end --

-- object: public.fiber_group_types | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_group_types CASCADE;
CREATE TABLE public.fiber_group_types (
	id smallserial NOT NULL,
	shortname text DEFAULT 'buffer tube',
	CONSTRAINT fiber_group_types_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.fiber_group_types OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_group | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_group CASCADE;
CREATE TABLE public.fiber_group (
	id smallserial NOT NULL,
	subgroup_count smallint DEFAULT 12,
	group_type_id smallint NOT NULL,
	level smallint DEFAULT 0,
	fiber_cable_id integer NOT NULL,
	CONSTRAINT fiber_group_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.fiber_group IS 'Describes the structure/fiber groupings in a cable. A massive cable with ';
-- ddl-end --
COMMENT ON COLUMN public.fiber_group.subgroup_count IS 'Number of subgroups or fibers in each of the groups this row represents. For example, 12 for 12 fibers in a buffer tube. Or, in a 96 count ribbon cable with a central tube, with this row being for the central tube, 8 for the 8 ribbons inside the central tube.';
-- ddl-end --
ALTER TABLE public.fiber_group OWNER TO postgres;
-- ddl-end --

-- object: public.fiber | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber CASCADE;
CREATE TABLE public.fiber (
	id serial NOT NULL,
	cable_id integer NOT NULL,
	CONSTRAINT fiber_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.fiber IS 'TODO: should this be one fiber for the whole length of the cable, or multiple rows in this table for when midspans happen in a cable?';
-- ddl-end --
ALTER TABLE public.fiber OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_identifier_index | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_identifier_index CASCADE;
CREATE TABLE public.fiber_identifier_index (
	id serial NOT NULL,
	group_index smallint DEFAULT 1,
	group_level smallint DEFAULT 0,
	fiber_id integer NOT NULL,
	CONSTRAINT fiber_identifier_index_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.fiber_identifier_index IS 'Used to store the information about which fiber in a cable. Not columns on the fiber table because of the potential for varying numbers/levels of grouping in a cable. For example, on the huge fiber count cable, you could have multiple "buffer tubes" with multiple ribbons inside, and inside each ribbon multiple fibers.';
-- ddl-end --
ALTER TABLE public.fiber_identifier_index OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_cable_slack_coil | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_cable_slack_coil CASCADE;
CREATE TABLE public.fiber_cable_slack_coil (
	id serial NOT NULL,
	fiber_cable_id integer NOT NULL,
	in_meterage real,
	latlong_root geography(POINT, 4326),
	latlong_free_end geography(POINT, 4326),
	out_meterage real,
	cable_sort real,
	CONSTRAINT fiber_cable_slack_coil_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.fiber_cable_slack_coil.in_meterage IS 'length in meters of where the slack coil is along the cable. Where the slack loop "starts" when going down the cable in ascending measurement numbers.';
-- ddl-end --
COMMENT ON COLUMN public.fiber_cable_slack_coil.cable_sort IS 'Where this item falls along the linear geography of its related cable. Lower priority alternative to meterage, for cases where meterage is not set.';
-- ddl-end --
ALTER TABLE public.fiber_cable_slack_coil OWNER TO postgres;
-- ddl-end --

-- object: public.optical_splitter_types | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter_types CASCADE;
CREATE TABLE public.optical_splitter_types (
	id smallserial NOT NULL,
	type_label text NOT NULL,
	symmetric_outputs bool NOT NULL DEFAULT true,
	CONSTRAINT optical_splitter_types_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.optical_splitter_types.symmetric_outputs IS 'Whether this splitter has a (theoretical - not the factory test numbers) even output power for the outputs.';
-- ddl-end --
ALTER TABLE public.optical_splitter_types OWNER TO postgres;
-- ddl-end --

INSERT INTO public.optical_splitter_types (id, type_label, symmetric_outputs) VALUES (E'1', E'PLC', E'true');
-- ddl-end --
INSERT INTO public.optical_splitter_types (id, type_label, symmetric_outputs) VALUES (E'2', E'FBT, symmetric', E'true');
-- ddl-end --
INSERT INTO public.optical_splitter_types (id, type_label, symmetric_outputs) VALUES (E'3', E'FBT, asymmetric', E'false');
-- ddl-end --

-- object: public.optical_splitter_styles | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter_styles CASCADE;
CREATE TABLE public.optical_splitter_styles (
	id smallserial NOT NULL,
	style_label text NOT NULL,
	CONSTRAINT optical_splitter_styles_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.optical_splitter_styles OWNER TO postgres;
-- ddl-end --

INSERT INTO public.optical_splitter_styles (id, style_label) VALUES (E'1', E'steel tube');
-- ddl-end --
INSERT INTO public.optical_splitter_styles (id, style_label) VALUES (E'2', E'ABS case');
-- ddl-end --
INSERT INTO public.optical_splitter_styles (id, style_label) VALUES (E'3', E'LGX box');
-- ddl-end --
INSERT INTO public.optical_splitter_styles (id, style_label) VALUES (E'4', E'Rack mount box');
-- ddl-end --

-- object: public.optical_splitter_output | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter_output CASCADE;
CREATE TABLE public.optical_splitter_output (
	id serial NOT NULL,
	power_drop real DEFAULT NULL,
	output_label text,
	optical_splitter_id integer NOT NULL,
	fiber_end_id integer NOT NULL,
	CONSTRAINT optical_splitter_output_pk PRIMARY KEY (id),
	CONSTRAINT optical_splitter_output_uniquely_owns_inherited_fiber_end UNIQUE (fiber_end_id)

);
-- ddl-end --
COMMENT ON COLUMN public.optical_splitter_output.power_drop IS 'NULL for theoretically symmetric output (calulate drop from the related  optical_splitter.outputs_count). Used for uneven input/output splits. Note that this is the theoretical drop that you would get modeling (for multi in x multi out splitters) the splitter as 2 back to back single input splitters with inputs tied together).';
-- ddl-end --
ALTER TABLE public.optical_splitter_output OWNER TO postgres;
-- ddl-end --

-- object: public.optical_splitter_input | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter_input CASCADE;
CREATE TABLE public.optical_splitter_input (
	id serial NOT NULL,
	power_drop real DEFAULT NULL,
	input_label text,
	optical_splitter_id integer NOT NULL,
	fiber_end_id integer NOT NULL,
	CONSTRAINT optical_splitter_input_pk PRIMARY KEY (id),
	CONSTRAINT optical_splitter_input_uniquely_owns_inherited_fiber_end UNIQUE (fiber_end_id)

);
-- ddl-end --
COMMENT ON COLUMN public.optical_splitter_input.power_drop IS 'NULL for theoretically symmetric input (calulate drop from the related  optical_splitter.inputs_count). Used for uneven input/output splits. Note that this is the theoretical drop that you would get modeling (for multi in x multi out splitters) the splitter as 2 back to back single input splitters with inputs tied together).';
-- ddl-end --
ALTER TABLE public.optical_splitter_input OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_end | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_end CASCADE;
CREATE TABLE public.fiber_end (
	id serial NOT NULL,
	optical_connector_type_id smallint,
	CONSTRAINT fiber_end_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.fiber_end.optical_connector_type_id IS 'If the end of this fiber does not have factory installed connector, this column is NULL.';
-- ddl-end --
ALTER TABLE public.fiber_end OWNER TO postgres;
-- ddl-end --

-- object: public.cable_fiber_end | type: TABLE --
-- DROP TABLE IF EXISTS public.cable_fiber_end CASCADE;
CREATE TABLE public.cable_fiber_end (
	id serial NOT NULL,
	fiber_id integer NOT NULL,
	fiber_end_id integer NOT NULL,
	fiber_cable_segment_end_id integer NOT NULL,
	CONSTRAINT "cable_fiber_end?_pk" PRIMARY KEY (id),
	CONSTRAINT cable_fiber_end_uniquely_owns_inherited_fiber_end UNIQUE (fiber_end_id)

);
-- ddl-end --
ALTER TABLE public.cable_fiber_end OWNER TO postgres;
-- ddl-end --

-- object: public.utility_pole | type: TABLE --
-- DROP TABLE IF EXISTS public.utility_pole CASCADE;
CREATE TABLE public.utility_pole (
	id serial NOT NULL,
	pole_owner text,
	pole_owner_primary_label text,
	latlong geometry(POINT, 4326) NOT NULL,
	CONSTRAINT utility_pole_id_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.utility_pole OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_connection | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_connection CASCADE;
CREATE TABLE public.fiber_connection (
	id serial NOT NULL,
	connected_fiber_end_a_id integer,
	connected_fiber_end_b_id integer,
	a_optical_connector_type_id smallint,
	b_optical_connector_type_id smallint,
	built timestamptz DEFAULT NOW(),
	CONSTRAINT fiber_end_cant_connect_to_itself CHECK (connected_fiber_end_a_id <> connected_fiber_end_b_id),
	CONSTRAINT fiber_connection_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.fiber_connection OWNER TO postgres;
-- ddl-end --

-- object: public.v_fiber_connection_sym | type: VIEW --
-- DROP VIEW IF EXISTS public.v_fiber_connection_sym CASCADE;
CREATE VIEW public.v_fiber_connection_sym
AS 

select fiber_connection.id, fiber_connection.connected_fiber_end_a_id, fiber_connection.connected_fiber_end_b_id from fiber_connection
union all
select fiber_connection.id, fiber_connection.connected_fiber_end_b_id, fiber_connection.connected_fiber_end_a_id from fiber_connection;
-- ddl-end --
COMMENT ON VIEW public.v_fiber_connection_sym IS 'View to show fiber connections in a way that it doesn''t matter what order you put the fibers in.';
-- ddl-end --
ALTER VIEW public.v_fiber_connection_sym OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_splice | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_splice CASCADE;
CREATE TABLE public.fiber_splice (
	id serial NOT NULL,
	fiber_connection_id integer NOT NULL,
	fusion bool DEFAULT true,
	estimated_loss real DEFAULT 0.3,
	CONSTRAINT fiber_splice_pk PRIMARY KEY (id),
	CONSTRAINT fiber_plice_uniquely_owns_inherited_fiber_connection UNIQUE (fiber_connection_id)

);
-- ddl-end --
ALTER TABLE public.fiber_splice OWNER TO postgres;
-- ddl-end --

-- object: public.underground_vault | type: TABLE --
-- DROP TABLE IF EXISTS public.underground_vault CASCADE;
CREATE TABLE public.underground_vault (
	id serial NOT NULL,
	latlong geometry(POINT, 4326) NOT NULL,
	depth real,
	width real,
	length real,
	length_units_id smallint,
	manufacturer_name text,
	vault_model text,
	built timestamptz DEFAULT NOW(),
	CONSTRAINT underground_vault_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.underground_vault OWNER TO postgres;
-- ddl-end --

-- object: public.conduit | type: TABLE --
-- DROP TABLE IF EXISTS public.conduit CASCADE;
CREATE TABLE public.conduit (
	id serial NOT NULL,
	length real,
	conduit_route geometry(LINESTRING, 4326),
	conduit_type_id integer NOT NULL,
	built timestamptz DEFAULT NOW(),
	underground boolean DEFAULT true,
	length_units_id smallint,
	CONSTRAINT underground_conduit_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.conduit.underground IS 'If this is a buried conduit.';
-- ddl-end --
ALTER TABLE public.conduit OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_cable_slack_coil_located_in_underground_vault | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_cable_slack_coil_located_in_underground_vault CASCADE;
CREATE TABLE public.fiber_cable_slack_coil_located_in_underground_vault (
	id serial NOT NULL,
	underground_vault_id integer NOT NULL,
	fiber_cable_slack_loop_id integer NOT NULL,
	CONSTRAINT fiber_cable_slack_coil_located_in_underground_vault_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.fiber_cable_slack_coil_located_in_underground_vault OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_enclosure_located_in_underground_vault | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_enclosure_located_in_underground_vault CASCADE;
CREATE TABLE public.fiber_enclosure_located_in_underground_vault (
	id serial NOT NULL,
	fiber_enclosure_id integer NOT NULL,
	underground_vault_id integer NOT NULL,
	CONSTRAINT fiber_enclosure_located_in_underground_vault_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.fiber_enclosure_located_in_underground_vault OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_end_meta_instance_inheritance | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_end_meta_instance_inheritance CASCADE;
CREATE TABLE public.fiber_end_meta_instance_inheritance (
	fiber_end_id integer NOT NULL,
	inheriting_table_name text NOT NULL,
	inheriting_table_fk_column_name text NOT NULL,
	CONSTRAINT fiber_end_meta_instance_inheritance_pk PRIMARY KEY (fiber_end_id,inheriting_table_name,inheriting_table_fk_column_name)

);
-- ddl-end --
COMMENT ON TABLE public.fiber_end_meta_instance_inheritance IS 'Tracks specialization/inheritance of fiber_ends and what tables should be checked/joined for references. Putting an entry in this table means that a inner join between fiber_end.id and {inheriting_table_name}.{inheriting_table_fk_column_name) should return a result.';
-- ddl-end --
ALTER TABLE public.fiber_end_meta_instance_inheritance OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_connection_meta_instance_inheritance | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_connection_meta_instance_inheritance CASCADE;
CREATE TABLE public.fiber_connection_meta_instance_inheritance (
	fiber_connection_id integer NOT NULL,
	inheriting_table_name text NOT NULL,
	inheriting_table_fk_column_name text NOT NULL,
	CONSTRAINT fiber_connection_meta_instance_inheritance_pk PRIMARY KEY (fiber_connection_id,inheriting_table_name,inheriting_table_fk_column_name)

);
-- ddl-end --
COMMENT ON TABLE public.fiber_connection_meta_instance_inheritance IS 'Tracks specialization/inheritance of fiber_connections and what tables should be checked/joined for references. Putting an entry in this table means that a inner join between fiber_connection.id and {inheriting_table_name}.{inheriting_table_fk_column_name) should return a result.';
-- ddl-end --
ALTER TABLE public.fiber_connection_meta_instance_inheritance OWNER TO postgres;
-- ddl-end --

-- object: public.building | type: TABLE --
-- DROP TABLE IF EXISTS public.building CASCADE;
CREATE TABLE public.building (
	id serial NOT NULL,
	building_location geometry(GEOMETRY, 4326) NOT NULL,
	CONSTRAINT building_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.building OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_enclosure_template | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_enclosure_template CASCADE;
CREATE TABLE public.fiber_enclosure_template (
	id serial NOT NULL,
	manufacturer_name text,
	enclosure_model text,
	template_name text NOT NULL,
	CONSTRAINT fiber_enclosure_template_id PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.fiber_enclosure_template IS 'Template with predefined values for fiber_enclosures and related tables.';
-- ddl-end --
ALTER TABLE public.fiber_enclosure_template OWNER TO postgres;
-- ddl-end --

INSERT INTO public.fiber_enclosure_template (id, manufacturer_name, enclosure_model, template_name) VALUES (E'1', E'Commscope', E'OTE-300', E'OTE-300');
-- ddl-end --

-- object: public.enclosure_port_template | type: TABLE --
-- DROP TABLE IF EXISTS public.enclosure_port_template CASCADE;
CREATE TABLE public.enclosure_port_template (
	id serial NOT NULL,
	fiber_enclosure_template_id integer NOT NULL,
	port_label text,
	fiber_connection_template_id integer NOT NULL,
	CONSTRAINT enclosure_port_template_id_pk PRIMARY KEY (id),
	CONSTRAINT enclosure_port_uniquely_owns_inherited_fiber_connection_templat UNIQUE (fiber_connection_template_id)

);
-- ddl-end --
COMMENT ON TABLE public.enclosure_port_template IS 'Inherited fiber_connection.fiber_end_a_id is considered the in side of the enclosure, inherited fiber_connection.fiber_end_b_id is considered the out side of the enclosure. This is by convention and not enforced by checks.';
-- ddl-end --
ALTER TABLE public.enclosure_port_template OWNER TO postgres;
-- ddl-end --

INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'1', E'1', DEFAULT, E'1');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'2', E'1', DEFAULT, E'2');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'3', E'1', DEFAULT, E'3');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'4', E'1', DEFAULT, E'4');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'5', E'1', DEFAULT, E'5');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'6', E'1', DEFAULT, E'6');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'7', E'1', DEFAULT, E'7');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'8', E'1', DEFAULT, E'8');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'9', E'1', DEFAULT, E'9');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'10', E'1', DEFAULT, E'10');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'11', E'1', DEFAULT, E'11');
-- ddl-end --
INSERT INTO public.enclosure_port_template (id, fiber_enclosure_template_id, port_label, fiber_connection_template_id) VALUES (E'12', E'1', DEFAULT, E'12');
-- ddl-end --

-- object: public.fiber_connection_enclosure_port_template | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_connection_enclosure_port_template CASCADE;
CREATE TABLE public.fiber_connection_enclosure_port_template (
	id serial NOT NULL,
	a_optical_connector_type_id smallint,
	b_optical_connector_type_id smallint,
	CONSTRAINT fiber_connection_enclosure_port_template_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.fiber_connection_enclosure_port_template OWNER TO postgres;
-- ddl-end --

INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'1', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'2', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'3', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'4', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'5', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'6', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'7', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'8', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'9', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'10', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'11', E'11', DEFAULT);
-- ddl-end --
INSERT INTO public.fiber_connection_enclosure_port_template (id, a_optical_connector_type_id, b_optical_connector_type_id) VALUES (E'12', E'11', DEFAULT);
-- ddl-end --

-- object: public.fiber_cable_template | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_cable_template CASCADE;
CREATE TABLE public.fiber_cable_template (
	id serial NOT NULL,
	length_units smallint DEFAULT 1,
	fiber_groups_depth smallint DEFAULT 1,
	f_armored bool DEFAULT false,
	f_outdoor bool DEFAULT true,
	fiber_groups_top_level_count smallint DEFAULT 1,
	template_name text NOT NULL,
	CONSTRAINT fiber_cable_template_id_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.fiber_cable_template IS 'Template with predefined values for fiber_cables and related tables.
';
-- ddl-end --
COMMENT ON COLUMN public.fiber_cable_template.fiber_groups_top_level_count IS 'Number/count of the fiber groups at the top level of the cable. For example, on a 48 count loose tube cable, this would be 4 for 4 buffer tubes. This is the same idea as the "subgroup_count" column in fiber_groups table, but it tells how many for the top level, since each level below the top would be stored in the "parent" fiber_group row.';
-- ddl-end --
ALTER TABLE public.fiber_cable_template OWNER TO postgres;
-- ddl-end --

-- object: public.fiber_group_template | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_group_template CASCADE;
CREATE TABLE public.fiber_group_template (
	id smallserial NOT NULL,
	subgroup_count smallint DEFAULT 12,
	group_type_id smallint NOT NULL,
	level smallint DEFAULT 0,
	fiber_cable_template_id integer NOT NULL,
	CONSTRAINT fiber_group_template_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.fiber_group_template IS 'Describes the structure/fiber groupings in a cable. A massive cable with ';
-- ddl-end --
COMMENT ON COLUMN public.fiber_group_template.subgroup_count IS 'Number of subgroups or fibers in each of the groups this row represents. For example, 12 for 12 fibers in a buffer tube. Or, in a 96 count ribbon cable with a central tube, with this row being for the central tube, 8 for the 8 ribbons inside the central tube.';
-- ddl-end --
ALTER TABLE public.fiber_group_template OWNER TO postgres;
-- ddl-end --

-- object: public.optical_splitter_template | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter_template CASCADE;
CREATE TABLE public.optical_splitter_template (
	id serial NOT NULL,
	inputs_count smallint NOT NULL DEFAULT 1,
	outputs_count smallint,
	splitter_type_id smallint DEFAULT 1,
	splitter_style_id smallint,
	template_name text NOT NULL,
	CONSTRAINT optical_splitter_template_id_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.optical_splitter_template IS 'Template with predefined values for optical_splitters and related tables.';
-- ddl-end --
ALTER TABLE public.optical_splitter_template OWNER TO postgres;
-- ddl-end --

-- object: public.optical_splitter_output_template | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter_output_template CASCADE;
CREATE TABLE public.optical_splitter_output_template (
	id serial NOT NULL,
	power_drop real DEFAULT NULL,
	output_label text,
	optical_splitter_id integer NOT NULL,
	fiber_end_id integer NOT NULL,
	CONSTRAINT optical_splitter_output_template_pk PRIMARY KEY (id),
	CONSTRAINT optical_splitter_output_tplt_uniquely_owns_inherited_fiber_end UNIQUE (fiber_end_id)

);
-- ddl-end --
COMMENT ON COLUMN public.optical_splitter_output_template.power_drop IS 'NULL for theoretically symmetric output (calulate drop from the related  optical_splitter.outputs_count). Used for uneven input/output splits. Note that this is the theoretical drop that you would get modeling (for multi in x multi out splitters) the splitter as 2 back to back single input splitters with inputs tied together).';
-- ddl-end --
ALTER TABLE public.optical_splitter_output_template OWNER TO postgres;
-- ddl-end --

-- object: public.optical_splitter_input_template | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter_input_template CASCADE;
CREATE TABLE public.optical_splitter_input_template (
	id serial NOT NULL,
	power_drop real DEFAULT NULL,
	input_label text,
	optical_splitter_template_id integer NOT NULL,
	fiber_end_id integer NOT NULL,
	CONSTRAINT optical_splitter_input_template_pk PRIMARY KEY (id),
	CONSTRAINT optical_splitter_input_tplt_uniquely_owns_inherited_fiber_end UNIQUE (fiber_end_id)

);
-- ddl-end --
COMMENT ON COLUMN public.optical_splitter_input_template.power_drop IS 'NULL for theoretically symmetric input (calulate drop from the related  optical_splitter.inputs_count). Used for uneven input/output splits. Note that this is the theoretical drop that you would get modeling (for multi in x multi out splitters) the splitter as 2 back to back single input splitters with inputs tied together).';
-- ddl-end --
ALTER TABLE public.optical_splitter_input_template OWNER TO postgres;
-- ddl-end --

-- object: public.optical_splitter_template_fiber_end | type: TABLE --
-- DROP TABLE IF EXISTS public.optical_splitter_template_fiber_end CASCADE;
CREATE TABLE public.optical_splitter_template_fiber_end (
	id serial NOT NULL,
	optical_connector_type_id smallint,
	CONSTRAINT optical_splitter_template_fiber_end_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.optical_splitter_template_fiber_end.optical_connector_type_id IS 'If the end of this fiber does not have factory installed connector, this column is NULL.';
-- ddl-end --
ALTER TABLE public.optical_splitter_template_fiber_end OWNER TO postgres;
-- ddl-end --

-- object: public.underground_vault_template | type: TABLE --
-- DROP TABLE IF EXISTS public.underground_vault_template CASCADE;
CREATE TABLE public.underground_vault_template (
	id serial NOT NULL,
	depth real,
	width real,
	length real,
	length_units_id smallint,
	manufacturer_name text,
	vault_model text,
	template_name text NOT NULL,
	CONSTRAINT underground_vault_template_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.underground_vault_template IS 'Template with predefined values for underground_vaults and related tables.';
-- ddl-end --
ALTER TABLE public.underground_vault_template OWNER TO postgres;
-- ddl-end --

-- object: public.conduit_type | type: TABLE --
-- DROP TABLE IF EXISTS public.conduit_type CASCADE;
CREATE TABLE public.conduit_type (
	id serial NOT NULL,
	diameter real,
	diameter_units smallint,
	length_units smallint,
	conduit_type_name text NOT NULL,
	CONSTRAINT conduit_type_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.conduit_type OWNER TO postgres;
-- ddl-end --

-- object: public.history_text | type: TABLE --
-- DROP TABLE IF EXISTS public.history_text CASCADE;
CREATE TABLE public.history_text (
	id serial NOT NULL,
	table_name text NOT NULL,
	column_name text NOT NULL,
	change_date timestamptz NOT NULL DEFAULT NOW(),
	username text,
	before_value text,
	after_value text,
	CONSTRAINT history_text_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_text OWNER TO postgres;
-- ddl-end --

-- object: history_text_idx_table_column_date | type: INDEX --
-- DROP INDEX IF EXISTS public.history_text_idx_table_column_date CASCADE;
CREATE INDEX history_text_idx_table_column_date ON public.history_text
	USING btree
	(
	  table_name ASC NULLS LAST,
	  column_name ASC NULLS LAST,
	  change_date ASC NULLS LAST
	);
-- ddl-end --

-- object: public.history_integer | type: TABLE --
-- DROP TABLE IF EXISTS public.history_integer CASCADE;
CREATE TABLE public.history_integer (
	id serial NOT NULL,
	table_name text NOT NULL,
	column_name text NOT NULL,
	change_date timestamptz NOT NULL DEFAULT NOW(),
	username text,
	before_value integer,
	after_value integer,
	CONSTRAINT history_integer_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_integer OWNER TO postgres;
-- ddl-end --

-- object: history_integer_idx_table_column_date | type: INDEX --
-- DROP INDEX IF EXISTS public.history_integer_idx_table_column_date CASCADE;
CREATE INDEX history_integer_idx_table_column_date ON public.history_integer
	USING btree
	(
	  table_name ASC NULLS LAST,
	  column_name ASC NULLS LAST,
	  change_date ASC NULLS LAST
	);
-- ddl-end --

-- object: public.history_real | type: TABLE --
-- DROP TABLE IF EXISTS public.history_real CASCADE;
CREATE TABLE public.history_real (
	id serial NOT NULL,
	table_name text NOT NULL,
	column_name text NOT NULL,
	change_date timestamptz NOT NULL DEFAULT NOW(),
	username text,
	before_value real,
	after_value real,
	CONSTRAINT history_real_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_real OWNER TO postgres;
-- ddl-end --

-- object: history_real_idx_table_column_date | type: INDEX --
-- DROP INDEX IF EXISTS public.history_real_idx_table_column_date CASCADE;
CREATE INDEX history_real_idx_table_column_date ON public.history_real
	USING btree
	(
	  table_name ASC NULLS LAST,
	  column_name ASC NULLS LAST,
	  change_date ASC NULLS LAST
	);
-- ddl-end --

-- object: public.history_smallint | type: TABLE --
-- DROP TABLE IF EXISTS public.history_smallint CASCADE;
CREATE TABLE public.history_smallint (
	id serial NOT NULL,
	table_name text NOT NULL,
	column_name text NOT NULL,
	change_date timestamptz NOT NULL DEFAULT NOW(),
	username text,
	before_value smallint,
	after_value smallint,
	CONSTRAINT history_smallint_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_smallint OWNER TO postgres;
-- ddl-end --

-- object: history_smallint_idx_table_column_date | type: INDEX --
-- DROP INDEX IF EXISTS public.history_smallint_idx_table_column_date CASCADE;
CREATE INDEX history_smallint_idx_table_column_date ON public.history_smallint
	USING btree
	(
	  table_name ASC NULLS LAST,
	  column_name ASC NULLS LAST,
	  change_date ASC NULLS LAST
	);
-- ddl-end --

-- object: public.history_bool | type: TABLE --
-- DROP TABLE IF EXISTS public.history_bool CASCADE;
CREATE TABLE public.history_bool (
	id serial NOT NULL,
	table_name text NOT NULL,
	column_name text NOT NULL,
	change_date timestamptz NOT NULL DEFAULT NOW(),
	username text,
	before_value bool,
	after_value bool,
	CONSTRAINT history_bool_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_bool OWNER TO postgres;
-- ddl-end --

-- object: history_bool_idx_table_column_date | type: INDEX --
-- DROP INDEX IF EXISTS public.history_bool_idx_table_column_date CASCADE;
CREATE INDEX history_bool_idx_table_column_date ON public.history_bool
	USING btree
	(
	  table_name ASC NULLS LAST,
	  column_name ASC NULLS LAST,
	  change_date ASC NULLS LAST
	);
-- ddl-end --

-- object: public.history_geometry_point | type: TABLE --
-- DROP TABLE IF EXISTS public.history_geometry_point CASCADE;
CREATE TABLE public.history_geometry_point (
	id serial NOT NULL,
	table_name text NOT NULL,
	column_name text NOT NULL,
	change_date timestamptz NOT NULL DEFAULT NOW(),
	username text,
	before_value geometry(POINT, 4326),
	after_value geometry(POINT, 4326),
	CONSTRAINT history_geography_point_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_geometry_point OWNER TO postgres;
-- ddl-end --

-- object: history_geography_point_idx_table_column_date | type: INDEX --
-- DROP INDEX IF EXISTS public.history_geography_point_idx_table_column_date CASCADE;
CREATE INDEX history_geography_point_idx_table_column_date ON public.history_geometry_point
	USING btree
	(
	  table_name ASC NULLS LAST,
	  column_name ASC NULLS LAST,
	  change_date ASC NULLS LAST
	);
-- ddl-end --

-- object: public.history_geometry_linestring | type: TABLE --
-- DROP TABLE IF EXISTS public.history_geometry_linestring CASCADE;
CREATE TABLE public.history_geometry_linestring (
	id serial NOT NULL,
	table_name text NOT NULL,
	column_name text NOT NULL,
	change_date timestamptz NOT NULL DEFAULT NOW(),
	username text,
	before_value geometry(LINESTRING, 4326),
	after_value geometry(LINESTRING, 4326),
	CONSTRAINT history_geography_linestring_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_geometry_linestring OWNER TO postgres;
-- ddl-end --

-- object: history_geography_linestring_idx_table_column_date | type: INDEX --
-- DROP INDEX IF EXISTS public.history_geography_linestring_idx_table_column_date CASCADE;
CREATE INDEX history_geography_linestring_idx_table_column_date ON public.history_geometry_linestring
	USING btree
	(
	  table_name ASC NULLS LAST,
	  column_name ASC NULLS LAST,
	  change_date ASC NULLS LAST
	);
-- ddl-end --

-- object: public.history_row_creation | type: TABLE --
-- DROP TABLE IF EXISTS public.history_row_creation CASCADE;
CREATE TABLE public.history_row_creation (
	table_name text NOT NULL,
	table_id integer NOT NULL,
	username text,
	creation timestamptz NOT NULL
);
-- ddl-end --
ALTER TABLE public.history_row_creation OWNER TO postgres;
-- ddl-end --

-- object: public.history_row_deletion | type: TABLE --
-- DROP TABLE IF EXISTS public.history_row_deletion CASCADE;
CREATE TABLE public.history_row_deletion (
	id serial NOT NULL,
	table_name text NOT NULL,
	table_row_id integer NOT NULL,
	username text,
	deletion timestamptz NOT NULL,
	CONSTRAINT history_row_deletion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_row_deletion OWNER TO postgres;
-- ddl-end --

-- object: public.history_text_deletion | type: TABLE --
-- DROP TABLE IF EXISTS public.history_text_deletion CASCADE;
CREATE TABLE public.history_text_deletion (
	id serial NOT NULL,
	history_row_deletion_id integer NOT NULL,
	column_name text NOT NULL,
	before_value text,
	CONSTRAINT history_text_deletion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_text_deletion OWNER TO postgres;
-- ddl-end --

-- object: public.history_integer_deletion | type: TABLE --
-- DROP TABLE IF EXISTS public.history_integer_deletion CASCADE;
CREATE TABLE public.history_integer_deletion (
	id serial NOT NULL,
	history_row_deletion_id integer NOT NULL,
	column_name text NOT NULL,
	before_value integer,
	CONSTRAINT history_integer_deletion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_integer_deletion OWNER TO postgres;
-- ddl-end --

-- object: public.history_real_deletion | type: TABLE --
-- DROP TABLE IF EXISTS public.history_real_deletion CASCADE;
CREATE TABLE public.history_real_deletion (
	id serial NOT NULL,
	history_row_deletion_id integer NOT NULL,
	column_name text NOT NULL,
	before_value real,
	CONSTRAINT history_real_deletion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_real_deletion OWNER TO postgres;
-- ddl-end --

-- object: public.history_smallint_deletion_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS public.history_smallint_deletion_id_seq CASCADE;
CREATE SEQUENCE public.history_smallint_deletion_id_seq
	INCREMENT BY 1
	MINVALUE -2147483648
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: public.history_bool_deletion | type: TABLE --
-- DROP TABLE IF EXISTS public.history_bool_deletion CASCADE;
CREATE TABLE public.history_bool_deletion (
	id serial NOT NULL,
	history_row_deletion_id integer NOT NULL,
	column_name text NOT NULL,
	before_value bool,
	CONSTRAINT history_bool__deletion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_bool_deletion OWNER TO postgres;
-- ddl-end --

-- object: public.history_geometry_point_deletion | type: TABLE --
-- DROP TABLE IF EXISTS public.history_geometry_point_deletion CASCADE;
CREATE TABLE public.history_geometry_point_deletion (
	id serial NOT NULL,
	history_row_deletion_id integer NOT NULL,
	column_name text NOT NULL,
	before_value geometry(POINT, 4326),
	CONSTRAINT history_geography_point_deletion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_geometry_point_deletion OWNER TO postgres;
-- ddl-end --

-- object: public.history_geometry_linestring_deletion | type: TABLE --
-- DROP TABLE IF EXISTS public.history_geometry_linestring_deletion CASCADE;
CREATE TABLE public.history_geometry_linestring_deletion (
	id serial NOT NULL,
	history_row_deletion_id integer NOT NULL,
	column_name text NOT NULL,
	before_value geometry(LINESTRING, 4326),
	CONSTRAINT history_geography_linestring_deletion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_geometry_linestring_deletion OWNER TO postgres;
-- ddl-end --

-- object: public.history_smallint_deletion | type: TABLE --
-- DROP TABLE IF EXISTS public.history_smallint_deletion CASCADE;
CREATE TABLE public.history_smallint_deletion (
	id serial NOT NULL,
	history_row_deletion_id integer NOT NULL,
	column_name text NOT NULL,
	before_value smallint,
	CONSTRAINT history_smallint__deletion_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.history_smallint_deletion OWNER TO postgres;
-- ddl-end --

-- object: history_real_deletion_column_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS public.history_real_deletion_column_name_idx CASCADE;
CREATE INDEX history_real_deletion_column_name_idx ON public.history_real_deletion
	USING btree
	(
	  column_name
	);
-- ddl-end --

-- object: history_integer_deletion_column_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS public.history_integer_deletion_column_name_idx CASCADE;
CREATE INDEX history_integer_deletion_column_name_idx ON public.history_integer_deletion
	USING btree
	(
	  column_name
	);
-- ddl-end --

-- object: history_smallint_deletion_column_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS public.history_smallint_deletion_column_name_idx CASCADE;
CREATE INDEX history_smallint_deletion_column_name_idx ON public.history_smallint_deletion
	USING btree
	(
	  column_name
	);
-- ddl-end --

-- object: history_geometry_linestring_deletion_column_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS public.history_geometry_linestring_deletion_column_name_idx CASCADE;
CREATE INDEX history_geometry_linestring_deletion_column_name_idx ON public.history_geometry_linestring_deletion
	USING btree
	(
	  column_name
	);
-- ddl-end --

-- object: history_bool_deletion_column_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS public.history_bool_deletion_column_name_idx CASCADE;
CREATE INDEX history_bool_deletion_column_name_idx ON public.history_bool_deletion
	USING btree
	(
	  column_name
	);
-- ddl-end --

-- object: history_geometry_point_deletion_column_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS public.history_geometry_point_deletion_column_name_idx CASCADE;
CREATE INDEX history_geometry_point_deletion_column_name_idx ON public.history_geometry_point_deletion
	USING btree
	(
	  column_name
	);
-- ddl-end --

-- object: history_text_deletion_column_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS public.history_text_deletion_column_name_idx CASCADE;
CREATE INDEX history_text_deletion_column_name_idx ON public.history_text_deletion
	USING btree
	(
	  column_name
	);
-- ddl-end --

-- object: public.fiber_enclosure_coverage | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_enclosure_coverage CASCADE;
CREATE TABLE public.fiber_enclosure_coverage (
	id serial NOT NULL,
	coverage_area geometry(POLYGON, 4326) NOT NULL,
	fiber_enclosure_id integer NOT NULL,
	CONSTRAINT fiber_enclosure_coverage_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.fiber_enclosure_coverage OWNER TO postgres;
-- ddl-end --

-- object: public.address | type: TABLE --
-- DROP TABLE IF EXISTS public.address CASCADE;
CREATE TABLE public.address (
	id serial NOT NULL,
	address_number integer,
	address_number_fraction text,
	street_direction_pre text,
	street_name text,
	road_type_abbreviation text,
	street_direction_post text,
	sublocation_label text,
	sublocation_identifier text,
	city text,
	state text,
	zip_code integer,
	ext_tb_location_id integer,
	CONSTRAINT service_address_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.address.address_number IS '"10302" in an address like "10302 1/2 E. Plum St"';
-- ddl-end --
COMMENT ON COLUMN public.address.address_number_fraction IS '"1/2" in an address like "10302 1/2 E. Plum St"';
-- ddl-end --
COMMENT ON COLUMN public.address.street_direction_pre IS 'E (for east) in an address like "10302 1/2 E. Plum St"';
-- ddl-end --
COMMENT ON COLUMN public.address.street_name IS '"Plum" in an address like "10302 1/2 E. Plum St"';
-- ddl-end --
COMMENT ON COLUMN public.address.road_type_abbreviation IS 'St (for street) in an address like "10302 1/2 E. Plum St"';
-- ddl-end --
COMMENT ON COLUMN public.address.street_direction_post IS 'E (for east) in an address like "10302 1/2 28th Ave E"';
-- ddl-end --
COMMENT ON COLUMN public.address.sublocation_label IS '"Suite" in an address like "10302 1/2 E. Plum St Suite G"';
-- ddl-end --
COMMENT ON COLUMN public.address.sublocation_identifier IS '"G" in an address like "10302 1/2 E. Plum St Suite G"';
-- ddl-end --
ALTER TABLE public.address OWNER TO postgres;
-- ddl-end --

-- object: public.map_bookmark | type: TABLE --
-- DROP TABLE IF EXISTS public.map_bookmark CASCADE;
CREATE TABLE public.map_bookmark (
	id serial NOT NULL,
	map_center geometry(POINT, 4326) NOT NULL,
	zoom_level integer,
	bookmark_name text NOT NULL,
	CONSTRAINT map_bookmark_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.map_bookmark OWNER TO postgres;
-- ddl-end --

-- object: public.load_support_attachment | type: TABLE --
-- DROP TABLE IF EXISTS public.load_support_attachment CASCADE;
CREATE TABLE public.load_support_attachment (
	id serial NOT NULL,
	load_linear_sequence real,
	type_load smallint NOT NULL,
	type_support smallint NOT NULL,
	linear_reverse bool,
	fiber_cable_id integer,
	built timestamptz,
	supporting_building_id integer,
	support_conduit_id integer,
	load_conduit_id integer,
	support_strand_line_id integer,
	load_strand_line_id integer,
	CONSTRAINT load_support_attachment_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.load_support_attachment IS 'An "attachment" of a load (fiber cable, strand, or even conduit) by a support (pole, building, strand, or even conduit or trench).';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.load_linear_sequence IS 'Used to "sort" points of attachment into a linear order for a specific load element. This is coarser than the linear_sequence on related load_support_attachment_point objects: load_support_attachment.load_linear_sequence sorts the overall attachments for a load into order, then inside that the load_support_attachment_point.linear_sequence sorts the points for that (linear) attachment into order. TLDR: order by load_support_attachment.load_linear_sequence, load_support_attachment_point.linear_sequence.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.type_load IS 'Type of load the attachment supports. 1=fiber, 2=strand, 3=conduit.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.type_support IS 'Type of support in the attachment. 1=pole, 2=building, 3=conduit, 4=strand point, 5=strand line.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.linear_reverse IS 'Whether the meterage/footage marked on a linear load (fiber, duct) is opposite the footage/meterage direction on a marked linear support (duct).';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.fiber_cable_id IS 'Id of fiber cable supported, if supported load is a fiber cable (type_load=1).';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.built IS 'NULL if this is not built yet, otherwise, time it was built.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.supporting_building_id IS 'Id of the building object that is supporting at this attachment in the case where the support is a building (type_support=2). NULL otherwise.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.support_conduit_id IS 'ID of the conduit "supporting" this "attachment" when the type_support=3.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.load_conduit_id IS 'id of the conduit acting as the load in this attachment when type_load=3.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.support_strand_line_id IS 'Id of the strand line supporting this attachment (used when type_support=). TODO: is this supporting a point or a linear line in this attachment if this is filled out?';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment.load_strand_line_id IS 'Id of a strand line supported as a load in this attachment. Note that this attachment doesn''t support the whole line, just a point on it - this reference just tells us what line it is part of.';
-- ddl-end --
ALTER TABLE public.load_support_attachment OWNER TO postgres;
-- ddl-end --

-- object: public.load_support_attachment_point | type: TABLE --
-- DROP TABLE IF EXISTS public.load_support_attachment_point CASCADE;
CREATE TABLE public.load_support_attachment_point (
	id serial NOT NULL,
	linear_sequence real,
	latlong_cached geometry(POINT, 4326),
	load_meterage real,
	load_sort real,
	pole_attachment_id integer,
	underlying_load_support_attachment_point_id integer,
	load_support_attachment_id integer NOT NULL,
	CONSTRAINT load_support_attachment_pk_cp PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.load_support_attachment_point IS 'An "attachment" of a load (fiber cable, strand, or even conduit) by a support (pole, building, strand, or even conduit or trench).';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment_point.linear_sequence IS 'Used to "sort" points of attachment in a linear attachment into order. This is finer than the load_linear_sequence on the related load_support_attachment object: load_support_attachment.load_linear_sequence sorts the overall attachments for a load into order, then inside that the load_support_attachment_point.linear_sequence sorts the points for that (linear) attachment into order. TLDR: order by load_support_attachment.load_linear_sequence, load_support_attachment_point.linear_sequence.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment_point.latlong_cached IS 'For attachments where the support point(s) can not be automatically calculated because of recursion, a manually entered location to show this point as. Otherwise, NULL is fine.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment_point.load_meterage IS 'For linear loads with footage/meterage on them (fiber, duct) footage or meterage where the support begins (as defined by a lowest "linear_sequence" value for a particular load).';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment_point.load_sort IS 'Where this attachment point should sort to in the list of related items/events (segment ends, cases, slack loops) along its related load. Lower priority alternative to meterage, for cases where load_meterage is not set.';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment_point.pole_attachment_id IS 'Related pole attachment object, IF this attachment has a support type of pole (type_support=1)';
-- ddl-end --
COMMENT ON COLUMN public.load_support_attachment_point.underlying_load_support_attachment_point_id IS 'If this point of attatchment is supported by another linear object''s supports, the underlying load_support_attachment_point. latlong_cached is a substitute for where we are leaving or joining a linear support.';
-- ddl-end --
ALTER TABLE public.load_support_attachment_point OWNER TO postgres;
-- ddl-end --

-- object: public.conduit_vault_entry_or_end | type: TABLE --
-- DROP TABLE IF EXISTS public.conduit_vault_entry_or_end CASCADE;
CREATE TABLE public.conduit_vault_entry_or_end (
	id serial NOT NULL,
	meterage real,
	f_end bool,
	vault_sequence real,
	underground_vault_id integer,
	conduit_id integer NOT NULL,
	CONSTRAINT conduit_vault_entry_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON COLUMN public.conduit_vault_entry_or_end.f_end IS 'If the conduit has an end in this vault (true) or just passes by sealed (false).';
-- ddl-end --
COMMENT ON COLUMN public.conduit_vault_entry_or_end.vault_sequence IS 'Fallback alternative to meterage to put vault entries in order, to avoid forcing the recording of conudit meterage while still allowing ordering vaults it passes through. TLDR: order by conduit_vault_entry.meterage, conduit_vault_entry.vault_sequence.';
-- ddl-end --
ALTER TABLE public.conduit_vault_entry_or_end OWNER TO postgres;
-- ddl-end --

-- object: underground_vault_fk | type: CONSTRAINT --
-- ALTER TABLE public.conduit_vault_entry_or_end DROP CONSTRAINT IF EXISTS underground_vault_fk CASCADE;
ALTER TABLE public.conduit_vault_entry_or_end ADD CONSTRAINT underground_vault_fk FOREIGN KEY (underground_vault_id)
REFERENCES public.underground_vault (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: conduit_fk | type: CONSTRAINT --
-- ALTER TABLE public.conduit_vault_entry_or_end DROP CONSTRAINT IF EXISTS conduit_fk CASCADE;
ALTER TABLE public.conduit_vault_entry_or_end ADD CONSTRAINT conduit_fk FOREIGN KEY (conduit_id)
REFERENCES public.conduit (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: length_units_fk | type: CONSTRAINT --
-- ALTER TABLE public.conduit DROP CONSTRAINT IF EXISTS length_units_fk CASCADE;
ALTER TABLE public.conduit ADD CONSTRAINT length_units_fk FOREIGN KEY (length_units_id)
REFERENCES public.length_units (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: public.many_building_has_many_address | type: TABLE --
-- DROP TABLE IF EXISTS public.many_building_has_many_address CASCADE;
CREATE TABLE public.many_building_has_many_address (
	building_id integer NOT NULL,
	building_id1 integer NOT NULL,
	CONSTRAINT many_building_has_many_address_pk PRIMARY KEY (building_id,building_id1)

);
-- ddl-end --

-- object: building_fk | type: CONSTRAINT --
-- ALTER TABLE public.many_building_has_many_address DROP CONSTRAINT IF EXISTS building_fk CASCADE;
ALTER TABLE public.many_building_has_many_address ADD CONSTRAINT building_fk FOREIGN KEY (building_id)
REFERENCES public.building (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: address_fk | type: CONSTRAINT --
-- ALTER TABLE public.many_building_has_many_address DROP CONSTRAINT IF EXISTS address_fk CASCADE;
ALTER TABLE public.many_building_has_many_address ADD CONSTRAINT address_fk FOREIGN KEY (building_id1)
REFERENCES public.address (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.fiber_cable_segment | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_cable_segment CASCADE;
CREATE TABLE public.fiber_cable_segment (
	id serial NOT NULL,
	fiber_cable_id integer NOT NULL,
	CONSTRAINT fiber_cable_segment_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE public.fiber_cable_segment OWNER TO postgres;
-- ddl-end --

-- object: fiber_cable_fk | type: CONSTRAINT --
-- ALTER TABLE public.fiber_cable_segment DROP CONSTRAINT IF EXISTS fiber_cable_fk CASCADE;
ALTER TABLE public.fiber_cable_segment ADD CONSTRAINT fiber_cable_fk FOREIGN KEY (fiber_cable_id)
REFERENCES public.fiber_cable (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: public.fiber_cable_segment_end | type: TABLE --
-- DROP TABLE IF EXISTS public.fiber_cable_segment_end CASCADE;
CREATE TABLE public.fiber_cable_segment_end (
	id serial NOT NULL,
	fiber_cable_segment_id integer NOT NULL,
	start_end bool,
	cable_meterage real,
	cable_sort real,
	tape_marking text,
	label text,
	fiber_enclosure_id integer,
	CONSTRAINT fiber_cable_segment_end_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.fiber_cable_segment_end IS 'meterage of the cable at this end of the segment.';
-- ddl-end --
COMMENT ON COLUMN public.fiber_cable_segment_end.start_end IS 'If true, then going from the end down the fiber cable, cable meterage will be ascending. If false, it will be decending.';
-- ddl-end --
COMMENT ON COLUMN public.fiber_cable_segment_end.cable_sort IS 'Where this item falls along the linear geography of its related cable. Lower priority alternative to meterage, for cases where meterage is not set.';
-- ddl-end --
COMMENT ON COLUMN public.fiber_cable_segment_end.tape_marking IS 'Marking of the cable with colored tape. Convention for order of colors is from the field to the end of the cable.';
-- ddl-end --
COMMENT ON COLUMN public.fiber_cable_segment_end.label IS 'Textual label of the cable end, if there is one.';
-- ddl-end --
ALTER TABLE public.fiber_cable_segment_end OWNER TO postgres;
-- ddl-end --

-- object: fiber_cable_segment_fk | type: CONSTRAINT --
-- ALTER TABLE public.fiber_cable_segment_end DROP CONSTRAINT IF EXISTS fiber_cable_segment_fk CASCADE;
ALTER TABLE public.fiber_cable_segment_end ADD CONSTRAINT fiber_cable_segment_fk FOREIGN KEY (fiber_cable_segment_id)
REFERENCES public.fiber_cable_segment (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fiber_cable_segment_end_fk | type: CONSTRAINT --
-- ALTER TABLE public.cable_fiber_end DROP CONSTRAINT IF EXISTS fiber_cable_segment_end_fk CASCADE;
ALTER TABLE public.cable_fiber_end ADD CONSTRAINT fiber_cable_segment_end_fk FOREIGN KEY (fiber_cable_segment_end_id)
REFERENCES public.fiber_cable_segment_end (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fiber_enclosure_fk | type: CONSTRAINT --
-- ALTER TABLE public.fiber_cable_segment_end DROP CONSTRAINT IF EXISTS fiber_enclosure_fk CASCADE;
ALTER TABLE public.fiber_cable_segment_end ADD CONSTRAINT fiber_enclosure_fk FOREIGN KEY (fiber_enclosure_id)
REFERENCES public.fiber_enclosure (id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: pole_reference | type: CONSTRAINT --
-- ALTER TABLE public.pole_attachment DROP CONSTRAINT IF EXISTS pole_reference CASCADE;
ALTER TABLE public.pole_attachment ADD CONSTRAINT pole_reference FOREIGN KEY (utility_pole_id)
REFERENCES public.utility_pole (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: ref_pole_attachment | type: CONSTRAINT --
-- ALTER TABLE public.strand_guy_wire DROP CONSTRAINT IF EXISTS ref_pole_attachment CASCADE;
ALTER TABLE public.strand_guy_wire ADD CONSTRAINT ref_pole_attachment FOREIGN KEY (pole_attachment_id)
REFERENCES public.pole_attachment (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitters_are_one_of_standard_types | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter DROP CONSTRAINT IF EXISTS optical_splitters_are_one_of_standard_types CASCADE;
ALTER TABLE public.optical_splitter ADD CONSTRAINT optical_splitters_are_one_of_standard_types FOREIGN KEY (splitter_type_id)
REFERENCES public.optical_splitter_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitters_are_one_of_a_standard_style | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter DROP CONSTRAINT IF EXISTS optical_splitters_are_one_of_a_standard_style CASCADE;
ALTER TABLE public.optical_splitter ADD CONSTRAINT optical_splitters_are_one_of_a_standard_style FOREIGN KEY (splitter_style_id)
REFERENCES public.optical_splitter_styles (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: splitter_can_be_located_inside_fiber_enclosure | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter DROP CONSTRAINT IF EXISTS splitter_can_be_located_inside_fiber_enclosure CASCADE;
ALTER TABLE public.optical_splitter ADD CONSTRAINT splitter_can_be_located_inside_fiber_enclosure FOREIGN KEY (containing_fiber_enclosure)
REFERENCES public.fiber_enclosure (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: ref_fiber_enclosure | type: CONSTRAINT --
-- ALTER TABLE public.enclosure_port DROP CONSTRAINT IF EXISTS ref_fiber_enclosure CASCADE;
ALTER TABLE public.enclosure_port ADD CONSTRAINT ref_fiber_enclosure FOREIGN KEY (fiber_enclosure_id)
REFERENCES public.fiber_enclosure (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: enclosure_port_inherits_from_fiber_connection | type: CONSTRAINT --
-- ALTER TABLE public.enclosure_port DROP CONSTRAINT IF EXISTS enclosure_port_inherits_from_fiber_connection CASCADE;
ALTER TABLE public.enclosure_port ADD CONSTRAINT enclosure_port_inherits_from_fiber_connection FOREIGN KEY (fiber_connection_id)
REFERENCES public.fiber_connection (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_cable_has_one_length_unit | type: CONSTRAINT --
-- ALTER TABLE public.fiber_cable DROP CONSTRAINT IF EXISTS fiber_cable_has_one_length_unit CASCADE;
ALTER TABLE public.fiber_cable ADD CONSTRAINT fiber_cable_has_one_length_unit FOREIGN KEY (length_units)
REFERENCES public.length_units (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_group_has_one_fiber_group_type | type: CONSTRAINT --
-- ALTER TABLE public.fiber_group DROP CONSTRAINT IF EXISTS fiber_group_has_one_fiber_group_type CASCADE;
ALTER TABLE public.fiber_group ADD CONSTRAINT fiber_group_has_one_fiber_group_type FOREIGN KEY (group_type_id)
REFERENCES public.fiber_group_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_group_belongs_to_fiber_cable | type: CONSTRAINT --
-- ALTER TABLE public.fiber_group DROP CONSTRAINT IF EXISTS fiber_group_belongs_to_fiber_cable CASCADE;
ALTER TABLE public.fiber_group ADD CONSTRAINT fiber_group_belongs_to_fiber_cable FOREIGN KEY (fiber_cable_id)
REFERENCES public.fiber_cable (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fibers_are_in_a_cable | type: CONSTRAINT --
-- ALTER TABLE public.fiber DROP CONSTRAINT IF EXISTS fibers_are_in_a_cable CASCADE;
ALTER TABLE public.fiber ADD CONSTRAINT fibers_are_in_a_cable FOREIGN KEY (cable_id)
REFERENCES public.fiber_cable (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_has_potentially_multiple_group_identifiers | type: CONSTRAINT --
-- ALTER TABLE public.fiber_identifier_index DROP CONSTRAINT IF EXISTS fiber_has_potentially_multiple_group_identifiers CASCADE;
ALTER TABLE public.fiber_identifier_index ADD CONSTRAINT fiber_has_potentially_multiple_group_identifiers FOREIGN KEY (fiber_id)
REFERENCES public.fiber (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_cable_can_have_many_slack_coils | type: CONSTRAINT --
-- ALTER TABLE public.fiber_cable_slack_coil DROP CONSTRAINT IF EXISTS fiber_cable_can_have_many_slack_coils CASCADE;
ALTER TABLE public.fiber_cable_slack_coil ADD CONSTRAINT fiber_cable_can_have_many_slack_coils FOREIGN KEY (fiber_cable_id)
REFERENCES public.fiber_cable (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitter_outputs_belong_to_a_splitter | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_output DROP CONSTRAINT IF EXISTS optical_splitter_outputs_belong_to_a_splitter CASCADE;
ALTER TABLE public.optical_splitter_output ADD CONSTRAINT optical_splitter_outputs_belong_to_a_splitter FOREIGN KEY (optical_splitter_id)
REFERENCES public.optical_splitter (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitter_outputs_are_a_fiber | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_output DROP CONSTRAINT IF EXISTS optical_splitter_outputs_are_a_fiber CASCADE;
ALTER TABLE public.optical_splitter_output ADD CONSTRAINT optical_splitter_outputs_are_a_fiber FOREIGN KEY (fiber_end_id)
REFERENCES public.fiber_end (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitter_inputs_belong_to_a_splitter | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_input DROP CONSTRAINT IF EXISTS optical_splitter_inputs_belong_to_a_splitter CASCADE;
ALTER TABLE public.optical_splitter_input ADD CONSTRAINT optical_splitter_inputs_belong_to_a_splitter FOREIGN KEY (optical_splitter_id)
REFERENCES public.optical_splitter (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitter_inputs_are_a_fiber | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_input DROP CONSTRAINT IF EXISTS optical_splitter_inputs_are_a_fiber CASCADE;
ALTER TABLE public.optical_splitter_input ADD CONSTRAINT optical_splitter_inputs_are_a_fiber FOREIGN KEY (fiber_end_id)
REFERENCES public.fiber_end (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_end_can_have_optical_connector_type | type: CONSTRAINT --
-- ALTER TABLE public.fiber_end DROP CONSTRAINT IF EXISTS fiber_end_can_have_optical_connector_type CASCADE;
ALTER TABLE public.fiber_end ADD CONSTRAINT fiber_end_can_have_optical_connector_type FOREIGN KEY (optical_connector_type_id)
REFERENCES public.optical_connector_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: cable_fiber_end_is_attritube_of_cable_fiber | type: CONSTRAINT --
-- ALTER TABLE public.cable_fiber_end DROP CONSTRAINT IF EXISTS cable_fiber_end_is_attritube_of_cable_fiber CASCADE;
ALTER TABLE public.cable_fiber_end ADD CONSTRAINT cable_fiber_end_is_attritube_of_cable_fiber FOREIGN KEY (fiber_id)
REFERENCES public.fiber (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: cable_fiber_end_inherts_from_fiber_end | type: CONSTRAINT --
-- ALTER TABLE public.cable_fiber_end DROP CONSTRAINT IF EXISTS cable_fiber_end_inherts_from_fiber_end CASCADE;
ALTER TABLE public.cable_fiber_end ADD CONSTRAINT cable_fiber_end_inherts_from_fiber_end FOREIGN KEY (fiber_end_id)
REFERENCES public.fiber_end (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_connection_may_connect_fiber_end_a | type: CONSTRAINT --
-- ALTER TABLE public.fiber_connection DROP CONSTRAINT IF EXISTS fiber_connection_may_connect_fiber_end_a CASCADE;
ALTER TABLE public.fiber_connection ADD CONSTRAINT fiber_connection_may_connect_fiber_end_a FOREIGN KEY (connected_fiber_end_a_id)
REFERENCES public.fiber_end (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_connection_may_connect_fiber_end_b | type: CONSTRAINT --
-- ALTER TABLE public.fiber_connection DROP CONSTRAINT IF EXISTS fiber_connection_may_connect_fiber_end_b CASCADE;
ALTER TABLE public.fiber_connection ADD CONSTRAINT fiber_connection_may_connect_fiber_end_b FOREIGN KEY (connected_fiber_end_b_id)
REFERENCES public.fiber_end (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_connection_a_may_have_optical_connector_type | type: CONSTRAINT --
-- ALTER TABLE public.fiber_connection DROP CONSTRAINT IF EXISTS fiber_connection_a_may_have_optical_connector_type CASCADE;
ALTER TABLE public.fiber_connection ADD CONSTRAINT fiber_connection_a_may_have_optical_connector_type FOREIGN KEY (a_optical_connector_type_id)
REFERENCES public.optical_connector_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_connection_b_may_have_optical_connector_type | type: CONSTRAINT --
-- ALTER TABLE public.fiber_connection DROP CONSTRAINT IF EXISTS fiber_connection_b_may_have_optical_connector_type CASCADE;
ALTER TABLE public.fiber_connection ADD CONSTRAINT fiber_connection_b_may_have_optical_connector_type FOREIGN KEY (b_optical_connector_type_id)
REFERENCES public.optical_connector_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_splice_is_a_fiber_connection | type: CONSTRAINT --
-- ALTER TABLE public.fiber_splice DROP CONSTRAINT IF EXISTS fiber_splice_is_a_fiber_connection CASCADE;
ALTER TABLE public.fiber_splice ADD CONSTRAINT fiber_splice_is_a_fiber_connection FOREIGN KEY (fiber_connection_id)
REFERENCES public.fiber_connection (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: demensions_measurements_must_have_unit | type: CONSTRAINT --
-- ALTER TABLE public.underground_vault DROP CONSTRAINT IF EXISTS demensions_measurements_must_have_unit CASCADE;
ALTER TABLE public.underground_vault ADD CONSTRAINT demensions_measurements_must_have_unit FOREIGN KEY (length_units_id)
REFERENCES public.length_units (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: underground_conduit_has_a_conduit_type | type: CONSTRAINT --
-- ALTER TABLE public.conduit DROP CONSTRAINT IF EXISTS underground_conduit_has_a_conduit_type CASCADE;
ALTER TABLE public.conduit ADD CONSTRAINT underground_conduit_has_a_conduit_type FOREIGN KEY (conduit_type_id)
REFERENCES public.conduit_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: m2m_fiber_cable_slack_coil_underground_vault | type: CONSTRAINT --
-- ALTER TABLE public.fiber_cable_slack_coil_located_in_underground_vault DROP CONSTRAINT IF EXISTS m2m_fiber_cable_slack_coil_underground_vault CASCADE;
ALTER TABLE public.fiber_cable_slack_coil_located_in_underground_vault ADD CONSTRAINT m2m_fiber_cable_slack_coil_underground_vault FOREIGN KEY (underground_vault_id)
REFERENCES public.underground_vault (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: m2m_underground_vault_fiber_cable_slack_coil | type: CONSTRAINT --
-- ALTER TABLE public.fiber_cable_slack_coil_located_in_underground_vault DROP CONSTRAINT IF EXISTS m2m_underground_vault_fiber_cable_slack_coil CASCADE;
ALTER TABLE public.fiber_cable_slack_coil_located_in_underground_vault ADD CONSTRAINT m2m_underground_vault_fiber_cable_slack_coil FOREIGN KEY (fiber_cable_slack_loop_id)
REFERENCES public.fiber_cable_slack_coil (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: m2m_fiber_enclosure_underground_vault | type: CONSTRAINT --
-- ALTER TABLE public.fiber_enclosure_located_in_underground_vault DROP CONSTRAINT IF EXISTS m2m_fiber_enclosure_underground_vault CASCADE;
ALTER TABLE public.fiber_enclosure_located_in_underground_vault ADD CONSTRAINT m2m_fiber_enclosure_underground_vault FOREIGN KEY (fiber_enclosure_id)
REFERENCES public.fiber_enclosure (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: m2m_underground_vault_fiber_enclosure | type: CONSTRAINT --
-- ALTER TABLE public.fiber_enclosure_located_in_underground_vault DROP CONSTRAINT IF EXISTS m2m_underground_vault_fiber_enclosure CASCADE;
ALTER TABLE public.fiber_enclosure_located_in_underground_vault ADD CONSTRAINT m2m_underground_vault_fiber_enclosure FOREIGN KEY (underground_vault_id)
REFERENCES public.underground_vault (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_end_inheritance_has_fiber_end_instance | type: CONSTRAINT --
-- ALTER TABLE public.fiber_end_meta_instance_inheritance DROP CONSTRAINT IF EXISTS fiber_end_inheritance_has_fiber_end_instance CASCADE;
ALTER TABLE public.fiber_end_meta_instance_inheritance ADD CONSTRAINT fiber_end_inheritance_has_fiber_end_instance FOREIGN KEY (fiber_end_id)
REFERENCES public.fiber_end (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_connection_can_be_inherited_by_many_tables | type: CONSTRAINT --
-- ALTER TABLE public.fiber_connection_meta_instance_inheritance DROP CONSTRAINT IF EXISTS fiber_connection_can_be_inherited_by_many_tables CASCADE;
ALTER TABLE public.fiber_connection_meta_instance_inheritance ADD CONSTRAINT fiber_connection_can_be_inherited_by_many_tables FOREIGN KEY (fiber_connection_id)
REFERENCES public.fiber_connection (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: ref_fiber_enclosure | type: CONSTRAINT --
-- ALTER TABLE public.enclosure_port_template DROP CONSTRAINT IF EXISTS ref_fiber_enclosure CASCADE;
ALTER TABLE public.enclosure_port_template ADD CONSTRAINT ref_fiber_enclosure FOREIGN KEY (fiber_enclosure_template_id)
REFERENCES public.fiber_enclosure_template (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: enclosure_port_inherits_from_fiber_connection | type: CONSTRAINT --
-- ALTER TABLE public.enclosure_port_template DROP CONSTRAINT IF EXISTS enclosure_port_inherits_from_fiber_connection CASCADE;
ALTER TABLE public.enclosure_port_template ADD CONSTRAINT enclosure_port_inherits_from_fiber_connection FOREIGN KEY (fiber_connection_template_id)
REFERENCES public.fiber_connection_enclosure_port_template (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_connection_a_may_have_optical_connector_type_cp | type: CONSTRAINT --
-- ALTER TABLE public.fiber_connection_enclosure_port_template DROP CONSTRAINT IF EXISTS fiber_connection_a_may_have_optical_connector_type_cp CASCADE;
ALTER TABLE public.fiber_connection_enclosure_port_template ADD CONSTRAINT fiber_connection_a_may_have_optical_connector_type_cp FOREIGN KEY (a_optical_connector_type_id)
REFERENCES public.optical_connector_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_connection_b_may_have_optical_connector_type_cp | type: CONSTRAINT --
-- ALTER TABLE public.fiber_connection_enclosure_port_template DROP CONSTRAINT IF EXISTS fiber_connection_b_may_have_optical_connector_type_cp CASCADE;
ALTER TABLE public.fiber_connection_enclosure_port_template ADD CONSTRAINT fiber_connection_b_may_have_optical_connector_type_cp FOREIGN KEY (b_optical_connector_type_id)
REFERENCES public.optical_connector_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_cable_template_has_one_length_unit | type: CONSTRAINT --
-- ALTER TABLE public.fiber_cable_template DROP CONSTRAINT IF EXISTS fiber_cable_template_has_one_length_unit CASCADE;
ALTER TABLE public.fiber_cable_template ADD CONSTRAINT fiber_cable_template_has_one_length_unit FOREIGN KEY (length_units)
REFERENCES public.length_units (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_group_template_has_one_fiber_group_type | type: CONSTRAINT --
-- ALTER TABLE public.fiber_group_template DROP CONSTRAINT IF EXISTS fiber_group_template_has_one_fiber_group_type CASCADE;
ALTER TABLE public.fiber_group_template ADD CONSTRAINT fiber_group_template_has_one_fiber_group_type FOREIGN KEY (group_type_id)
REFERENCES public.fiber_group_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_group_template_belongs_to_fiber_cable_template | type: CONSTRAINT --
-- ALTER TABLE public.fiber_group_template DROP CONSTRAINT IF EXISTS fiber_group_template_belongs_to_fiber_cable_template CASCADE;
ALTER TABLE public.fiber_group_template ADD CONSTRAINT fiber_group_template_belongs_to_fiber_cable_template FOREIGN KEY (fiber_cable_template_id)
REFERENCES public.fiber_cable_template (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitters_are_one_of_standard_types | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_template DROP CONSTRAINT IF EXISTS optical_splitters_are_one_of_standard_types CASCADE;
ALTER TABLE public.optical_splitter_template ADD CONSTRAINT optical_splitters_are_one_of_standard_types FOREIGN KEY (splitter_type_id)
REFERENCES public.optical_splitter_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitters_templates_are_one_of_a_standard_style | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_template DROP CONSTRAINT IF EXISTS optical_splitters_templates_are_one_of_a_standard_style CASCADE;
ALTER TABLE public.optical_splitter_template ADD CONSTRAINT optical_splitters_templates_are_one_of_a_standard_style FOREIGN KEY (splitter_style_id)
REFERENCES public.optical_splitter_styles (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitter_outputs_templates_belong_to_a_splitter_templat | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_output_template DROP CONSTRAINT IF EXISTS optical_splitter_outputs_templates_belong_to_a_splitter_templat CASCADE;
ALTER TABLE public.optical_splitter_output_template ADD CONSTRAINT optical_splitter_outputs_templates_belong_to_a_splitter_templat FOREIGN KEY (optical_splitter_id)
REFERENCES public.optical_splitter_template (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitter_outputs_are_a_fiber | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_output_template DROP CONSTRAINT IF EXISTS optical_splitter_outputs_are_a_fiber CASCADE;
ALTER TABLE public.optical_splitter_output_template ADD CONSTRAINT optical_splitter_outputs_are_a_fiber FOREIGN KEY (fiber_end_id)
REFERENCES public.optical_splitter_template_fiber_end (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitter_inputs_templates_belong_to_a_splitter_template | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_input_template DROP CONSTRAINT IF EXISTS optical_splitter_inputs_templates_belong_to_a_splitter_template CASCADE;
ALTER TABLE public.optical_splitter_input_template ADD CONSTRAINT optical_splitter_inputs_templates_belong_to_a_splitter_template FOREIGN KEY (optical_splitter_template_id)
REFERENCES public.optical_splitter_template (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: optical_splitter_inputs_are_a_fiber | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_input_template DROP CONSTRAINT IF EXISTS optical_splitter_inputs_are_a_fiber CASCADE;
ALTER TABLE public.optical_splitter_input_template ADD CONSTRAINT optical_splitter_inputs_are_a_fiber FOREIGN KEY (fiber_end_id)
REFERENCES public.optical_splitter_template_fiber_end (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_end_can_have_optical_connector_type | type: CONSTRAINT --
-- ALTER TABLE public.optical_splitter_template_fiber_end DROP CONSTRAINT IF EXISTS fiber_end_can_have_optical_connector_type CASCADE;
ALTER TABLE public.optical_splitter_template_fiber_end ADD CONSTRAINT fiber_end_can_have_optical_connector_type FOREIGN KEY (optical_connector_type_id)
REFERENCES public.optical_connector_types (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: demensions_measurements_must_have_unit | type: CONSTRAINT --
-- ALTER TABLE public.underground_vault_template DROP CONSTRAINT IF EXISTS demensions_measurements_must_have_unit CASCADE;
ALTER TABLE public.underground_vault_template ADD CONSTRAINT demensions_measurements_must_have_unit FOREIGN KEY (length_units_id)
REFERENCES public.length_units (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: length_has_unit | type: CONSTRAINT --
-- ALTER TABLE public.conduit_type DROP CONSTRAINT IF EXISTS length_has_unit CASCADE;
ALTER TABLE public.conduit_type ADD CONSTRAINT length_has_unit FOREIGN KEY (length_units)
REFERENCES public.length_units (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: diameter_has_unit | type: CONSTRAINT --
-- ALTER TABLE public.conduit_type DROP CONSTRAINT IF EXISTS diameter_has_unit CASCADE;
ALTER TABLE public.conduit_type ADD CONSTRAINT diameter_has_unit FOREIGN KEY (diameter_units)
REFERENCES public.length_units (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: history_text_deletion_belongs_to_history_row_deletion | type: CONSTRAINT --
-- ALTER TABLE public.history_text_deletion DROP CONSTRAINT IF EXISTS history_text_deletion_belongs_to_history_row_deletion CASCADE;
ALTER TABLE public.history_text_deletion ADD CONSTRAINT history_text_deletion_belongs_to_history_row_deletion FOREIGN KEY (history_row_deletion_id)
REFERENCES public.history_row_deletion (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: history_integer_deletion_belongs_to_history_row_deletion | type: CONSTRAINT --
-- ALTER TABLE public.history_integer_deletion DROP CONSTRAINT IF EXISTS history_integer_deletion_belongs_to_history_row_deletion CASCADE;
ALTER TABLE public.history_integer_deletion ADD CONSTRAINT history_integer_deletion_belongs_to_history_row_deletion FOREIGN KEY (history_row_deletion_id)
REFERENCES public.history_row_deletion (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: history_real_deletion_belongs_to_history_row_deletion | type: CONSTRAINT --
-- ALTER TABLE public.history_real_deletion DROP CONSTRAINT IF EXISTS history_real_deletion_belongs_to_history_row_deletion CASCADE;
ALTER TABLE public.history_real_deletion ADD CONSTRAINT history_real_deletion_belongs_to_history_row_deletion FOREIGN KEY (history_row_deletion_id)
REFERENCES public.history_row_deletion (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: history_bool_deletion_belongs_to_history_row_deletion | type: CONSTRAINT --
-- ALTER TABLE public.history_bool_deletion DROP CONSTRAINT IF EXISTS history_bool_deletion_belongs_to_history_row_deletion CASCADE;
ALTER TABLE public.history_bool_deletion ADD CONSTRAINT history_bool_deletion_belongs_to_history_row_deletion FOREIGN KEY (history_row_deletion_id)
REFERENCES public.history_row_deletion (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: history_geography_point_deletion_needs_history_row_deletion | type: CONSTRAINT --
-- ALTER TABLE public.history_geometry_point_deletion DROP CONSTRAINT IF EXISTS history_geography_point_deletion_needs_history_row_deletion CASCADE;
ALTER TABLE public.history_geometry_point_deletion ADD CONSTRAINT history_geography_point_deletion_needs_history_row_deletion FOREIGN KEY (history_row_deletion_id)
REFERENCES public.history_row_deletion (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: history_geography_linestring_deletion_needs_row_deletion | type: CONSTRAINT --
-- ALTER TABLE public.history_geometry_linestring_deletion DROP CONSTRAINT IF EXISTS history_geography_linestring_deletion_needs_row_deletion CASCADE;
ALTER TABLE public.history_geometry_linestring_deletion ADD CONSTRAINT history_geography_linestring_deletion_needs_row_deletion FOREIGN KEY (history_row_deletion_id)
REFERENCES public.history_row_deletion (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: history_smallint_deletion_belongs_to_history_row_deletion | type: CONSTRAINT --
-- ALTER TABLE public.history_smallint_deletion DROP CONSTRAINT IF EXISTS history_smallint_deletion_belongs_to_history_row_deletion CASCADE;
ALTER TABLE public.history_smallint_deletion ADD CONSTRAINT history_smallint_deletion_belongs_to_history_row_deletion FOREIGN KEY (history_row_deletion_id)
REFERENCES public.history_row_deletion (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: fiber_enclosure_coverage_references_fiber_enclosure | type: CONSTRAINT --
-- ALTER TABLE public.fiber_enclosure_coverage DROP CONSTRAINT IF EXISTS fiber_enclosure_coverage_references_fiber_enclosure CASCADE;
ALTER TABLE public.fiber_enclosure_coverage ADD CONSTRAINT fiber_enclosure_coverage_references_fiber_enclosure FOREIGN KEY (fiber_enclosure_id)
REFERENCES public.fiber_enclosure (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: load_support_attachment_fiber_cable | type: CONSTRAINT --
-- ALTER TABLE public.load_support_attachment DROP CONSTRAINT IF EXISTS load_support_attachment_fiber_cable CASCADE;
ALTER TABLE public.load_support_attachment ADD CONSTRAINT load_support_attachment_fiber_cable FOREIGN KEY (fiber_cable_id)
REFERENCES public.fiber_cable (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: load_support_attachment_building | type: CONSTRAINT --
-- ALTER TABLE public.load_support_attachment DROP CONSTRAINT IF EXISTS load_support_attachment_building CASCADE;
ALTER TABLE public.load_support_attachment ADD CONSTRAINT load_support_attachment_building FOREIGN KEY (supporting_building_id)
REFERENCES public.building (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: load_support_attachment_load_conduit | type: CONSTRAINT --
-- ALTER TABLE public.load_support_attachment DROP CONSTRAINT IF EXISTS load_support_attachment_load_conduit CASCADE;
ALTER TABLE public.load_support_attachment ADD CONSTRAINT load_support_attachment_load_conduit FOREIGN KEY (load_conduit_id)
REFERENCES public.conduit (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: load_support_attachment_support_conduit | type: CONSTRAINT --
-- ALTER TABLE public.load_support_attachment DROP CONSTRAINT IF EXISTS load_support_attachment_support_conduit CASCADE;
ALTER TABLE public.load_support_attachment ADD CONSTRAINT load_support_attachment_support_conduit FOREIGN KEY (support_conduit_id)
REFERENCES public.conduit (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "load_support_attachment.support_strand_line_id_refs_strand_line" | type: CONSTRAINT --
-- ALTER TABLE public.load_support_attachment DROP CONSTRAINT IF EXISTS "load_support_attachment.support_strand_line_id_refs_strand_line" CASCADE;
ALTER TABLE public.load_support_attachment ADD CONSTRAINT "load_support_attachment.support_strand_line_id_refs_strand_line" FOREIGN KEY (support_strand_line_id)
REFERENCES public.strand_line (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "load_support_attachment.load_strand_line_id_refs_strand_line" | type: CONSTRAINT --
-- ALTER TABLE public.load_support_attachment DROP CONSTRAINT IF EXISTS "load_support_attachment.load_strand_line_id_refs_strand_line" CASCADE;
ALTER TABLE public.load_support_attachment ADD CONSTRAINT "load_support_attachment.load_strand_line_id_refs_strand_line" FOREIGN KEY (load_strand_line_id)
REFERENCES public.strand_line (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: rel_load_support_attachment_pole_attachment_cp | type: CONSTRAINT --
-- ALTER TABLE public.load_support_attachment_point DROP CONSTRAINT IF EXISTS rel_load_support_attachment_pole_attachment_cp CASCADE;
ALTER TABLE public.load_support_attachment_point ADD CONSTRAINT rel_load_support_attachment_pole_attachment_cp FOREIGN KEY (pole_attachment_id)
REFERENCES public.pole_attachment (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: load_support_attachment_point_belong2_load_support_attachment | type: CONSTRAINT --
-- ALTER TABLE public.load_support_attachment_point DROP CONSTRAINT IF EXISTS load_support_attachment_point_belong2_load_support_attachment CASCADE;
ALTER TABLE public.load_support_attachment_point ADD CONSTRAINT load_support_attachment_point_belong2_load_support_attachment FOREIGN KEY (load_support_attachment_id)
REFERENCES public.load_support_attachment (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --



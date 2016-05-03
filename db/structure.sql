--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: appraisals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE appraisals (
    id integer NOT NULL,
    financial_information_id integer,
    name character varying,
    appraisal_price numeric,
    appraisal_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: appraisals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE appraisals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appraisals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE appraisals_id_seq OWNED BY appraisals.id;


--
-- Name: artists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artists (
    id integer NOT NULL,
    brand character varying DEFAULT ''::character varying NOT NULL,
    country character varying,
    founded integer,
    closed integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artists_id_seq OWNED BY artists.id;


--
-- Name: artwork_multiple_objects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE artwork_multiple_objects (
    id integer NOT NULL,
    record_id integer,
    name character varying DEFAULT ''::character varying NOT NULL,
    material character varying,
    system character varying DEFAULT 'standard'::character varying,
    size hstore DEFAULT '"depth"=>"{:standard=>0, :metric=>0}", "width"=>"{:standard=>0, :metric=>0}", "height"=>"{:standard=>0, :metric=>0}"'::hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    weight hstore DEFAULT '"metric"=>"0", "standard"=>"0"'::hstore,
    duration hstore DEFAULT '"hours"=>"0", "minutes"=>"0", "seconds"=>"0"'::hstore
);


--
-- Name: artwork_multiple_objects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE artwork_multiple_objects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: artwork_multiple_objects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE artwork_multiple_objects_id_seq OWNED BY artwork_multiple_objects.id;


--
-- Name: attachments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attachments (
    id integer NOT NULL,
    attachable_id integer,
    attachable_type character varying,
    name character varying,
    file character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    original_filename character varying,
    public boolean DEFAULT false
);


--
-- Name: attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attachments_id_seq OWNED BY attachments.id;


--
-- Name: base_unit_systems; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE base_unit_systems (
    id integer NOT NULL,
    label character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: base_unit_systems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE base_unit_systems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: base_unit_systems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE base_unit_systems_id_seq OWNED BY base_unit_systems.id;


--
-- Name: details_artworks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE details_artworks (
    id integer NOT NULL,
    edition_id integer,
    manufacturer character varying,
    designer character varying,
    period character varying,
    packaging character varying,
    frame hstore DEFAULT '"depth"=>"{:standard=>0, :metric=>0}", "width"=>"{:standard=>0, :metric=>0}", "height"=>"{:standard=>0, :metric=>0}"'::hstore,
    unique_marks character varying,
    additional_information character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    system character varying DEFAULT 'standard'::character varying
);


--
-- Name: details_artworks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE details_artworks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: details_artworks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE details_artworks_id_seq OWNED BY details_artworks.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE documents (
    id integer NOT NULL,
    edition_id integer,
    title character varying,
    file character varying,
    public boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    original_filename character varying
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


--
-- Name: edition_admins; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE edition_admins (
    id integer NOT NULL,
    edition_id integer,
    xipsy_artwork_id character varying,
    xipsy_record_number character varying,
    inventory_number character varying,
    record_date timestamp without time zone,
    copyright character varying
);


--
-- Name: edition_admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE edition_admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edition_admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE edition_admins_id_seq OWNED BY edition_admins.id;


--
-- Name: editions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE editions (
    id integer NOT NULL,
    record_id integer,
    primary_status character varying,
    secondary_status character varying,
    notes text,
    edition_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "primary" boolean DEFAULT false,
    authenticator character varying,
    authenticity_id integer,
    is_from_primary boolean DEFAULT false
);


--
-- Name: editions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE editions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: editions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE editions_id_seq OWNED BY editions.id;


--
-- Name: editions_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE editions_tags (
    id integer NOT NULL,
    tag_id integer,
    edition_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: editions_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE editions_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: editions_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE editions_tags_id_seq OWNED BY editions_tags.id;


--
-- Name: exhibition_histories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE exhibition_histories (
    id integer NOT NULL,
    edition_id integer,
    displayed_by character varying,
    displayed_at character varying,
    title character varying,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: exhibition_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE exhibition_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exhibition_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE exhibition_histories_id_seq OWNED BY exhibition_histories.id;


--
-- Name: external_artworks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE external_artworks (
    id integer NOT NULL,
    artist_id integer,
    model character varying DEFAULT ''::character varying NOT NULL,
    year integer,
    material character varying,
    system character varying DEFAULT 'standard'::character varying,
    size hstore DEFAULT '"depth"=>"{:standard=>0, :metric=>0}", "width"=>"{:standard=>0, :metric=>0}", "height"=>"{:standard=>0, :metric=>0}"'::hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    weight hstore DEFAULT '"metric"=>"0", "standard"=>"0"'::hstore,
    duration hstore DEFAULT '"hours"=>"0", "minutes"=>"0", "seconds"=>"0"'::hstore
);


--
-- Name: external_artworks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE external_artworks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: external_artworks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE external_artworks_id_seq OWNED BY external_artworks.id;


--
-- Name: financial_informations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE financial_informations (
    id integer NOT NULL,
    edition_id integer,
    price numeric,
    insured_price numeric,
    insured_type character varying,
    policy text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    insurance_provider character varying
);


--
-- Name: financial_informations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE financial_informations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: financial_informations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE financial_informations_id_seq OWNED BY financial_informations.id;


--
-- Name: images; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE images (
    id integer NOT NULL,
    edition_id integer,
    copyright_holder text,
    licensing_agency text,
    resolution text,
    credit_line text,
    licensing_fee text,
    download boolean DEFAULT true,
    image character varying,
    crop hstore,
    temp_image character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    original_filename character varying,
    "primary" boolean DEFAULT false
);


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE images_id_seq OWNED BY images.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    name character varying,
    address character varying,
    city character varying,
    state character varying,
    zipcode character varying,
    sublocation character varying,
    location_notes text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    country text,
    edition_id integer,
    country_code character varying
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: prior_ownerships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE prior_ownerships (
    id integer NOT NULL,
    edition_id integer,
    owner character varying,
    purchase_price numeric,
    sale_price numeric,
    date_of_purchase timestamp without time zone,
    date_of_sale timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    purchased_through character varying,
    sold_through character varying
);


--
-- Name: prior_ownerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE prior_ownerships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: prior_ownerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE prior_ownerships_id_seq OWNED BY prior_ownerships.id;


--
-- Name: publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publications (
    id integer NOT NULL,
    edition_id integer,
    source character varying,
    title character varying,
    author character varying,
    date timestamp without time zone,
    link text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publications_id_seq OWNED BY publications.id;


--
-- Name: records; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE records (
    id integer NOT NULL,
    model character varying DEFAULT ''::character varying NOT NULL,
    material character varying,
    system character varying DEFAULT 'standard'::character varying,
    size hstore DEFAULT '"depth"=>"{:standard=>0, :metric=>0}", "width"=>"{:standard=>0, :metric=>0}", "height"=>"{:standard=>0, :metric=>0}"'::hstore,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    weight hstore DEFAULT '"metric"=>"0", "standard"=>"0"'::hstore,
    medium character varying DEFAULT 'Painting'::character varying,
    year hstore DEFAULT '"value"=>NULL, "estimated"=>"false"'::hstore,
    duration hstore DEFAULT '"hours"=>"0", "minutes"=>"0", "seconds"=>"0"'::hstore
);


--
-- Name: records_artists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE records_artists (
    id integer NOT NULL,
    brand character varying DEFAULT ''::character varying NOT NULL,
    record_id integer,
    country character varying,
    founded integer,
    closed integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: records_artists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE records_artists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: records_artists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE records_artists_id_seq OWNED BY records_artists.id;


--
-- Name: records_collections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE records_collections (
    id integer NOT NULL,
    user_id integer,
    name character varying,
    public boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: records_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE records_collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: records_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE records_collections_id_seq OWNED BY records_collections.id;


--
-- Name: records_collections_lists; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE records_collections_lists (
    id integer NOT NULL,
    record_id integer,
    records_collection_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: records_collections_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE records_collections_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: records_collections_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE records_collections_lists_id_seq OWNED BY records_collections_lists.id;


--
-- Name: records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE records_id_seq OWNED BY records.id;


--
-- Name: records_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE records_users (
    id integer NOT NULL,
    record_id integer,
    user_id integer,
    owner boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: records_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE records_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: records_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE records_users_id_seq OWNED BY records_users.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    slug character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_profiles (
    id integer NOT NULL,
    user_id integer,
    first_name character varying,
    last_name character varying,
    mailing_address character varying,
    country character varying,
    city character varying,
    state character varying,
    zipcode character varying,
    phone character varying,
    alternative_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_profiles_id_seq OWNED BY user_profiles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    type character varying,
    authentication_token character varying,
    role_id integer,
    unit_system_id integer DEFAULT 2 NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    password_changed_at timestamp without time zone,
    username character varying,
    unique_session_id character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY appraisals ALTER COLUMN id SET DEFAULT nextval('appraisals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artists ALTER COLUMN id SET DEFAULT nextval('artists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY artwork_multiple_objects ALTER COLUMN id SET DEFAULT nextval('artwork_multiple_objects_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY attachments ALTER COLUMN id SET DEFAULT nextval('attachments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY base_unit_systems ALTER COLUMN id SET DEFAULT nextval('base_unit_systems_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY details_artworks ALTER COLUMN id SET DEFAULT nextval('details_artworks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY edition_admins ALTER COLUMN id SET DEFAULT nextval('edition_admins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions ALTER COLUMN id SET DEFAULT nextval('editions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions_tags ALTER COLUMN id SET DEFAULT nextval('editions_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY exhibition_histories ALTER COLUMN id SET DEFAULT nextval('exhibition_histories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY external_artworks ALTER COLUMN id SET DEFAULT nextval('external_artworks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY financial_informations ALTER COLUMN id SET DEFAULT nextval('financial_informations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY images ALTER COLUMN id SET DEFAULT nextval('images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY prior_ownerships ALTER COLUMN id SET DEFAULT nextval('prior_ownerships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY publications ALTER COLUMN id SET DEFAULT nextval('publications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY records ALTER COLUMN id SET DEFAULT nextval('records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_artists ALTER COLUMN id SET DEFAULT nextval('records_artists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_collections ALTER COLUMN id SET DEFAULT nextval('records_collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_collections_lists ALTER COLUMN id SET DEFAULT nextval('records_collections_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_users ALTER COLUMN id SET DEFAULT nextval('records_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles ALTER COLUMN id SET DEFAULT nextval('user_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: appraisals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY appraisals
    ADD CONSTRAINT appraisals_pkey PRIMARY KEY (id);


--
-- Name: artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artists
    ADD CONSTRAINT artists_pkey PRIMARY KEY (id);


--
-- Name: artwork_multiple_objects_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY artwork_multiple_objects
    ADD CONSTRAINT artwork_multiple_objects_pkey PRIMARY KEY (id);


--
-- Name: attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attachments
    ADD CONSTRAINT attachments_pkey PRIMARY KEY (id);


--
-- Name: base_unit_systems_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY base_unit_systems
    ADD CONSTRAINT base_unit_systems_pkey PRIMARY KEY (id);


--
-- Name: details_artworks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY details_artworks
    ADD CONSTRAINT details_artworks_pkey PRIMARY KEY (id);


--
-- Name: documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: edition_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY edition_admins
    ADD CONSTRAINT edition_admins_pkey PRIMARY KEY (id);


--
-- Name: editions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);


--
-- Name: editions_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY editions_tags
    ADD CONSTRAINT editions_tags_pkey PRIMARY KEY (id);


--
-- Name: exhibition_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY exhibition_histories
    ADD CONSTRAINT exhibition_histories_pkey PRIMARY KEY (id);


--
-- Name: external_artworks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY external_artworks
    ADD CONSTRAINT external_artworks_pkey PRIMARY KEY (id);


--
-- Name: financial_informations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY financial_informations
    ADD CONSTRAINT financial_informations_pkey PRIMARY KEY (id);


--
-- Name: images_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: prior_ownerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY prior_ownerships
    ADD CONSTRAINT prior_ownerships_pkey PRIMARY KEY (id);


--
-- Name: publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: records_artists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY records_artists
    ADD CONSTRAINT records_artists_pkey PRIMARY KEY (id);


--
-- Name: records_collections_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY records_collections_lists
    ADD CONSTRAINT records_collections_lists_pkey PRIMARY KEY (id);


--
-- Name: records_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY records_collections
    ADD CONSTRAINT records_collections_pkey PRIMARY KEY (id);


--
-- Name: records_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY records
    ADD CONSTRAINT records_pkey PRIMARY KEY (id);


--
-- Name: records_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY records_users
    ADD CONSTRAINT records_users_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_appraisals_on_financial_information_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_appraisals_on_financial_information_id ON appraisals USING btree (financial_information_id);


--
-- Name: index_artists_on_brand; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_artists_on_brand ON artists USING btree (brand);


--
-- Name: index_artwork_multiple_objects_on_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_artwork_multiple_objects_on_record_id ON artwork_multiple_objects USING btree (record_id);


--
-- Name: index_details_artworks_on_designer; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_details_artworks_on_designer ON details_artworks USING btree (designer);


--
-- Name: index_details_artworks_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_details_artworks_on_edition_id ON details_artworks USING btree (edition_id);


--
-- Name: index_details_artworks_on_manufacturer; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_details_artworks_on_manufacturer ON details_artworks USING btree (manufacturer);


--
-- Name: index_documents_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_documents_on_edition_id ON documents USING btree (edition_id);


--
-- Name: index_edition_admins_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_edition_admins_on_edition_id ON edition_admins USING btree (edition_id);


--
-- Name: index_editions_on_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_editions_on_record_id ON editions USING btree (record_id);


--
-- Name: index_editions_tags_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_editions_tags_on_edition_id ON editions_tags USING btree (edition_id);


--
-- Name: index_editions_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_editions_tags_on_tag_id ON editions_tags USING btree (tag_id);


--
-- Name: index_exhibition_histories_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_exhibition_histories_on_edition_id ON exhibition_histories USING btree (edition_id);


--
-- Name: index_external_artworks_on_artist_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_external_artworks_on_artist_id ON external_artworks USING btree (artist_id);


--
-- Name: index_external_artworks_on_model; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_external_artworks_on_model ON external_artworks USING btree (model);


--
-- Name: index_financial_informations_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_financial_informations_on_edition_id ON financial_informations USING btree (edition_id);


--
-- Name: index_images_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_images_on_edition_id ON images USING btree (edition_id);


--
-- Name: index_prior_ownerships_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_prior_ownerships_on_edition_id ON prior_ownerships USING btree (edition_id);


--
-- Name: index_publications_on_edition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_publications_on_edition_id ON publications USING btree (edition_id);


--
-- Name: index_records_artists_on_brand; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_artists_on_brand ON records_artists USING btree (brand);


--
-- Name: index_records_artists_on_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_artists_on_record_id ON records_artists USING btree (record_id);


--
-- Name: index_records_collections_lists_on_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_collections_lists_on_record_id ON records_collections_lists USING btree (record_id);


--
-- Name: index_records_collections_lists_on_records_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_collections_lists_on_records_collection_id ON records_collections_lists USING btree (records_collection_id);


--
-- Name: index_records_collections_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_collections_on_user_id ON records_collections USING btree (user_id);


--
-- Name: index_records_on_model; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_on_model ON records USING btree (model);


--
-- Name: index_records_users_on_record_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_users_on_record_id ON records_users USING btree (record_id);


--
-- Name: index_records_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_records_users_on_user_id ON records_users USING btree (user_id);


--
-- Name: index_user_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_profiles_on_user_id ON user_profiles USING btree (user_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_deleted_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_deleted_at ON users USING btree (deleted_at);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_password_changed_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_password_changed_at ON users USING btree (password_changed_at);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: index_users_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_username ON users USING btree (username);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_030b0b8053; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY images
    ADD CONSTRAINT fk_rails_030b0b8053 FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- Name: fk_rails_042a357c09; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY publications
    ADD CONSTRAINT fk_rails_042a357c09 FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- Name: fk_rails_0925e7b12d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_artists
    ADD CONSTRAINT fk_rails_0925e7b12d FOREIGN KEY (record_id) REFERENCES records(id);


--
-- Name: fk_rails_0ac322c774; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_collections_lists
    ADD CONSTRAINT fk_rails_0ac322c774 FOREIGN KEY (record_id) REFERENCES records(id);


--
-- Name: fk_rails_2082448997; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY external_artworks
    ADD CONSTRAINT fk_rails_2082448997 FOREIGN KEY (artist_id) REFERENCES artists(id);


--
-- Name: fk_rails_31f18c9b8d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY details_artworks
    ADD CONSTRAINT fk_rails_31f18c9b8d FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- Name: fk_rails_3b21cacdab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY appraisals
    ADD CONSTRAINT fk_rails_3b21cacdab FOREIGN KEY (financial_information_id) REFERENCES financial_informations(id);


--
-- Name: fk_rails_3bdc741e8a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY prior_ownerships
    ADD CONSTRAINT fk_rails_3bdc741e8a FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- Name: fk_rails_412a7d6759; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY exhibition_histories
    ADD CONSTRAINT fk_rails_412a7d6759 FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- Name: fk_rails_460bcde005; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY financial_informations
    ADD CONSTRAINT fk_rails_460bcde005 FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- Name: fk_rails_634d239f4e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions
    ADD CONSTRAINT fk_rails_634d239f4e FOREIGN KEY (record_id) REFERENCES records(id);


--
-- Name: fk_rails_6f00c0e32d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY artwork_multiple_objects
    ADD CONSTRAINT fk_rails_6f00c0e32d FOREIGN KEY (record_id) REFERENCES records(id);


--
-- Name: fk_rails_855e2726b3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions_tags
    ADD CONSTRAINT fk_rails_855e2726b3 FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: fk_rails_87a6352e58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_profiles
    ADD CONSTRAINT fk_rails_87a6352e58 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_a496b0d084; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY edition_admins
    ADD CONSTRAINT fk_rails_a496b0d084 FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- Name: fk_rails_a50e6b69a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_collections_lists
    ADD CONSTRAINT fk_rails_a50e6b69a9 FOREIGN KEY (records_collection_id) REFERENCES records_collections(id);


--
-- Name: fk_rails_a9b0ce9e2c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_collections
    ADD CONSTRAINT fk_rails_a9b0ce9e2c FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_b3fb3cf8a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_users
    ADD CONSTRAINT fk_rails_b3fb3cf8a9 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_cec68878c7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT fk_rails_cec68878c7 FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- Name: fk_rails_dccdc29435; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY records_users
    ADD CONSTRAINT fk_rails_dccdc29435 FOREIGN KEY (record_id) REFERENCES records(id);


--
-- Name: fk_rails_ddcc079c30; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY editions_tags
    ADD CONSTRAINT fk_rails_ddcc079c30 FOREIGN KEY (edition_id) REFERENCES editions(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150818083019');

INSERT INTO schema_migrations (version) VALUES ('20150818083020');

INSERT INTO schema_migrations (version) VALUES ('20150818083021');

INSERT INTO schema_migrations (version) VALUES ('20150818083022');

INSERT INTO schema_migrations (version) VALUES ('20150818083023');

INSERT INTO schema_migrations (version) VALUES ('20150818083024');

INSERT INTO schema_migrations (version) VALUES ('20150818083025');

INSERT INTO schema_migrations (version) VALUES ('20150818083026');

INSERT INTO schema_migrations (version) VALUES ('20150818083027');

INSERT INTO schema_migrations (version) VALUES ('20150818083028');

INSERT INTO schema_migrations (version) VALUES ('20150818083029');

INSERT INTO schema_migrations (version) VALUES ('20150818083032');

INSERT INTO schema_migrations (version) VALUES ('20150818083033');

INSERT INTO schema_migrations (version) VALUES ('20150818083034');

INSERT INTO schema_migrations (version) VALUES ('20150818083035');

INSERT INTO schema_migrations (version) VALUES ('20150818083036');

INSERT INTO schema_migrations (version) VALUES ('20150818124159');

INSERT INTO schema_migrations (version) VALUES ('20150818125423');

INSERT INTO schema_migrations (version) VALUES ('20150819091139');

INSERT INTO schema_migrations (version) VALUES ('20150819100909');

INSERT INTO schema_migrations (version) VALUES ('20150819130452');

INSERT INTO schema_migrations (version) VALUES ('20150819140713');

INSERT INTO schema_migrations (version) VALUES ('20150819141240');

INSERT INTO schema_migrations (version) VALUES ('20150819143159');

INSERT INTO schema_migrations (version) VALUES ('20150820093304');

INSERT INTO schema_migrations (version) VALUES ('20150820123953');

INSERT INTO schema_migrations (version) VALUES ('20150820124415');

INSERT INTO schema_migrations (version) VALUES ('20150825101304');

INSERT INTO schema_migrations (version) VALUES ('20150825121040');

INSERT INTO schema_migrations (version) VALUES ('20150826123005');

INSERT INTO schema_migrations (version) VALUES ('20150828125516');

INSERT INTO schema_migrations (version) VALUES ('20150903151135');

INSERT INTO schema_migrations (version) VALUES ('20150909074418');

INSERT INTO schema_migrations (version) VALUES ('20150909080858');

INSERT INTO schema_migrations (version) VALUES ('20150910092118');

INSERT INTO schema_migrations (version) VALUES ('20150910140416');

INSERT INTO schema_migrations (version) VALUES ('20150910143147');

INSERT INTO schema_migrations (version) VALUES ('20150914124115');

INSERT INTO schema_migrations (version) VALUES ('20150915130455');

INSERT INTO schema_migrations (version) VALUES ('20150916113050');

INSERT INTO schema_migrations (version) VALUES ('20150916150111');

INSERT INTO schema_migrations (version) VALUES ('20150921114622');

INSERT INTO schema_migrations (version) VALUES ('20150921234621');

INSERT INTO schema_migrations (version) VALUES ('20150922000614');

INSERT INTO schema_migrations (version) VALUES ('20150923080719');

INSERT INTO schema_migrations (version) VALUES ('20150930150105');

INSERT INTO schema_migrations (version) VALUES ('20151006095423');

INSERT INTO schema_migrations (version) VALUES ('20151023085353');

INSERT INTO schema_migrations (version) VALUES ('20151102140337');

INSERT INTO schema_migrations (version) VALUES ('20151110093650');


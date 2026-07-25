--
-- PostgreSQL database dump
--

\restrict 8y62lZX8MmAoWBu1LPVaEMXEPQPgvw4cRffgLwWA2uIa3IfQ63pYAnulc6stxdX

-- Dumped from database version 14.17
-- Dumped by pg_dump version 17.6

-- Started on 2026-07-25 09:41:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 2 (class 3079 OID 466358)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 3878 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 466430)
-- Name: acquisition_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acquisition_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.acquisition_types OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 466429)
-- Name: acquisition_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.acquisition_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.acquisition_types_id_seq OWNER TO postgres;

--
-- TOC entry 3879 (class 0 OID 0)
-- Dependencies: 217
-- Name: acquisition_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.acquisition_types_id_seq OWNED BY public.acquisition_types.id;


--
-- TOC entry 232 (class 1259 OID 466499)
-- Name: approval_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.approval_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.approval_types OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 466527)
-- Name: asset_brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_brands (
    id integer NOT NULL,
    asset_type_id integer NOT NULL,
    brand_type_id integer NOT NULL
);


ALTER TABLE public.asset_brands OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 466526)
-- Name: asset_brands_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_brands_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_brands_id_seq OWNER TO postgres;

--
-- TOC entry 3880 (class 0 OID 0)
-- Dependencies: 237
-- Name: asset_brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_brands_id_seq OWNED BY public.asset_brands.id;


--
-- TOC entry 277 (class 1259 OID 467028)
-- Name: asset_disposals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_disposals (
    id integer NOT NULL,
    registered_asset_id integer NOT NULL,
    disposal_type_id integer NOT NULL,
    event_notes text,
    event_register_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.asset_disposals OWNER TO postgres;

--
-- TOC entry 276 (class 1259 OID 467027)
-- Name: asset_disposals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_disposals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_disposals_id_seq OWNER TO postgres;

--
-- TOC entry 3881 (class 0 OID 0)
-- Dependencies: 276
-- Name: asset_disposals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_disposals_id_seq OWNED BY public.asset_disposals.id;


--
-- TOC entry 267 (class 1259 OID 466864)
-- Name: asset_evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_evaluations (
    id integer NOT NULL,
    registered_asset_id integer NOT NULL,
    evaluation_type_id integer NOT NULL,
    evaluated_value numeric(10,2) NOT NULL,
    event_notes text,
    event_register_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT asset_evaluations_evaluated_value_check CHECK ((evaluated_value > (0)::numeric))
);


ALTER TABLE public.asset_evaluations OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 466863)
-- Name: asset_evaluations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_evaluations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_evaluations_id_seq OWNER TO postgres;

--
-- TOC entry 3882 (class 0 OID 0)
-- Dependencies: 266
-- Name: asset_evaluations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_evaluations_id_seq OWNED BY public.asset_evaluations.id;


--
-- TOC entry 269 (class 1259 OID 466902)
-- Name: asset_incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_incidents (
    id integer NOT NULL,
    registered_asset_id integer NOT NULL,
    incident_type_id integer NOT NULL,
    event_notes text,
    incident_asset_image character varying(255),
    incident_police_report character varying(255),
    event_register_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.asset_incidents OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 466901)
-- Name: asset_incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_incidents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_incidents_id_seq OWNER TO postgres;

--
-- TOC entry 3883 (class 0 OID 0)
-- Dependencies: 268
-- Name: asset_incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_incidents_id_seq OWNED BY public.asset_incidents.id;


--
-- TOC entry 263 (class 1259 OID 466798)
-- Name: asset_issuance_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_issuance_items (
    id integer NOT NULL,
    registered_asset_id integer NOT NULL,
    asset_issuance_id integer NOT NULL
);


ALTER TABLE public.asset_issuance_items OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 466797)
-- Name: asset_issuance_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_issuance_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_issuance_items_id_seq OWNER TO postgres;

--
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 262
-- Name: asset_issuance_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_issuance_items_id_seq OWNED BY public.asset_issuance_items.id;


--
-- TOC entry 261 (class 1259 OID 466766)
-- Name: asset_issuances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_issuances (
    id integer NOT NULL,
    receiving_staff_id integer NOT NULL,
    notes text,
    event_register_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    issuance_type_id integer NOT NULL
);


ALTER TABLE public.asset_issuances OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 466765)
-- Name: asset_issuances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_issuances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_issuances_id_seq OWNER TO postgres;

--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 260
-- Name: asset_issuances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_issuances_id_seq OWNED BY public.asset_issuances.id;


--
-- TOC entry 240 (class 1259 OID 466546)
-- Name: asset_models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_models (
    id integer NOT NULL,
    asset_brand_id integer NOT NULL,
    model_type_id integer NOT NULL
);


ALTER TABLE public.asset_models OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 466545)
-- Name: asset_models_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_models_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_models_id_seq OWNER TO postgres;

--
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 239
-- Name: asset_models_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_models_id_seq OWNED BY public.asset_models.id;


--
-- TOC entry 275 (class 1259 OID 466991)
-- Name: asset_placements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_placements (
    id integer NOT NULL,
    registered_asset_id integer NOT NULL,
    placement_type_id integer NOT NULL,
    event_notes text,
    event_register_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.asset_placements OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 466990)
-- Name: asset_placements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_placements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_placements_id_seq OWNER TO postgres;

--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 274
-- Name: asset_placements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_placements_id_seq OWNED BY public.asset_placements.id;


--
-- TOC entry 253 (class 1259 OID 466643)
-- Name: asset_registrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_registrations (
    id integer NOT NULL,
    acquisition_type_id integer NOT NULL,
    reference_attachment character varying(255) NOT NULL,
    reference_type_id integer NOT NULL,
    supplier_id integer NOT NULL,
    notes text,
    event_register_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    reference_date date NOT NULL,
    program_id integer NOT NULL
);


ALTER TABLE public.asset_registrations OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 466642)
-- Name: asset_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_registrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_registrations_id_seq OWNER TO postgres;

--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 252
-- Name: asset_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_registrations_id_seq OWNED BY public.asset_registrations.id;


--
-- TOC entry 273 (class 1259 OID 466971)
-- Name: asset_request_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_request_items (
    id integer NOT NULL,
    asset_request_id integer NOT NULL,
    requested_asset_type_id integer NOT NULL,
    requested_quantity integer NOT NULL,
    CONSTRAINT asset_request_items_requested_quantity_check CHECK ((requested_quantity > 0))
);


ALTER TABLE public.asset_request_items OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 466970)
-- Name: asset_request_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_request_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_request_items_id_seq OWNER TO postgres;

--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 272
-- Name: asset_request_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_request_items_id_seq OWNED BY public.asset_request_items.id;


--
-- TOC entry 271 (class 1259 OID 466939)
-- Name: asset_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_requests (
    id integer NOT NULL,
    event_notes text,
    event_register_id integer NOT NULL,
    request_program_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.asset_requests OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 466938)
-- Name: asset_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_requests_id_seq OWNER TO postgres;

--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 270
-- Name: asset_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_requests_id_seq OWNED BY public.asset_requests.id;


--
-- TOC entry 259 (class 1259 OID 466747)
-- Name: asset_transfer_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_transfer_items (
    id integer NOT NULL,
    asset_transfer_id integer NOT NULL,
    registered_asset_id integer NOT NULL
);


ALTER TABLE public.asset_transfer_items OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 466746)
-- Name: asset_transfer_items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_transfer_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_transfer_items_id_seq OWNER TO postgres;

--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 258
-- Name: asset_transfer_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_transfer_items_id_seq OWNED BY public.asset_transfer_items.id;


--
-- TOC entry 257 (class 1259 OID 466714)
-- Name: asset_transfers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_transfers (
    id integer NOT NULL,
    receiving_station_id integer NOT NULL,
    notes text,
    event_register_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT asset_transfers_check CHECK ((event_station_id <> receiving_station_id))
);


ALTER TABLE public.asset_transfers OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 466713)
-- Name: asset_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_transfers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_transfers_id_seq OWNER TO postgres;

--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 256
-- Name: asset_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_transfers_id_seq OWNED BY public.asset_transfers.id;


--
-- TOC entry 212 (class 1259 OID 466403)
-- Name: asset_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.asset_types OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 466402)
-- Name: asset_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_types_id_seq OWNER TO postgres;

--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 211
-- Name: asset_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_types_id_seq OWNED BY public.asset_types.id;


--
-- TOC entry 265 (class 1259 OID 466822)
-- Name: asset_verifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.asset_verifications (
    id integer NOT NULL,
    registered_asset_id integer NOT NULL,
    verification_type_id integer NOT NULL,
    verified_condition_type_id integer NOT NULL,
    event_notes text,
    event_register_id integer NOT NULL,
    event_station_id integer NOT NULL,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.asset_verifications OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 466821)
-- Name: asset_verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.asset_verifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asset_verifications_id_seq OWNER TO postgres;

--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 264
-- Name: asset_verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.asset_verifications_id_seq OWNED BY public.asset_verifications.id;


--
-- TOC entry 214 (class 1259 OID 466412)
-- Name: brand_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brand_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.brand_types OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 466448)
-- Name: condition_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.condition_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.condition_types OWNER TO postgres;

--
-- TOC entry 279 (class 1259 OID 467065)
-- Name: event_approvals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_approvals (
    id integer NOT NULL,
    event_register_id integer NOT NULL,
    approval_type_id integer NOT NULL,
    approval_notes text,
    event_admin_id integer NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.event_approvals OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 466421)
-- Name: model_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.model_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.model_types OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 466685)
-- Name: registered_assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registered_assets (
    id integer NOT NULL,
    asset_registration_id integer NOT NULL,
    asset_model_id integer NOT NULL,
    serial_number character varying(255) NOT NULL,
    asset_number character varying(255),
    condition_type_id integer NOT NULL,
    acquisition_value numeric(10,2) NOT NULL,
    CONSTRAINT registered_assets_acquisition_value_check CHECK ((acquisition_value > (0)::numeric))
);


ALTER TABLE public.registered_assets OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 466564)
-- Name: staff_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_profiles (
    id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    staff_email character varying(255) NOT NULL,
    staff_phone character varying(255) NOT NULL
);


ALTER TABLE public.staff_profiles OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 466516)
-- Name: stations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stations (
    id integer NOT NULL,
    station_code character varying(255) NOT NULL,
    station_name character varying(255) NOT NULL,
    latitude numeric(10,8),
    longitude numeric(11,8),
    level integer
);


ALTER TABLE public.stations OWNER TO postgres;

--
-- TOC entry 283 (class 1259 OID 490543)
-- Name: assets_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.assets_view AS
 SELECT registered_assets.id AS asset_id,
    asset_types.name AS asset_type,
    brand_types.name AS brand,
    model_types.name AS model,
    registered_assets.asset_number,
    registered_assets.serial_number,
    COALESCE(latest_condition.name, reg_condition.name) AS condition,
    COALESCE(latest_value.evaluated_value, registered_assets.acquisition_value) AS current_value,
    COALESCE(latest_custodian.staff_id, asset_registrations.event_admin_id) AS custodian_id,
    COALESCE(latest_custodian.full_name, reg_admin.full_name) AS custodian,
    COALESCE(latest_location.receiving_station_id, asset_registrations.event_station_id) AS station_id,
    COALESCE(latest_location.station_name, reg_station.station_name) AS station_name,
    (EXISTS ( SELECT 1
           FROM (public.asset_disposals
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_disposals.event_register_id) AND (event_approvals.approval_type_id = 50))))
          WHERE (asset_disposals.registered_asset_id = registered_assets.id))) AS disposed
   FROM ((((((((((((((public.registered_assets
     JOIN public.asset_registrations ON ((asset_registrations.id = registered_assets.asset_registration_id)))
     JOIN public.event_approvals reg_approval ON (((reg_approval.event_register_id = asset_registrations.event_register_id) AND (reg_approval.approval_type_id = 50))))
     JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
     JOIN public.model_types ON ((model_types.id = asset_models.model_type_id)))
     JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
     JOIN public.brand_types ON ((brand_types.id = asset_brands.brand_type_id)))
     JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
     JOIN public.condition_types reg_condition ON ((reg_condition.id = registered_assets.condition_type_id)))
     JOIN public.stations reg_station ON ((reg_station.id = asset_registrations.event_station_id)))
     JOIN public.staff_profiles reg_admin ON ((reg_admin.id = asset_registrations.event_admin_id)))
     LEFT JOIN LATERAL ( SELECT asset_transfers.receiving_station_id,
            stations.station_name
           FROM (((public.asset_transfer_items
             JOIN public.asset_transfers ON ((asset_transfers.id = asset_transfer_items.asset_transfer_id)))
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_transfers.event_register_id) AND (event_approvals.approval_type_id = 10))))
             JOIN public.stations ON ((stations.id = asset_transfers.receiving_station_id)))
          WHERE (asset_transfer_items.registered_asset_id = registered_assets.id)
          ORDER BY asset_transfers.stamp DESC
         LIMIT 1) latest_location ON (true))
     LEFT JOIN LATERAL ( SELECT condition_types.name
           FROM ((public.asset_verifications
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_verifications.event_register_id) AND (event_approvals.approval_type_id = 50))))
             JOIN public.condition_types ON ((condition_types.id = asset_verifications.verified_condition_type_id)))
          WHERE (asset_verifications.registered_asset_id = registered_assets.id)
          ORDER BY asset_verifications.stamp DESC
         LIMIT 1) latest_condition ON (true))
     LEFT JOIN LATERAL ( SELECT asset_evaluations.evaluated_value
           FROM (public.asset_evaluations
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_evaluations.event_register_id) AND (event_approvals.approval_type_id = 50))))
          WHERE (asset_evaluations.registered_asset_id = registered_assets.id)
          ORDER BY asset_evaluations.stamp DESC
         LIMIT 1) latest_value ON (true))
     LEFT JOIN LATERAL ( SELECT staff_profiles.id AS staff_id,
            staff_profiles.full_name
           FROM (((public.asset_issuance_items
             JOIN public.asset_issuances ON ((asset_issuances.id = asset_issuance_items.asset_issuance_id)))
             JOIN public.event_approvals ON (((event_approvals.event_register_id = asset_issuances.event_register_id) AND (event_approvals.approval_type_id = 10))))
             JOIN public.staff_profiles ON ((staff_profiles.id = asset_issuances.receiving_staff_id)))
          WHERE (asset_issuance_items.registered_asset_id = registered_assets.id)
          ORDER BY asset_issuances.stamp DESC
         LIMIT 1) latest_custodian ON (true));


ALTER VIEW public.assets_view OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 466411)
-- Name: brand_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.brand_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.brand_types_id_seq OWNER TO postgres;

--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 213
-- Name: brand_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.brand_types_id_seq OWNED BY public.brand_types.id;


--
-- TOC entry 221 (class 1259 OID 466447)
-- Name: condition_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.condition_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.condition_types_id_seq OWNER TO postgres;

--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 221
-- Name: condition_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.condition_types_id_seq OWNED BY public.condition_types.id;


--
-- TOC entry 234 (class 1259 OID 466507)
-- Name: disposal_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.disposal_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.disposal_types OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 466506)
-- Name: disposal_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.disposal_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.disposal_types_id_seq OWNER TO postgres;

--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 233
-- Name: disposal_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.disposal_types_id_seq OWNED BY public.disposal_types.id;


--
-- TOC entry 224 (class 1259 OID 466457)
-- Name: evaluation_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluation_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.evaluation_types OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 466456)
-- Name: evaluation_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evaluation_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.evaluation_types_id_seq OWNER TO postgres;

--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 223
-- Name: evaluation_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evaluation_types_id_seq OWNED BY public.evaluation_types.id;


--
-- TOC entry 278 (class 1259 OID 467064)
-- Name: event_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_approvals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_approvals_id_seq OWNER TO postgres;

--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 278
-- Name: event_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_approvals_id_seq OWNED BY public.event_approvals.id;


--
-- TOC entry 251 (class 1259 OID 466636)
-- Name: event_register; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.event_register (
    id integer NOT NULL
);


ALTER TABLE public.event_register OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 466635)
-- Name: event_register_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_register_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.event_register_id_seq OWNER TO postgres;

--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 250
-- Name: event_register_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_register_id_seq OWNED BY public.event_register.id;


--
-- TOC entry 228 (class 1259 OID 466475)
-- Name: incident_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incident_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.incident_types OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 466491)
-- Name: placement_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.placement_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.placement_types OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 466616)
-- Name: programs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.programs (
    id integer NOT NULL,
    program_code character varying(255) NOT NULL,
    program_name character varying(255) NOT NULL
);


ALTER TABLE public.programs OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 466627)
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    supplier_name character varying(255) NOT NULL
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 466466)
-- Name: verification_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.verification_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.verification_types OWNER TO postgres;

--
-- TOC entry 282 (class 1259 OID 490533)
-- Name: events_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.events_view AS
 SELECT events.entity_id,
    events.event_id,
    events.station_id,
    events.admin_id,
    events.event_date,
    events.stamp,
    events.event_type,
    events.details,
    stations.station_name,
    staff_profiles.full_name AS admin_name,
    COALESCE(approval_types.name, 'Pending'::character varying) AS latest_approval,
    COALESCE(event_approvals.approval_type_id, 0) AS latest_approval_type_id,
    event_approvals.approval_notes AS latest_approval_notes,
    event_approvals.event_admin_id AS latest_approver_id,
    staff_profiles2.full_name AS latest_approver_name,
    event_approvals.stamp AS latest_approval_stamp
   FROM (((((( SELECT asset_registrations.id AS entity_id,
            asset_registrations.event_register_id AS event_id,
            asset_registrations.event_station_id AS station_id,
            asset_registrations.event_admin_id AS admin_id,
            (asset_registrations.stamp)::date AS event_date,
            asset_registrations.stamp,
            'Registration'::text AS event_type,
            ((((('Registration of '::text || (( SELECT count(*) AS count
                   FROM public.registered_assets
                  WHERE (registered_assets.asset_registration_id = asset_registrations.id)))::text) || ' item(s) from '::text) || (suppliers.supplier_name)::text) || ' via '::text) || (acquisition_types.name)::text) AS details
           FROM ((public.asset_registrations
             JOIN public.suppliers ON ((suppliers.id = asset_registrations.supplier_id)))
             JOIN public.acquisition_types ON ((acquisition_types.id = asset_registrations.acquisition_type_id)))
        UNION ALL
         SELECT asset_transfers.id,
            asset_transfers.event_register_id,
            asset_transfers.event_station_id,
            asset_transfers.event_admin_id,
            (asset_transfers.stamp)::date AS stamp,
            asset_transfers.stamp,
            'Transfer'::text,
            ((('Transfer of '::text || (( SELECT count(*) AS count
                   FROM public.asset_transfer_items
                  WHERE (asset_transfer_items.asset_transfer_id = asset_transfers.id)))::text) || ' item(s) to '::text) || (receiving_station.station_name)::text)
           FROM (public.asset_transfers
             JOIN public.stations receiving_station ON ((receiving_station.id = asset_transfers.receiving_station_id)))
        UNION ALL
         SELECT asset_issuances.id,
            asset_issuances.event_register_id,
            asset_issuances.event_station_id,
            asset_issuances.event_admin_id,
            (asset_issuances.stamp)::date AS stamp,
            asset_issuances.stamp,
            'Issuance'::text,
            ((('Issuance of '::text || (( SELECT count(*) AS count
                   FROM public.asset_issuance_items
                  WHERE (asset_issuance_items.asset_issuance_id = asset_issuances.id)))::text) || ' item(s) to '::text) || (receiving_staff.full_name)::text)
           FROM (public.asset_issuances
             JOIN public.staff_profiles receiving_staff ON ((receiving_staff.id = asset_issuances.receiving_staff_id)))
        UNION ALL
         SELECT asset_verifications.id,
            asset_verifications.event_register_id,
            asset_verifications.event_station_id,
            asset_verifications.event_admin_id,
            (asset_verifications.stamp)::date AS stamp,
            asset_verifications.stamp,
            'Verification'::text,
            ((((((('Condition update of '::text || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text) || ' to '::text) || (condition_types.name)::text) || ' via '::text) || (verification_types.name)::text)
           FROM ((((((public.asset_verifications
             JOIN public.registered_assets ON ((registered_assets.id = asset_verifications.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.condition_types ON ((condition_types.id = asset_verifications.verified_condition_type_id)))
             JOIN public.verification_types ON ((verification_types.id = asset_verifications.verification_type_id)))
        UNION ALL
         SELECT asset_evaluations.id,
            asset_evaluations.event_register_id,
            asset_evaluations.event_station_id,
            asset_evaluations.event_admin_id,
            (asset_evaluations.stamp)::date AS stamp,
            asset_evaluations.stamp,
            'Evaluation'::text,
            ((((((('Value update of '::text || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text) || ' to '::text) || (asset_evaluations.evaluated_value)::text) || ' as '::text) || (evaluation_types.name)::text)
           FROM (((((public.asset_evaluations
             JOIN public.registered_assets ON ((registered_assets.id = asset_evaluations.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.evaluation_types ON ((evaluation_types.id = asset_evaluations.evaluation_type_id)))
        UNION ALL
         SELECT asset_incidents.id,
            asset_incidents.event_register_id,
            asset_incidents.event_station_id,
            asset_incidents.event_admin_id,
            (asset_incidents.stamp)::date AS stamp,
            asset_incidents.stamp,
            'Incident'::text,
            (((((incident_types.name)::text || ' of '::text) || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text)
           FROM (((((public.asset_incidents
             JOIN public.registered_assets ON ((registered_assets.id = asset_incidents.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.incident_types ON ((incident_types.id = asset_incidents.incident_type_id)))
        UNION ALL
         SELECT asset_requests.id,
            asset_requests.event_register_id,
            asset_requests.event_station_id,
            asset_requests.event_admin_id,
            (asset_requests.stamp)::date AS stamp,
            asset_requests.stamp,
            'Request'::text,
            ((('Asset request for '::text || (( SELECT count(*) AS count
                   FROM public.asset_request_items
                  WHERE (asset_request_items.asset_request_id = asset_requests.id)))::text) || ' type(s) under '::text) || (programs.program_name)::text)
           FROM (public.asset_requests
             JOIN public.programs ON ((programs.id = asset_requests.request_program_id)))
        UNION ALL
         SELECT asset_placements.id,
            asset_placements.event_register_id,
            asset_placements.event_station_id,
            asset_placements.event_admin_id,
            (asset_placements.stamp)::date AS stamp,
            asset_placements.stamp,
            'Placement'::text,
            ((((('Placement change of '::text || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text) || ' to '::text) || (placement_types.name)::text)
           FROM (((((public.asset_placements
             JOIN public.registered_assets ON ((registered_assets.id = asset_placements.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.placement_types ON ((placement_types.id = asset_placements.placement_type_id)))
        UNION ALL
         SELECT asset_disposals.id,
            asset_disposals.event_register_id,
            asset_disposals.event_station_id,
            asset_disposals.event_admin_id,
            (asset_disposals.stamp)::date AS stamp,
            asset_disposals.stamp,
            'Disposal'::text,
            ((((('Disposal of '::text || (asset_types.name)::text) || ' '::text) || (COALESCE(registered_assets.asset_number, registered_assets.serial_number))::text) || ' via '::text) || (disposal_types.name)::text)
           FROM (((((public.asset_disposals
             JOIN public.registered_assets ON ((registered_assets.id = asset_disposals.registered_asset_id)))
             JOIN public.asset_models ON ((asset_models.id = registered_assets.asset_model_id)))
             JOIN public.asset_brands ON ((asset_brands.id = asset_models.asset_brand_id)))
             JOIN public.asset_types ON ((asset_types.id = asset_brands.asset_type_id)))
             JOIN public.disposal_types ON ((disposal_types.id = asset_disposals.disposal_type_id)))) events
     JOIN public.stations ON ((stations.id = events.station_id)))
     JOIN public.staff_profiles ON ((staff_profiles.id = events.admin_id)))
     LEFT JOIN LATERAL ( SELECT t1.id,
            t1.event_register_id,
            t1.approval_type_id,
            t1.approval_notes,
            t1.event_admin_id,
            t1.stamp
           FROM public.event_approvals t1
          WHERE (t1.event_register_id = events.event_id)
          ORDER BY t1.stamp DESC
         LIMIT 1) event_approvals ON (true))
     LEFT JOIN public.approval_types ON ((approval_types.id = event_approvals.approval_type_id)))
     LEFT JOIN public.staff_profiles staff_profiles2 ON ((staff_profiles2.id = event_approvals.event_admin_id)));


ALTER VIEW public.events_view OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 466474)
-- Name: incident_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incident_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.incident_types_id_seq OWNER TO postgres;

--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 227
-- Name: incident_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incident_types_id_seq OWNED BY public.incident_types.id;


--
-- TOC entry 229 (class 1259 OID 466483)
-- Name: issuance_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issuance_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.issuance_types OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 466420)
-- Name: model_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.model_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.model_types_id_seq OWNER TO postgres;

--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 215
-- Name: model_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.model_types_id_seq OWNED BY public.model_types.id;


--
-- TOC entry 230 (class 1259 OID 466490)
-- Name: placement_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.placement_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.placement_types_id_seq OWNER TO postgres;

--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 230
-- Name: placement_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.placement_types_id_seq OWNED BY public.placement_types.id;


--
-- TOC entry 246 (class 1259 OID 466615)
-- Name: programs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.programs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.programs_id_seq OWNER TO postgres;

--
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 246
-- Name: programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.programs_id_seq OWNED BY public.programs.id;


--
-- TOC entry 220 (class 1259 OID 466439)
-- Name: reference_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reference_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.reference_types OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 466438)
-- Name: reference_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reference_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reference_types_id_seq OWNER TO postgres;

--
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 219
-- Name: reference_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reference_types_id_seq OWNED BY public.reference_types.id;


--
-- TOC entry 254 (class 1259 OID 466684)
-- Name: registered_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.registered_assets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.registered_assets_id_seq OWNER TO postgres;

--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 254
-- Name: registered_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.registered_assets_id_seq OWNED BY public.registered_assets.id;


--
-- TOC entry 210 (class 1259 OID 466395)
-- Name: role_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_types (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.role_types OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 466576)
-- Name: staff_accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_accounts (
    id integer NOT NULL,
    staff_profile_id integer NOT NULL,
    secret_key text NOT NULL
);


ALTER TABLE public.staff_accounts OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 466575)
-- Name: staff_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_accounts_id_seq OWNER TO postgres;

--
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 242
-- Name: staff_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_accounts_id_seq OWNED BY public.staff_accounts.id;


--
-- TOC entry 245 (class 1259 OID 466592)
-- Name: staff_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_roles (
    id integer NOT NULL,
    staff_profile_id integer NOT NULL,
    role_type_id integer NOT NULL,
    role_station_id integer NOT NULL
);


ALTER TABLE public.staff_roles OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 466591)
-- Name: staff_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_roles_id_seq OWNER TO postgres;

--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 244
-- Name: staff_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_roles_id_seq OWNED BY public.staff_roles.id;


--
-- TOC entry 235 (class 1259 OID 466515)
-- Name: stations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stations_id_seq OWNER TO postgres;

--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 235
-- Name: stations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stations_id_seq OWNED BY public.stations.id;


--
-- TOC entry 248 (class 1259 OID 466626)
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.suppliers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.suppliers_id_seq OWNER TO postgres;

--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 248
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- TOC entry 281 (class 1259 OID 467092)
-- Name: updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.updates (
    id integer NOT NULL,
    notes text,
    staff_id integer NOT NULL,
    seen boolean DEFAULT false NOT NULL,
    stamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.updates OWNER TO postgres;

--
-- TOC entry 280 (class 1259 OID 467091)
-- Name: updates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.updates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.updates_id_seq OWNER TO postgres;

--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 280
-- Name: updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.updates_id_seq OWNED BY public.updates.id;


--
-- TOC entry 225 (class 1259 OID 466465)
-- Name: verification_types_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.verification_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.verification_types_id_seq OWNER TO postgres;

--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 225
-- Name: verification_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.verification_types_id_seq OWNED BY public.verification_types.id;


--
-- TOC entry 3393 (class 2604 OID 466433)
-- Name: acquisition_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acquisition_types ALTER COLUMN id SET DEFAULT nextval('public.acquisition_types_id_seq'::regclass);


--
-- TOC entry 3402 (class 2604 OID 466530)
-- Name: asset_brands id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_brands ALTER COLUMN id SET DEFAULT nextval('public.asset_brands_id_seq'::regclass);


--
-- TOC entry 3429 (class 2604 OID 467031)
-- Name: asset_disposals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_disposals ALTER COLUMN id SET DEFAULT nextval('public.asset_disposals_id_seq'::regclass);


--
-- TOC entry 3420 (class 2604 OID 466867)
-- Name: asset_evaluations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_evaluations ALTER COLUMN id SET DEFAULT nextval('public.asset_evaluations_id_seq'::regclass);


--
-- TOC entry 3422 (class 2604 OID 466905)
-- Name: asset_incidents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_incidents ALTER COLUMN id SET DEFAULT nextval('public.asset_incidents_id_seq'::regclass);


--
-- TOC entry 3417 (class 2604 OID 466801)
-- Name: asset_issuance_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuance_items ALTER COLUMN id SET DEFAULT nextval('public.asset_issuance_items_id_seq'::regclass);


--
-- TOC entry 3415 (class 2604 OID 466769)
-- Name: asset_issuances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuances ALTER COLUMN id SET DEFAULT nextval('public.asset_issuances_id_seq'::regclass);


--
-- TOC entry 3403 (class 2604 OID 466549)
-- Name: asset_models id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_models ALTER COLUMN id SET DEFAULT nextval('public.asset_models_id_seq'::regclass);


--
-- TOC entry 3427 (class 2604 OID 466994)
-- Name: asset_placements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_placements ALTER COLUMN id SET DEFAULT nextval('public.asset_placements_id_seq'::regclass);


--
-- TOC entry 3409 (class 2604 OID 466646)
-- Name: asset_registrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations ALTER COLUMN id SET DEFAULT nextval('public.asset_registrations_id_seq'::regclass);


--
-- TOC entry 3426 (class 2604 OID 466974)
-- Name: asset_request_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_request_items ALTER COLUMN id SET DEFAULT nextval('public.asset_request_items_id_seq'::regclass);


--
-- TOC entry 3424 (class 2604 OID 466942)
-- Name: asset_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests ALTER COLUMN id SET DEFAULT nextval('public.asset_requests_id_seq'::regclass);


--
-- TOC entry 3414 (class 2604 OID 466750)
-- Name: asset_transfer_items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfer_items ALTER COLUMN id SET DEFAULT nextval('public.asset_transfer_items_id_seq'::regclass);


--
-- TOC entry 3412 (class 2604 OID 466717)
-- Name: asset_transfers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers ALTER COLUMN id SET DEFAULT nextval('public.asset_transfers_id_seq'::regclass);


--
-- TOC entry 3390 (class 2604 OID 466406)
-- Name: asset_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_types ALTER COLUMN id SET DEFAULT nextval('public.asset_types_id_seq'::regclass);


--
-- TOC entry 3418 (class 2604 OID 466825)
-- Name: asset_verifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications ALTER COLUMN id SET DEFAULT nextval('public.asset_verifications_id_seq'::regclass);


--
-- TOC entry 3391 (class 2604 OID 466415)
-- Name: brand_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand_types ALTER COLUMN id SET DEFAULT nextval('public.brand_types_id_seq'::regclass);


--
-- TOC entry 3395 (class 2604 OID 466451)
-- Name: condition_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condition_types ALTER COLUMN id SET DEFAULT nextval('public.condition_types_id_seq'::regclass);


--
-- TOC entry 3400 (class 2604 OID 466510)
-- Name: disposal_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disposal_types ALTER COLUMN id SET DEFAULT nextval('public.disposal_types_id_seq'::regclass);


--
-- TOC entry 3396 (class 2604 OID 466460)
-- Name: evaluation_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_types ALTER COLUMN id SET DEFAULT nextval('public.evaluation_types_id_seq'::regclass);


--
-- TOC entry 3431 (class 2604 OID 467068)
-- Name: event_approvals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_approvals ALTER COLUMN id SET DEFAULT nextval('public.event_approvals_id_seq'::regclass);


--
-- TOC entry 3408 (class 2604 OID 466639)
-- Name: event_register id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_register ALTER COLUMN id SET DEFAULT nextval('public.event_register_id_seq'::regclass);


--
-- TOC entry 3398 (class 2604 OID 466478)
-- Name: incident_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_types ALTER COLUMN id SET DEFAULT nextval('public.incident_types_id_seq'::regclass);


--
-- TOC entry 3392 (class 2604 OID 466424)
-- Name: model_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_types ALTER COLUMN id SET DEFAULT nextval('public.model_types_id_seq'::regclass);


--
-- TOC entry 3399 (class 2604 OID 466494)
-- Name: placement_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placement_types ALTER COLUMN id SET DEFAULT nextval('public.placement_types_id_seq'::regclass);


--
-- TOC entry 3406 (class 2604 OID 466619)
-- Name: programs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programs ALTER COLUMN id SET DEFAULT nextval('public.programs_id_seq'::regclass);


--
-- TOC entry 3394 (class 2604 OID 466442)
-- Name: reference_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reference_types ALTER COLUMN id SET DEFAULT nextval('public.reference_types_id_seq'::regclass);


--
-- TOC entry 3411 (class 2604 OID 466688)
-- Name: registered_assets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registered_assets ALTER COLUMN id SET DEFAULT nextval('public.registered_assets_id_seq'::regclass);


--
-- TOC entry 3404 (class 2604 OID 466579)
-- Name: staff_accounts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_accounts ALTER COLUMN id SET DEFAULT nextval('public.staff_accounts_id_seq'::regclass);


--
-- TOC entry 3405 (class 2604 OID 466595)
-- Name: staff_roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_roles ALTER COLUMN id SET DEFAULT nextval('public.staff_roles_id_seq'::regclass);


--
-- TOC entry 3401 (class 2604 OID 466519)
-- Name: stations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stations ALTER COLUMN id SET DEFAULT nextval('public.stations_id_seq'::regclass);


--
-- TOC entry 3407 (class 2604 OID 466630)
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- TOC entry 3433 (class 2604 OID 467095)
-- Name: updates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.updates ALTER COLUMN id SET DEFAULT nextval('public.updates_id_seq'::regclass);


--
-- TOC entry 3397 (class 2604 OID 466469)
-- Name: verification_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_types ALTER COLUMN id SET DEFAULT nextval('public.verification_types_id_seq'::regclass);


--
-- TOC entry 3808 (class 0 OID 466430)
-- Dependencies: 218
-- Data for Name: acquisition_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.acquisition_types (id, name) FROM stdin;
1	Purchase
2	Grant
3	Donation
4	Other
5	Migration
\.


--
-- TOC entry 3822 (class 0 OID 466499)
-- Dependencies: 232
-- Data for Name: approval_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.approval_types (id, name) FROM stdin;
20	Admin Approved
21	Admin Rejected
40	Supervisor Approved
41	Supervisor Rejected
50	Manager Approved
51	Manager Rejected
10	Recipient Accepted
11	Recipient Rejected
\.


--
-- TOC entry 3828 (class 0 OID 466527)
-- Dependencies: 238
-- Data for Name: asset_brands; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_brands (id, asset_type_id, brand_type_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	2	2
6	2	5
8	3	1
9	2	6
12	87	6
16	63	9
17	56	9
18	84	9
19	64	9
20	68	9
21	74	9
22	71	9
23	61	9
24	88	9
25	4	9
26	78	9
29	86	9
31	4	1
32	82	9
33	83	9
34	75	9
35	58	9
36	60	9
37	90	16
38	66	9
40	57	9
41	77	14
42	78	14
43	59	9
44	90	17
45	62	9
46	79	15
47	2	10
48	71	12
49	70	9
50	71	1
51	76	9
52	69	9
53	73	9
54	93	9
55	65	9
56	89	9
57	81	9
58	5	1
59	77	9
60	85	9
61	87	2
62	79	9
63	91	9
64	80	9
65	67	9
66	72	13
67	1	9
68	92	9
\.


--
-- TOC entry 3867 (class 0 OID 467028)
-- Dependencies: 277
-- Data for Name: asset_disposals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_disposals (id, registered_asset_id, disposal_type_id, event_notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.


--
-- TOC entry 3857 (class 0 OID 466864)
-- Dependencies: 267
-- Data for Name: asset_evaluations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_evaluations (id, registered_asset_id, evaluation_type_id, evaluated_value, event_notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.


--
-- TOC entry 3859 (class 0 OID 466902)
-- Dependencies: 269
-- Data for Name: asset_incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_incidents (id, registered_asset_id, incident_type_id, event_notes, incident_asset_image, incident_police_report, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.


--
-- TOC entry 3853 (class 0 OID 466798)
-- Dependencies: 263
-- Data for Name: asset_issuance_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_issuance_items (id, registered_asset_id, asset_issuance_id) FROM stdin;
8	12	3
9	526	3
10	1575	3
11	13	4
12	14	4
13	15	4
14	81	4
15	532	4
16	709	4
17	846	4
18	1577	4
19	1578	4
20	1579	4
21	1580	4
22	1581	4
23	1582	4
24	1583	4
25	1783	4
26	2173	4
27	2236	4
28	2278	4
29	2425	4
30	16	5
31	116	5
32	123	5
33	466	5
34	515	5
35	736	5
36	737	5
37	797	5
38	890	5
39	1013	5
40	1640	5
41	1700	5
42	1716	5
43	1745	5
44	1833	5
45	1834	5
46	2182	5
47	2183	5
48	2321	5
49	2322	5
50	2423	5
51	17	6
52	746	6
53	854	6
54	1024	6
55	1631	6
56	1853	6
57	1854	6
58	2186	6
59	2343	6
60	2344	6
61	18	7
62	578	7
63	579	7
64	580	7
65	581	7
66	582	7
67	583	7
68	584	7
69	771	7
70	820	7
71	1037	7
72	1038	7
73	1572	7
74	1769	7
75	1974	7
76	2165	7
77	2267	7
78	2365	7
79	2366	7
80	2367	7
81	2368	7
82	2369	7
83	2370	7
84	2371	7
85	19	8
86	28	8
87	29	8
88	30	8
89	31	8
90	41	8
91	93	8
92	94	8
93	95	8
94	96	8
95	109	8
96	110	8
97	147	8
98	148	8
99	175	8
100	176	8
101	315	8
102	329	8
103	400	8
104	455	8
105	456	8
106	457	8
107	458	8
108	459	8
109	460	8
110	461	8
111	499	8
112	528	8
113	733	8
114	835	8
115	845	8
116	881	8
117	882	8
118	883	8
119	884	8
120	933	8
121	934	8
122	935	8
123	967	8
124	968	8
125	1084	8
126	1093	8
127	1250	8
128	1555	8
129	1616	8
130	1740	8
131	1741	8
132	1753	8
133	1757	8
134	1758	8
135	1817	8
136	1818	8
137	1819	8
138	1820	8
139	1821	8
140	1822	8
141	1823	8
142	1824	8
143	1883	8
144	2147	8
145	2159	8
146	2160	8
147	2201	8
148	2212	8
149	2213	8
150	2214	8
151	2215	8
152	2216	8
153	2231	8
154	2240	8
155	2241	8
156	2244	8
157	2245	8
158	2248	8
159	2255	8
160	2312	8
161	20	9
162	21	9
163	48	9
164	49	9
165	50	9
166	51	9
167	52	9
168	53	9
169	54	9
170	87	9
171	88	9
172	106	9
173	107	9
174	141	9
175	142	9
176	160	9
177	161	9
178	162	9
179	163	9
180	297	9
181	298	9
182	299	9
183	320	9
184	327	9
185	328	9
186	334	9
187	335	9
188	336	9
189	372	9
190	373	9
191	374	9
192	406	9
193	407	9
194	408	9
195	409	9
196	410	9
197	411	9
198	412	9
199	533	9
200	534	9
201	535	9
202	536	9
203	668	9
204	693	9
205	714	9
206	715	9
207	716	9
208	717	9
209	718	9
210	719	9
211	720	9
212	721	9
213	789	9
214	824	9
215	849	9
216	860	9
217	861	9
218	862	9
219	911	9
220	912	9
221	913	9
222	914	9
223	915	9
224	916	9
225	959	9
226	962	9
227	984	9
228	985	9
229	986	9
230	987	9
231	1097	9
232	1265	9
233	1266	9
234	1267	9
235	1268	9
236	1269	9
237	1270	9
238	1271	9
239	1272	9
240	1273	9
241	1274	9
242	1275	9
243	1276	9
244	1277	9
245	1278	9
246	1279	9
247	1280	9
248	1281	9
249	1282	9
250	1283	9
251	1284	9
252	1285	9
253	1286	9
254	1287	9
255	1288	9
256	1289	9
257	1290	9
258	1291	9
259	1292	9
260	1293	9
261	1294	9
262	1295	9
263	1296	9
264	1297	9
265	1298	9
266	1299	9
267	1300	9
268	1586	9
269	1661	9
270	1711	9
271	1722	9
272	1736	9
273	1755	9
274	1763	9
275	1787	9
276	1788	9
277	1789	9
278	1790	9
279	1873	9
280	1874	9
281	1875	9
282	2174	9
283	2194	9
284	2195	9
285	2196	9
286	2222	9
287	2223	9
288	2224	9
289	2282	9
290	2283	9
291	2284	9
292	2285	9
293	2357	9
294	22	10
295	23	10
296	164	10
297	165	10
298	166	10
299	393	10
300	415	10
301	416	10
302	766	10
303	865	10
304	991	10
305	1089	10
306	1770	10
307	2289	10
308	24	11
309	25	11
310	55	11
311	56	11
312	57	11
313	58	11
314	59	11
315	60	11
316	61	11
317	91	11
318	108	11
319	125	11
320	143	11
321	144	11
322	167	11
323	168	11
324	169	11
325	361	11
326	431	11
327	432	11
328	433	11
329	434	11
330	435	11
331	495	11
332	496	11
333	544	11
334	697	11
335	770	11
336	799	11
337	826	11
338	873	11
339	874	11
340	875	11
341	876	11
342	922	11
343	923	11
344	965	11
345	1033	11
346	1080	11
347	1081	11
348	1082	11
349	1091	11
350	1316	11
351	1317	11
352	1318	11
353	1319	11
354	1320	11
355	1321	11
356	1322	11
357	1323	11
358	1324	11
359	1325	11
360	1326	11
361	1327	11
362	1328	11
363	1329	11
364	1330	11
365	1331	11
366	1332	11
367	1333	11
368	1334	11
369	1335	11
370	1336	11
371	1337	11
372	1338	11
373	1339	11
374	1340	11
375	1341	11
376	1342	11
377	1343	11
378	1344	11
379	1345	11
380	1346	11
381	1347	11
382	1348	11
383	1349	11
384	1350	11
385	1351	11
386	1352	11
387	1353	11
388	1354	11
389	1355	11
390	1356	11
391	1357	11
392	1358	11
393	1359	11
394	1360	11
395	1361	11
396	1362	11
397	1553	11
398	1554	11
399	1608	11
400	1687	11
401	1725	11
402	1737	11
403	1752	11
404	1756	11
405	1805	11
406	1806	11
407	1807	11
408	1808	11
409	1881	11
410	2133	11
411	2157	11
412	2198	11
413	2227	11
414	2237	11
415	2238	11
416	2252	11
417	2253	11
418	2254	11
419	2258	11
420	2298	11
421	2356	11
422	2393	11
423	2394	11
424	2395	11
425	2396	11
426	2397	11
427	26	12
428	27	12
429	572	12
430	819	12
431	924	12
432	1609	12
433	1689	12
434	2299	12
435	32	13
436	33	13
437	182	13
438	358	13
439	688	13
440	838	13
441	848	13
442	954	13
443	971	13
444	1026	13
445	1096	13
446	1545	13
447	1632	13
448	1762	13
449	1858	13
450	1859	13
451	2163	13
452	2243	13
453	34	14
454	99	14
455	308	14
456	330	14
457	340	14
458	341	14
459	342	14
460	343	14
461	349	14
462	467	14
463	468	14
464	469	14
465	470	14
466	471	14
467	472	14
468	473	14
469	474	14
470	475	14
471	476	14
472	477	14
473	805	14
474	806	14
475	807	14
476	808	14
477	936	14
478	977	14
479	1036	14
480	1086	14
481	1087	14
482	1625	14
483	1747	14
484	1751	14
485	1761	14
486	1765	14
487	1838	14
488	1839	14
489	1888	14
490	1889	14
491	2162	14
492	2185	14
493	2202	14
494	2217	14
495	2218	14
496	2242	14
497	2271	14
498	35	15
499	369	15
500	394	15
501	712	15
502	1100	15
503	1710	15
504	1732	15
505	1774	15
506	2272	15
507	36	16
508	42	16
509	159	16
510	368	16
511	402	16
512	508	16
513	667	16
514	713	16
515	1735	16
516	1782	16
517	2171	16
518	2172	16
519	2276	16
520	2277	16
521	2424	16
522	37	17
523	494	17
524	722	17
525	864	17
526	989	17
527	990	17
528	1103	17
529	1764	17
530	1793	17
531	1794	17
532	1876	17
533	2287	17
534	2288	17
535	38	18
536	114	18
537	150	18
538	430	18
539	537	18
540	728	18
541	852	18
542	995	18
543	1603	18
544	1800	18
545	1880	18
546	2295	18
547	2422	18
548	39	19
549	117	19
550	747	19
551	1025	19
552	1113	19
553	1855	19
554	1892	19
555	2187	19
556	2345	19
557	40	20
558	118	20
559	324	20
560	488	20
561	502	20
562	503	20
563	504	20
564	505	20
565	748	20
566	841	20
567	953	20
568	1029	20
569	1637	20
570	1748	20
571	1862	20
572	1896	20
573	2190	20
574	2220	20
575	2360	20
576	2362	20
577	43	21
578	115	21
579	145	21
580	146	21
581	170	21
582	171	21
583	172	21
584	173	21
585	174	21
586	362	21
587	437	21
588	438	21
589	439	21
590	440	21
591	441	21
592	442	21
593	443	21
594	444	21
595	445	21
596	446	21
597	447	21
598	448	21
599	449	21
600	450	21
601	451	21
602	452	21
603	453	21
604	454	21
605	497	21
606	498	21
607	676	21
608	707	21
609	730	21
610	731	21
611	790	21
612	791	21
613	802	21
614	850	21
615	855	21
616	878	21
617	879	21
618	925	21
619	926	21
620	927	21
621	928	21
622	929	21
623	930	21
624	931	21
625	966	21
626	999	21
627	1000	21
628	1001	21
629	1002	21
630	1003	21
631	1004	21
632	1005	21
633	1612	21
634	1613	21
635	1694	21
636	1714	21
637	1738	21
638	1810	21
639	1811	21
640	1812	21
641	2158	21
642	2178	21
643	2199	21
644	2200	21
645	2228	21
646	2229	21
647	2230	21
648	2239	21
649	2302	21
650	2303	21
651	2304	21
652	2305	21
653	2306	21
654	2307	21
655	2308	21
656	44	22
657	45	22
658	70	22
659	71	22
660	72	22
661	73	22
662	74	22
663	75	22
664	76	22
665	77	22
666	78	22
667	79	22
668	80	22
669	119	22
670	120	22
671	134	22
672	135	22
673	136	22
674	137	22
675	138	22
676	139	22
677	183	22
678	184	22
679	185	22
680	186	22
681	187	22
682	188	22
683	489	22
684	506	22
685	524	22
686	708	22
687	749	22
688	750	22
689	751	22
690	752	22
691	753	22
692	754	22
693	811	22
694	894	22
695	895	22
696	896	22
697	897	22
698	898	22
699	899	22
700	900	22
701	901	22
702	902	22
703	903	22
704	904	22
705	905	22
706	906	22
707	943	22
708	944	22
709	945	22
710	946	22
711	947	22
712	948	22
713	949	22
714	950	22
715	951	22
716	952	22
717	1030	22
718	1031	22
719	1032	22
720	1041	22
721	1441	22
722	1442	22
723	1443	22
724	1444	22
725	1445	22
726	1446	22
727	1447	22
728	1448	22
729	1449	22
730	1450	22
731	1451	22
732	1452	22
733	1453	22
734	1454	22
735	1455	22
736	1456	22
737	1457	22
738	1458	22
739	1459	22
740	1460	22
741	1461	22
742	1462	22
743	1463	22
744	1464	22
745	1465	22
746	1466	22
747	1467	22
748	1468	22
749	1469	22
750	1470	22
751	1471	22
752	1472	22
753	1473	22
754	1474	22
755	1475	22
756	1476	22
757	1477	22
758	1478	22
759	1479	22
760	1480	22
761	1481	22
762	1482	22
763	1483	22
764	1484	22
765	1485	22
766	1486	22
767	1487	22
768	1488	22
769	1489	22
770	1490	22
771	1491	22
772	1492	22
773	1493	22
774	1546	22
775	1547	22
776	1548	22
777	1549	22
778	1638	22
779	1718	22
780	1719	22
781	1720	22
782	1721	22
783	1749	22
784	1863	22
785	1864	22
786	2246	22
787	2247	22
788	2256	22
789	2349	22
790	2350	22
791	2351	22
792	2352	22
793	2353	22
794	2355	22
795	46	23
796	47	23
797	156	23
798	157	23
799	158	23
800	591	23
801	794	23
802	804	23
803	858	23
804	859	23
805	956	23
806	1202	23
807	1203	23
808	1206	23
809	1207	23
810	1209	23
811	1210	23
812	1211	23
813	1212	23
814	1213	23
815	1214	23
816	1216	23
817	1217	23
818	1218	23
819	1219	23
820	1220	23
821	1221	23
822	1222	23
823	1223	23
824	1224	23
825	1225	23
826	1226	23
827	1227	23
828	1228	23
829	1229	23
830	1230	23
831	1231	23
832	1232	23
833	1233	23
834	1503	23
835	1566	23
836	1567	23
837	1733	23
838	2235	23
839	2379	23
840	2380	23
841	62	24
842	306	24
843	827	24
844	975	24
845	976	24
846	1092	24
847	1615	24
848	1772	24
849	2269	24
850	2270	24
851	63	25
852	64	25
853	97	25
854	98	25
855	149	25
856	177	25
857	178	25
858	179	25
859	307	25
860	355	25
861	363	25
862	364	25
863	377	25
864	698	25
865	699	25
866	700	25
867	792	25
868	836	25
869	885	25
870	886	25
871	969	25
872	970	25
873	1008	25
874	1034	25
875	1094	25
876	1528	25
877	1529	25
878	1530	25
879	1531	25
880	1556	25
881	1726	25
882	1727	25
883	1728	25
884	1729	25
885	1742	25
886	1743	25
887	1754	25
888	1759	25
889	1825	25
890	1826	25
891	1827	25
892	1828	25
893	1884	25
894	2161	25
895	2313	25
896	2314	25
897	65	26
898	66	26
899	67	26
900	68	26
901	69	26
902	126	26
903	331	26
904	348	26
905	365	26
906	375	26
907	382	26
908	383	26
909	462	26
910	529	26
911	566	26
912	701	26
913	793	26
914	1009	26
915	1035	26
916	1095	26
917	1617	26
918	1744	26
919	1760	26
920	1829	26
921	2233	26
922	2315	26
923	2402	26
924	2403	26
925	2404	26
926	82	27
927	128	27
928	140	27
929	395	27
930	396	27
931	397	27
932	398	27
933	399	27
934	492	27
935	493	27
936	507	27
937	527	27
938	531	27
939	540	27
940	711	27
941	796	27
942	843	27
943	980	27
944	981	27
945	1709	27
946	1731	27
947	1773	27
948	1778	27
949	2221	27
950	2249	27
951	2359	27
952	2361	27
953	2421	27
954	83	28
955	350	28
956	682	28
957	1629	28
958	1848	28
959	2207	28
960	84	29
961	103	29
962	192	29
963	202	29
964	233	29
965	241	29
966	245	29
967	262	29
968	295	29
969	319	29
970	568	29
971	569	29
972	590	29
973	593	29
974	599	29
975	605	29
976	609	29
977	613	29
978	614	29
979	616	29
980	626	29
981	630	29
982	640	29
983	647	29
984	650	29
985	652	29
986	654	29
987	661	29
988	691	29
989	757	29
990	814	29
991	815	29
992	1040	29
993	1060	29
994	1061	29
995	1062	29
996	1195	29
997	1196	29
998	1576	29
999	1635	29
1000	1642	29
1001	1644	29
1002	1646	29
1003	1648	29
1004	1651	29
1005	1653	29
1006	1654	29
1007	1698	29
1008	1780	29
1009	1865	29
1010	1871	29
1011	1897	29
1012	1904	29
1013	1907	29
1014	1909	29
1015	1914	29
1016	1915	29
1017	1917	29
1018	1920	29
1019	1922	29
1020	1927	29
1021	1928	29
1022	1929	29
1023	1932	29
1024	1938	29
1025	1939	29
1026	1941	29
1027	1943	29
1028	1944	29
1029	1945	29
1030	1947	29
1031	1948	29
1032	1952	29
1033	1954	29
1034	1957	29
1035	1958	29
1036	1959	29
1037	1960	29
1038	1962	29
1039	1975	29
1040	1977	29
1041	1978	29
1042	1981	29
1043	1987	29
1044	1988	29
1045	1990	29
1046	1991	29
1047	1992	29
1048	1995	29
1049	1996	29
1050	1997	29
1051	2000	29
1052	2002	29
1053	2004	29
1054	2005	29
1055	2006	29
1056	2008	29
1057	2010	29
1058	2011	29
1059	2014	29
1060	2015	29
1061	2016	29
1062	2018	29
1063	2019	29
1064	2020	29
1065	2023	29
1066	2024	29
1067	2027	29
1068	2028	29
1069	2031	29
1070	2032	29
1071	2033	29
1072	2039	29
1073	2042	29
1074	2046	29
1075	2047	29
1076	2048	29
1077	2049	29
1078	2052	29
1079	2054	29
1080	2055	29
1081	2056	29
1082	2059	29
1083	2060	29
1084	2121	29
1085	2122	29
1086	2146	29
1087	2148	29
1088	2149	29
1089	2150	29
1090	2151	29
1091	2152	29
1092	2364	29
1093	85	30
1094	326	30
1095	683	30
1096	1114	30
1097	1421	30
1098	1422	30
1099	1423	30
1100	1424	30
1101	1425	30
1102	1426	30
1103	1427	30
1104	1428	30
1105	1429	30
1106	1505	30
1107	86	31
1108	637	31
1109	909	31
1110	1099	31
1111	1234	31
1112	1235	31
1113	1236	31
1114	1237	31
1115	1238	31
1116	1239	31
1117	1240	31
1118	1241	31
1119	1242	31
1120	1243	31
1121	1244	31
1122	1245	31
1123	1775	31
1124	89	32
1125	627	32
1126	694	32
1127	1724	32
1128	1792	32
1129	90	33
1130	113	33
1131	121	33
1132	122	33
1133	321	33
1134	337	33
1135	338	33
1136	346	33
1137	347	33
1138	352	33
1139	353	33
1140	417	33
1141	418	33
1142	419	33
1143	420	33
1144	421	33
1145	422	33
1146	423	33
1147	424	33
1148	425	33
1149	426	33
1150	427	33
1151	428	33
1152	429	33
1153	509	33
1154	510	33
1155	669	33
1156	670	33
1157	671	33
1158	672	33
1159	692	33
1160	695	33
1161	723	33
1162	724	33
1163	725	33
1164	726	33
1165	727	33
1166	798	33
1167	825	33
1168	866	33
1169	867	33
1170	868	33
1171	869	33
1172	870	33
1173	871	33
1174	919	33
1175	960	33
1176	964	33
1177	992	33
1178	993	33
1179	994	33
1180	1090	33
1181	1104	33
1182	1306	33
1183	1307	33
1184	1308	33
1185	1309	33
1186	1310	33
1187	1311	33
1188	1312	33
1189	1313	33
1190	1314	33
1191	1315	33
1192	1511	33
1193	1512	33
1194	1513	33
1195	1514	33
1196	1515	33
1197	1516	33
1198	1517	33
1199	1518	33
1200	1519	33
1201	1520	33
1202	1521	33
1203	1522	33
1204	1523	33
1205	1550	33
1206	1551	33
1207	1552	33
1208	1590	33
1209	1591	33
1210	1592	33
1211	1593	33
1212	1594	33
1213	1595	33
1214	1596	33
1215	1597	33
1216	1598	33
1217	1599	33
1218	1600	33
1219	1673	33
1220	1674	33
1221	1675	33
1222	1676	33
1223	1677	33
1224	1678	33
1225	1679	33
1226	1680	33
1227	1681	33
1228	1682	33
1229	1683	33
1230	1795	33
1231	1796	33
1232	1797	33
1233	1798	33
1234	1877	33
1235	1878	33
1236	2093	33
1237	2094	33
1238	2095	33
1239	2096	33
1240	2097	33
1241	2098	33
1242	2099	33
1243	2100	33
1244	2101	33
1245	2102	33
1246	2103	33
1247	2104	33
1248	2105	33
1249	2106	33
1250	2107	33
1251	2108	33
1252	2109	33
1253	2110	33
1254	2111	33
1255	2112	33
1256	2113	33
1257	2114	33
1258	2115	33
1259	2116	33
1260	2117	33
1261	2118	33
1262	2119	33
1263	2156	33
1264	2175	33
1265	2176	33
1266	2197	33
1267	2210	33
1268	2211	33
1269	2225	33
1270	2250	33
1271	2251	33
1272	2290	33
1273	2291	33
1274	2292	33
1275	2293	33
1276	2354	33
1277	2389	33
1278	2390	33
1279	2391	33
1280	92	34
1281	602	34
1282	1363	34
1283	1364	34
1284	1365	34
1285	1366	34
1286	1367	34
1287	1368	34
1288	1369	34
1289	1370	34
1290	1371	34
1291	1372	34
1292	1373	34
1293	1374	34
1294	1693	34
1295	100	35
1296	304	35
1297	366	35
1298	1430	35
1299	1431	35
1300	1432	35
1301	1433	35
1302	1434	35
1303	1435	35
1304	1436	35
1305	1437	35
1306	1438	35
1307	1439	35
1308	1440	35
1309	1611	35
1310	1701	35
1311	1702	35
1312	1703	35
1313	1704	35
1314	1705	35
1315	1706	35
1316	1707	35
1317	1708	35
1318	1857	35
1319	1898	35
1320	1899	35
1321	1900	35
1322	1901	35
1323	2347	35
1324	101	36
1325	102	36
1326	124	36
1327	332	36
1328	333	36
1329	371	36
1330	384	36
1331	385	36
1332	386	36
1333	387	36
1334	388	36
1335	389	36
1336	390	36
1337	391	36
1338	392	36
1339	490	36
1340	491	36
1341	769	36
1342	857	36
1343	910	36
1344	1050	36
1345	1051	36
1346	1052	36
1347	1053	36
1348	1054	36
1349	1055	36
1350	1133	36
1351	1134	36
1352	1135	36
1353	1136	36
1354	1137	36
1355	1138	36
1356	1139	36
1357	1140	36
1358	1141	36
1359	1142	36
1360	1143	36
1361	1144	36
1362	1145	36
1363	1146	36
1364	1147	36
1365	1148	36
1366	1149	36
1367	1150	36
1368	1151	36
1369	1152	36
1370	1153	36
1371	1154	36
1372	1155	36
1373	1156	36
1374	1157	36
1375	1158	36
1376	1159	36
1377	1160	36
1378	1161	36
1379	1162	36
1380	1163	36
1381	1164	36
1382	1165	36
1383	1166	36
1384	1167	36
1385	1168	36
1386	1169	36
1387	1170	36
1388	1171	36
1389	1172	36
1390	1173	36
1391	1174	36
1392	1175	36
1393	1176	36
1394	1177	36
1395	1178	36
1396	1179	36
1397	1180	36
1398	1181	36
1399	1182	36
1400	1183	36
1401	1184	36
1402	1185	36
1403	1186	36
1404	1187	36
1405	1188	36
1406	1571	36
1407	1768	36
1408	1867	36
1409	2192	36
1410	2377	36
1411	2378	36
1412	2381	36
1413	104	37
1414	154	37
1415	155	37
1416	231	37
1417	360	37
1418	370	37
1419	801	37
1420	823	37
1421	907	37
1422	908	37
1423	957	37
1424	958	37
1425	1071	37
1426	1072	37
1427	1073	37
1428	1074	37
1429	1075	37
1430	1246	37
1431	1247	37
1432	1248	37
1433	1249	37
1434	1504	37
1435	1652	37
1436	1734	37
1437	1779	37
1438	2155	37
1439	2193	37
1440	2234	37
1441	2273	37
1442	2373	37
1443	2374	37
1444	2375	37
1445	2376	37
1446	105	38
1447	621	38
1448	1258	38
1449	1259	38
1450	1260	38
1451	1261	38
1452	1262	38
1453	1993	38
1454	1994	38
1455	111	39
1456	112	39
1457	339	39
1458	464	39
1459	465	39
1460	548	39
1461	1012	39
1462	1085	39
1463	1387	39
1464	1388	39
1465	1389	39
1466	1390	39
1467	1391	39
1468	1392	39
1469	1393	39
1470	1394	39
1471	1395	39
1472	1396	39
1473	1397	39
1474	1398	39
1475	1399	39
1476	1400	39
1477	1401	39
1478	1402	39
1479	1403	39
1480	1404	39
1481	1405	39
1482	1406	39
1483	1407	39
1484	1408	39
1485	1409	39
1486	1410	39
1487	1411	39
1488	1412	39
1489	1413	39
1490	1414	39
1491	1415	39
1492	1416	39
1493	1417	39
1494	1418	39
1495	1419	39
1496	1532	39
1497	1533	39
1498	1534	39
1499	1535	39
1500	1536	39
1501	1537	39
1502	1538	39
1503	1539	39
1504	1540	39
1505	1541	39
1506	1542	39
1507	1543	39
1508	1544	39
1509	1622	39
1510	2320	39
1511	127	40
1512	738	40
1513	739	40
1514	844	40
1515	1014	40
1516	1109	40
1517	1835	40
1518	1887	40
1519	2184	40
1520	2260	40
1521	2261	40
1522	2323	40
1523	2324	40
1524	2325	40
1525	129	41
1526	356	41
1527	702	41
1528	703	41
1529	742	41
1530	937	41
1531	1019	41
1532	1627	41
1533	1840	41
1534	1841	41
1535	1842	41
1536	1843	41
1537	1844	41
1538	1845	41
1539	1846	41
1540	1890	41
1541	2232	41
1542	2328	41
1543	2329	41
1544	2330	41
1545	2331	41
1546	2332	41
1547	130	42
1548	131	42
1549	132	42
1550	133	42
1551	322	42
1552	677	42
1553	732	42
1554	880	42
1555	1006	42
1556	1614	42
1557	1739	42
1558	1813	42
1559	1814	42
1560	2179	42
1561	2259	42
1562	2309	42
1563	2310	42
1564	151	43
1565	325	43
1566	359	43
1567	482	43
1568	483	43
1569	484	43
1570	485	43
1571	486	43
1572	487	43
1573	516	43
1574	517	43
1575	518	43
1576	519	43
1577	520	43
1578	521	43
1579	522	43
1580	523	43
1581	972	43
1582	1028	43
1583	1636	43
1584	1723	43
1585	1861	43
1586	2205	43
1587	2206	43
1588	2219	43
1589	2262	43
1590	2263	43
1591	2358	43
1592	152	44
1593	812	44
1594	813	44
1595	1633	44
1596	1893	44
1597	1894	44
1598	2346	44
1599	153	45
1600	549	45
1601	982	45
1602	1784	45
1603	2191	45
1604	180	46
1605	181	46
1606	357	46
1607	530	46
1608	704	46
1609	705	46
1610	706	46
1611	768	46
1612	822	46
1613	938	46
1614	939	46
1615	940	46
1616	941	46
1617	942	46
1618	961	46
1619	1022	46
1620	1023	46
1621	1630	46
1622	1850	46
1623	1851	46
1624	1852	46
1625	1891	46
1626	2203	46
1627	2337	46
1628	2338	46
1629	2339	46
1630	2340	46
1631	2341	46
1632	2342	46
1633	2405	46
1634	2406	46
1635	2407	46
1636	2408	46
1637	2409	46
1638	2410	46
1639	2411	46
1640	189	47
1641	190	48
1642	191	49
1643	193	50
1644	194	51
1645	195	52
1646	1193	52
1647	1194	52
1648	196	53
1649	1058	53
1650	197	54
1651	198	55
1652	199	56
1653	200	57
1654	201	58
1655	1057	58
1656	1189	58
1657	1190	58
1658	203	59
1659	204	60
1660	205	61
1661	206	62
1662	207	63
1663	208	64
1664	209	65
1665	755	65
1666	210	66
1667	1042	66
1668	211	67
1669	212	68
1670	213	69
1671	214	70
1672	1044	70
1673	1123	70
1674	1124	70
1675	1495	70
1676	215	71
1677	1045	71
1678	1125	71
1679	1420	71
1680	1496	71
1681	216	72
1682	217	73
1683	218	74
1684	219	75
1685	220	76
1686	1046	76
1687	1127	76
1688	1128	76
1689	1497	76
1690	221	77
1691	222	78
1692	1047	78
1693	223	79
1694	224	80
1695	225	80
1696	226	81
1697	227	82
1698	228	83
1699	229	84
1700	230	85
1701	1049	85
1702	1204	85
1703	1205	85
1704	1501	85
1705	232	86
1706	234	87
1707	235	88
1708	236	89
1709	237	90
1710	238	91
1711	239	92
1712	240	93
1713	1059	93
1714	1191	93
1715	1192	93
1716	1500	93
1717	242	94
1718	243	95
1719	244	96
1720	246	97
1721	247	98
1722	248	99
1723	629	99
1724	2385	99
1725	249	100
1726	250	101
1727	1064	101
1728	1208	101
1729	1215	101
1730	251	102
1731	252	103
1732	253	104
1733	254	105
1734	255	106
1735	256	107
1736	257	108
1737	258	109
1738	259	110
1739	260	111
1740	261	112
1741	1088	112
1742	263	113
1743	1065	113
1744	1131	113
1745	1132	113
1746	1502	113
1747	264	114
1748	265	115
1749	266	116
1750	267	117
1751	268	118
1752	1043	118
1753	1121	118
1754	1122	118
1755	1494	118
1756	269	119
1757	270	120
1758	271	121
1759	272	122
1760	273	123
1761	1066	123
1762	274	124
1763	275	125
1764	276	126
1765	277	126
1766	1067	126
1767	278	127
1768	279	128
1769	2041	128
1770	280	129
1771	281	130
1772	282	131
1773	2043	131
1774	283	132
1775	284	133
1776	285	134
1777	286	135
1778	1076	135
1779	1251	135
1780	1252	135
1781	1506	135
1782	287	136
1783	288	136
1784	289	137
1785	290	138
1786	291	139
1787	292	140
1788	1068	140
1789	293	141
1790	294	142
1791	296	143
1792	345	143
1793	405	143
1794	983	143
1795	1102	143
1796	1785	143
1797	1786	143
1798	1872	143
1799	2209	143
1800	2280	143
1801	2281	143
1802	300	144
1803	413	144
1804	414	144
1805	481	144
1806	686	144
1807	840	144
1808	863	144
1809	917	144
1810	963	144
1811	988	144
1812	1668	144
1813	1791	144
1814	2204	144
1815	2286	144
1816	2417	144
1817	2418	144
1818	2419	144
1819	301	145
1820	302	146
1821	303	147
1822	674	147
1823	1105	147
1824	1524	147
1825	1525	147
1826	1526	147
1827	1527	147
1828	305	148
1829	309	149
1830	310	150
1831	311	151
1832	312	152
1833	313	153
1834	314	154
1835	756	154
1836	316	155
1837	376	155
1838	1559	155
1839	1560	155
1840	317	156
1841	318	156
1842	1568	156
1843	323	157
1844	463	157
1845	500	157
1846	512	157
1847	734	157
1848	955	157
1849	1108	157
1850	1639	157
1851	1699	157
1852	1831	157
1853	1885	157
1854	2181	157
1855	2316	157
1856	2317	157
1857	2318	157
1858	344	158
1859	511	158
1860	525	158
1861	678	158
1862	772	158
1863	773	158
1864	774	158
1865	775	158
1866	776	158
1867	777	158
1868	778	158
1869	779	158
1870	780	158
1871	781	158
1872	828	158
1873	829	158
1874	830	158
1875	831	158
1876	832	158
1877	833	158
1878	834	158
1879	932	158
1880	1007	158
1881	1107	158
1882	1715	158
1883	1815	158
1884	1816	158
1885	1882	158
1886	2166	158
1887	2167	158
1888	2168	158
1889	2311	158
1890	351	159
1891	607	159
1892	918	159
1893	1510	159
1894	1589	159
1895	354	160
1896	378	160
1897	379	160
1898	380	160
1899	381	160
1900	543	160
1901	696	160
1902	996	160
1903	1606	160
1904	1802	160
1905	1803	160
1906	2264	160
1907	367	161
1908	1934	161
1909	401	162
1910	538	162
1911	744	162
1912	1112	162
1913	2170	162
1914	2275	162
1915	2335	162
1916	403	163
1917	611	163
1918	821	163
1919	1584	163
1920	404	164
1921	656	164
1922	1658	164
1923	2279	164
1924	436	165
1925	675	165
1926	877	165
1927	998	165
1928	1039	165
1929	1106	165
1930	1809	165
1931	2300	165
1932	2301	165
1933	478	166
1934	743	166
1935	1020	166
1936	1111	166
1937	1847	166
1938	2333	166
1939	2334	166
1940	479	167
1941	480	167
1942	839	167
1943	1697	167
1944	1856	167
1945	2412	167
1946	2413	167
1947	2414	167
1948	2415	167
1949	501	168
1950	690	168
1951	893	168
1952	1027	168
1953	1115	168
1954	1860	168
1955	2348	168
1956	513	169
1957	514	169
1958	679	169
1959	735	169
1960	887	169
1961	888	169
1962	889	169
1963	1010	169
1964	1011	169
1965	1620	169
1966	1750	169
1967	1832	169
1968	1886	169
1969	2319	169
1970	539	170
1971	842	170
1972	2420	170
1973	541	171
1974	788	171
1975	809	171
1976	810	171
1977	1569	171
1978	1903	171
1979	542	172
1980	545	173
1981	546	174
1982	1641	174
1983	547	175
1984	550	176
1985	551	177
1986	2386	177
1987	552	178
1988	1767	178
1989	2266	178
1990	553	179
1991	554	180
1992	555	181
1993	2363	181
1994	556	182
1995	557	183
1996	558	184
1997	559	185
1998	1098	185
1999	560	186
2000	561	187
2001	1663	187
2002	2080	187
2003	2081	187
2004	562	188
2005	2382	188
2006	563	189
2007	1645	189
2008	1968	189
2009	1969	189
2010	564	190
2011	1669	190
2012	2086	190
2013	2087	190
2014	2088	190
2015	565	191
2016	567	192
2017	1601	192
2018	2126	192
2019	2127	192
2020	570	193
2021	2383	193
2022	571	194
2023	1619	194
2024	2180	194
2025	573	195
2026	1688	195
2027	2134	195
2028	2135	195
2029	574	196
2030	1643	196
2031	575	197
2032	1671	197
2033	2092	197
2034	576	198
2035	577	199
2036	2416	199
2037	585	200
2038	586	201
2039	1670	201
2040	2089	201
2041	2090	201
2042	2091	201
2043	587	202
2044	588	203
2045	1667	203
2046	589	204
2047	592	205
2048	594	206
2049	595	207
2050	1499	207
2051	1690	207
2052	1980	207
2053	2136	207
2054	596	208
2055	597	209
2056	2400	209
2057	598	210
2058	600	211
2059	601	212
2060	1605	212
2061	2177	212
2062	603	213
2063	1621	213
2064	604	214
2065	1686	214
2066	2132	214
2067	606	215
2068	1602	215
2069	2128	215
2070	2129	215
2071	608	216
2072	610	217
2073	1666	217
2074	612	218
2075	856	218
2076	974	218
2077	1101	218
2078	1771	218
2079	2208	218
2080	2268	218
2081	615	219
2082	617	220
2083	1695	220
2084	1696	220
2085	618	221
2086	619	222
2087	620	223
2088	622	224
2089	2068	224
2090	623	225
2091	624	226
2092	625	227
2093	1870	227
2094	628	228
2095	1692	228
2096	2137	228
2097	2138	228
2098	2139	228
2099	2140	228
2100	2141	228
2101	2142	228
2102	2143	228
2103	2401	228
2104	631	229
2105	632	230
2106	633	231
2107	1972	231
2108	1973	231
2109	634	232
2110	635	233
2111	636	234
2112	638	235
2113	639	236
2114	641	237
2115	642	238
2116	2372	238
2117	643	239
2118	644	240
2119	1656	240
2120	2064	240
2121	2065	240
2122	645	241
2123	646	242
2124	2082	242
2125	2083	242
2126	648	243
2127	1649	243
2128	649	244
2129	1650	244
2130	651	245
2131	2387	245
2132	653	246
2133	655	247
2134	921	247
2135	1604	247
2136	1712	247
2137	1801	247
2138	657	248
2139	658	249
2140	1588	249
2141	2085	249
2142	659	250
2143	1069	250
2144	660	251
2145	662	252
2146	1660	252
2147	663	253
2148	664	254
2149	665	255
2150	2074	255
2151	666	256
2152	1570	256
2153	1925	256
2154	673	257
2155	1116	257
2156	1117	257
2157	1118	257
2158	1119	257
2159	1120	257
2160	1610	257
2161	1766	257
2162	680	258
2163	1626	258
2164	681	259
2165	1628	259
2166	684	260
2167	1664	260
2168	2084	260
2169	685	261
2170	1657	261
2171	687	262
2172	689	263
2173	710	264
2174	978	264
2175	1574	264
2176	1777	264
2177	1869	264
2178	729	265
2179	853	265
2180	872	265
2181	997	265
2182	1607	265
2183	1713	265
2184	1804	265
2185	2257	265
2186	2296	265
2187	2297	265
2188	740	266
2189	800	266
2190	847	266
2191	1015	266
2192	1016	266
2193	1623	266
2194	1717	266
2195	1836	266
2196	2326	266
2197	741	267
2198	851	267
2199	1017	267
2200	1018	267
2201	1110	267
2202	1624	267
2203	1746	267
2204	1837	267
2205	2327	267
2206	745	268
2207	891	268
2208	892	268
2209	1021	268
2210	1849	268
2211	2336	268
2212	758	269
2213	759	269
2214	760	269
2215	761	269
2216	762	269
2217	763	269
2218	764	269
2219	765	269
2220	816	269
2221	817	269
2222	818	269
2223	2164	269
2224	767	270
2225	1573	270
2226	1868	270
2227	2189	270
2228	782	271
2229	783	271
2230	784	271
2231	785	271
2232	786	271
2233	787	271
2234	2169	271
2235	795	272
2236	1986	272
2237	803	273
2238	837	274
2239	1830	274
2240	2426	274
2241	920	275
2242	1685	275
2243	1799	275
2244	1879	275
2245	2130	275
2246	2131	275
2247	2226	275
2248	2294	275
2249	973	276
2250	2265	276
2251	979	277
2252	1781	277
2253	2274	277
2254	1048	278
2255	1129	278
2256	1130	278
2257	1498	278
2258	1562	278
2259	1056	279
2260	1063	280
2261	1908	280
2262	1070	281
2263	1077	282
2264	1253	282
2265	1254	282
2266	1953	282
2267	1078	283
2268	1126	283
2269	1255	283
2270	1507	283
2271	1079	284
2272	1256	284
2273	1257	284
2274	1508	284
2275	1083	285
2276	1197	286
2277	1198	286
2278	1199	286
2279	1200	286
2280	1201	286
2281	1647	286
2282	1989	286
2283	1263	287
2284	1264	287
2285	1509	287
2286	1585	287
2287	2072	287
2288	2073	287
2289	1301	288
2290	1302	288
2291	1303	288
2292	1304	288
2293	1305	288
2294	1665	288
2295	1375	289
2296	1376	289
2297	1377	289
2298	1378	289
2299	1379	289
2300	1380	289
2301	1381	289
2302	1382	289
2303	1383	289
2304	1384	289
2305	1385	289
2306	1386	289
2307	1730	289
2308	1557	290
2309	1558	291
2310	1561	292
2311	1563	293
2312	1564	294
2313	1565	295
2314	1587	296
2315	2076	296
2316	2077	296
2317	1618	297
2318	1866	297
2319	1634	298
2320	1895	298
2321	2188	298
2322	1655	299
2323	1659	300
2324	2070	300
2325	2071	300
2326	2384	300
2327	1662	301
2328	2078	301
2329	2079	301
2330	1672	302
2331	1684	303
2332	2066	303
2333	2067	303
2334	1691	304
2335	2398	304
2336	2399	304
2337	1776	305
2338	1902	306
2339	1905	307
2340	1906	308
2341	1910	309
2342	1911	310
2343	1912	311
2344	1913	312
2345	1916	313
2346	1918	314
2347	1919	315
2348	1921	316
2349	1923	317
2350	1924	318
2351	1926	319
2352	1930	320
2353	1931	321
2354	1933	322
2355	1935	323
2356	1936	324
2357	1937	325
2358	1940	326
2359	1942	327
2360	1946	328
2361	1949	329
2362	1950	330
2363	1951	331
2364	1955	332
2365	1956	333
2366	1961	334
2367	1963	335
2368	1964	336
2369	1965	337
2370	1966	338
2371	1967	339
2372	1970	340
2373	1971	341
2374	1976	342
2375	1979	343
2376	1982	344
2377	1983	345
2378	1984	346
2379	1985	347
2380	1998	348
2381	1999	349
2382	2001	350
2383	2003	351
2384	2007	352
2385	2009	353
2386	2012	354
2387	2013	355
2388	2017	356
2389	2021	357
2390	2022	358
2391	2025	359
2392	2026	360
2393	2029	361
2394	2030	362
2395	2034	363
2396	2035	364
2397	2036	365
2398	2037	366
2399	2038	367
2400	2040	368
2401	2044	369
2402	2045	370
2403	2050	371
2404	2051	372
2405	2053	373
2406	2057	374
2407	2058	375
2408	2061	376
2409	2062	377
2410	2063	378
2411	2069	379
2412	2075	380
2413	2120	381
2414	2123	382
2415	2124	382
2416	2125	382
2417	2392	382
2418	2144	383
2419	2145	384
2420	2153	385
2421	2154	386
2422	2388	387
\.


--
-- TOC entry 3851 (class 0 OID 466766)
-- Dependencies: 261
-- Data for Name: asset_issuances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_issuances (id, receiving_staff_id, notes, event_register_id, event_station_id, event_admin_id, stamp, issuance_type_id) FROM stdin;
3	891		222	1	3	2026-07-25 07:53:12.298429	1
4	23071		223	1	3	2026-07-25 07:53:12.298429	1
5	868		224	1	3	2026-07-25 07:53:12.298429	1
6	593		225	1	3	2026-07-25 07:53:12.298429	1
7	970		226	1	3	2026-07-25 07:53:12.298429	1
8	899		227	1	3	2026-07-25 07:53:12.298429	1
9	22144		228	1	3	2026-07-25 07:53:12.298429	1
10	22051		229	1	3	2026-07-25 07:53:12.298429	1
11	983		230	1	3	2026-07-25 07:53:12.298429	1
12	969		231	1	3	2026-07-25 07:53:12.298429	1
13	528		232	1	3	2026-07-25 07:53:12.298429	1
14	696		233	1	3	2026-07-25 07:53:12.298429	1
15	2114310		234	1	3	2026-07-25 07:53:12.298429	1
16	25002		235	1	3	2026-07-25 07:53:12.298429	1
17	22094		236	1	3	2026-07-25 07:53:12.298429	1
18	21020		237	1	3	2026-07-25 07:53:12.298429	1
19	560		238	1	3	2026-07-25 07:53:12.298429	1
20	76		239	1	3	2026-07-25 07:53:12.298429	1
21	920		240	1	3	2026-07-25 07:53:12.298429	1
22	59		241	1	3	2026-07-25 07:53:12.298429	1
23	22041		242	1	3	2026-07-25 07:53:12.298429	1
24	911		243	1	3	2026-07-25 07:53:12.298429	1
25	898		244	1	3	2026-07-25 07:53:12.298429	1
26	896		245	1	3	2026-07-25 07:53:12.298429	1
27	607		246	1	3	2026-07-25 07:53:12.298429	1
28	636		247	1	3	2026-07-25 07:53:12.298429	1
29	2		248	1	3	2026-07-25 07:53:12.298429	1
30	21039		249	1	3	2026-07-25 07:53:12.298429	1
31	921		250	1	3	2026-07-25 07:53:12.298429	1
32	22096		251	1	3	2026-07-25 07:53:12.298429	1
33	45		252	1	3	2026-07-25 07:53:12.298429	1
34	939		253	1	3	2026-07-25 07:53:12.298429	1
35	923		254	1	3	2026-07-25 07:53:12.298429	1
36	144		255	1	3	2026-07-25 07:53:12.298429	1
37	136		256	1	3	2026-07-25 07:53:12.298429	1
38	23084		257	1	3	2026-07-25 07:53:12.298429	1
39	870		258	1	3	2026-07-25 07:53:12.298429	1
40	855		259	1	3	2026-07-25 07:53:12.298429	1
41	683		260	1	3	2026-07-25 07:53:12.298429	1
42	914		261	1	3	2026-07-25 07:53:12.298429	1
43	98		262	1	3	2026-07-25 07:53:12.298429	1
44	264		263	1	3	2026-07-25 07:53:12.298429	1
45	22157		264	1	3	2026-07-25 07:53:12.298429	1
46	596		265	1	3	2026-07-25 07:53:12.298429	1
47	333793		266	1	3	2026-07-25 07:53:12.298429	1
48	333102		267	1	3	2026-07-25 07:53:12.298429	1
49	333872		268	1	3	2026-07-25 07:53:12.298429	1
50	333392		269	1	3	2026-07-25 07:53:12.298429	1
51	333902		270	1	3	2026-07-25 07:53:12.298429	1
52	333802		271	1	3	2026-07-25 07:53:12.298429	1
53	333389		272	1	3	2026-07-25 07:53:12.298429	1
54	333373		273	1	3	2026-07-25 07:53:12.298429	1
55	333860		274	1	3	2026-07-25 07:53:12.298429	1
56	333083		275	1	3	2026-07-25 07:53:12.298429	1
57	334013		276	1	3	2026-07-25 07:53:12.298429	1
58	333339		277	1	3	2026-07-25 07:53:12.298429	1
59	333617		278	1	3	2026-07-25 07:53:12.298429	1
60	333832		279	1	3	2026-07-25 07:53:12.298429	1
61	333020		280	1	3	2026-07-25 07:53:12.298429	1
62	333917		281	1	3	2026-07-25 07:53:12.298429	1
63	333612		282	1	3	2026-07-25 07:53:12.298429	1
64	333086		283	1	3	2026-07-25 07:53:12.298429	1
65	13		284	1	3	2026-07-25 07:53:12.298429	1
66	333620		285	1	3	2026-07-25 07:53:12.298429	1
67	333659		286	1	3	2026-07-25 07:53:12.298429	1
68	333382		287	1	3	2026-07-25 07:53:12.298429	1
69	333660		288	1	3	2026-07-25 07:53:12.298429	1
70	333315		289	1	3	2026-07-25 07:53:12.298429	1
71	333268		290	1	3	2026-07-25 07:53:12.298429	1
72	333429		291	1	3	2026-07-25 07:53:12.298429	1
73	333453		292	1	3	2026-07-25 07:53:12.298429	1
74	333539		293	1	3	2026-07-25 07:53:12.298429	1
75	333425		294	1	3	2026-07-25 07:53:12.298429	1
76	333989		295	1	3	2026-07-25 07:53:12.298429	1
77	333994		296	1	3	2026-07-25 07:53:12.298429	1
78	333305		297	1	3	2026-07-25 07:53:12.298429	1
79	333941		298	1	3	2026-07-25 07:53:12.298429	1
80	333302		299	1	3	2026-07-25 07:53:12.298429	1
81	333272		300	1	3	2026-07-25 07:53:12.298429	1
82	333721		301	1	3	2026-07-25 07:53:12.298429	1
83	333394		302	1	3	2026-07-25 07:53:12.298429	1
84	333012		303	1	3	2026-07-25 07:53:12.298429	1
85	333284		304	1	3	2026-07-25 07:53:12.298429	1
86	333304		305	1	3	2026-07-25 07:53:12.298429	1
87	333702		306	1	3	2026-07-25 07:53:12.298429	1
88	333827		307	1	3	2026-07-25 07:53:12.298429	1
89	333889		308	1	3	2026-07-25 07:53:12.298429	1
90	333004		309	1	3	2026-07-25 07:53:12.298429	1
91	333786		310	1	3	2026-07-25 07:53:12.298429	1
92	333985		311	1	3	2026-07-25 07:53:12.298429	1
93	333957		312	1	3	2026-07-25 07:53:12.298429	1
94	333188		313	1	3	2026-07-25 07:53:12.298429	1
95	333627		314	1	3	2026-07-25 07:53:12.298429	1
96	333487		315	1	3	2026-07-25 07:53:12.298429	1
97	333253		316	1	3	2026-07-25 07:53:12.298429	1
98	333450		317	1	3	2026-07-25 07:53:12.298429	1
99	23025		318	1	3	2026-07-25 07:53:12.298429	1
100	333943		319	1	3	2026-07-25 07:53:12.298429	1
101	333316		320	1	3	2026-07-25 07:53:12.298429	1
102	333724		321	1	3	2026-07-25 07:53:12.298429	1
103	333175		322	1	3	2026-07-25 07:53:12.298429	1
104	333892		323	1	3	2026-07-25 07:53:12.298429	1
105	333411		324	1	3	2026-07-25 07:53:12.298429	1
106	333168		325	1	3	2026-07-25 07:53:12.298429	1
107	334006		326	1	3	2026-07-25 07:53:12.298429	1
108	333968		327	1	3	2026-07-25 07:53:12.298429	1
109	333192		328	1	3	2026-07-25 07:53:12.298429	1
110	333948		329	1	3	2026-07-25 07:53:12.298429	1
111	333682		330	1	3	2026-07-25 07:53:12.298429	1
112	333003		331	1	3	2026-07-25 07:53:12.298429	1
113	333292		332	1	3	2026-07-25 07:53:12.298429	1
114	333247		333	1	3	2026-07-25 07:53:12.298429	1
115	333438		334	1	3	2026-07-25 07:53:12.298429	1
116	333366		335	1	3	2026-07-25 07:53:12.298429	1
117	333662		336	1	3	2026-07-25 07:53:12.298429	1
118	333259		337	1	3	2026-07-25 07:53:12.298429	1
119	333864		338	1	3	2026-07-25 07:53:12.298429	1
120	333684		339	1	3	2026-07-25 07:53:12.298429	1
121	333310		340	1	3	2026-07-25 07:53:12.298429	1
122	333568		341	1	3	2026-07-25 07:53:12.298429	1
123	333693		342	1	3	2026-07-25 07:53:12.298429	1
124	333451		343	1	3	2026-07-25 07:53:12.298429	1
125	333404		344	1	3	2026-07-25 07:53:12.298429	1
126	333562		345	1	3	2026-07-25 07:53:12.298429	1
127	333263		346	1	3	2026-07-25 07:53:12.298429	1
128	333264		347	1	3	2026-07-25 07:53:12.298429	1
129	333833		348	1	3	2026-07-25 07:53:12.298429	1
130	333372		349	1	3	2026-07-25 07:53:12.298429	1
131	333532		350	1	3	2026-07-25 07:53:12.298429	1
132	333176		351	1	3	2026-07-25 07:53:12.298429	1
133	333205		352	1	3	2026-07-25 07:53:12.298429	1
134	334014		353	1	3	2026-07-25 07:53:12.298429	1
135	333363		354	1	3	2026-07-25 07:53:12.298429	1
136	333971		355	1	3	2026-07-25 07:53:12.298429	1
137	333571		356	1	3	2026-07-25 07:53:12.298429	1
138	333267		357	1	3	2026-07-25 07:53:12.298429	1
139	333424		358	1	3	2026-07-25 07:53:12.298429	1
140	333556		359	1	3	2026-07-25 07:53:12.298429	1
141	333525		360	1	3	2026-07-25 07:53:12.298429	1
142	333481		361	1	3	2026-07-25 07:53:12.298429	1
143	22146		362	1	3	2026-07-25 07:53:12.298429	1
144	22098		363	1	3	2026-07-25 07:53:12.298429	1
145	333286		364	1	3	2026-07-25 07:53:12.298429	1
146	333432		365	1	3	2026-07-25 07:53:12.298429	1
147	952		366	1	3	2026-07-25 07:53:12.298429	1
148	333704		367	1	3	2026-07-25 07:53:12.298429	1
149	333491		368	1	3	2026-07-25 07:53:12.298429	1
150	333395		369	1	3	2026-07-25 07:53:12.298429	1
151	333266		370	1	3	2026-07-25 07:53:12.298429	1
152	333993		371	1	3	2026-07-25 07:53:12.298429	1
153	333886		372	1	3	2026-07-25 07:53:12.298429	1
154	70		373	1	3	2026-07-25 07:53:12.298429	1
155	81		374	1	3	2026-07-25 07:53:12.298429	1
156	22135		375	1	3	2026-07-25 07:53:12.298429	1
157	882		376	1	3	2026-07-25 07:53:12.298429	1
158	901		377	1	3	2026-07-25 07:53:12.298429	1
159	22052		378	1	3	2026-07-25 07:53:12.298429	1
160	21014		379	1	3	2026-07-25 07:53:12.298429	1
161	22130		380	1	3	2026-07-25 07:53:12.298429	1
162	639		381	1	3	2026-07-25 07:53:12.298429	1
163	23068		382	1	3	2026-07-25 07:53:12.298429	1
164	23039		383	1	3	2026-07-25 07:53:12.298429	1
165	945		384	1	3	2026-07-25 07:53:12.298429	1
166	676		385	1	3	2026-07-25 07:53:12.298429	1
167	489		386	1	3	2026-07-25 07:53:12.298429	1
168	109		387	1	3	2026-07-25 07:53:12.298429	1
169	877		388	1	3	2026-07-25 07:53:12.298429	1
170	69		389	1	3	2026-07-25 07:53:12.298429	1
171	922		390	1	3	2026-07-25 07:53:12.298429	1
172	21022		391	1	3	2026-07-25 07:53:12.298429	1
173	23045		392	1	3	2026-07-25 07:53:12.298429	1
174	21063		393	1	3	2026-07-25 07:53:12.298429	1
175	22142		394	1	3	2026-07-25 07:53:12.298429	1
176	21067		395	1	3	2026-07-25 07:53:12.298429	1
177	23013		396	1	3	2026-07-25 07:53:12.298429	1
178	21046		397	1	3	2026-07-25 07:53:12.298429	1
179	22010		398	1	3	2026-07-25 07:53:12.298429	1
180	21069		399	1	3	2026-07-25 07:53:12.298429	1
181	22038		400	1	3	2026-07-25 07:53:12.298429	1
182	21103		401	1	3	2026-07-25 07:53:12.298429	1
183	21068		402	1	3	2026-07-25 07:53:12.298429	1
184	21049		403	1	3	2026-07-25 07:53:12.298429	1
185	23012		404	1	3	2026-07-25 07:53:12.298429	1
186	24004		405	1	3	2026-07-25 07:53:12.298429	1
187	22131		406	1	3	2026-07-25 07:53:12.298429	1
188	23065		407	1	3	2026-07-25 07:53:12.298429	1
189	977		408	1	3	2026-07-25 07:53:12.298429	1
190	22081		409	1	3	2026-07-25 07:53:12.298429	1
191	22123		410	1	3	2026-07-25 07:53:12.298429	1
192	21034		411	1	3	2026-07-25 07:53:12.298429	1
193	23062		412	1	3	2026-07-25 07:53:12.298429	1
194	893		413	1	3	2026-07-25 07:53:12.298429	1
195	975		414	1	3	2026-07-25 07:53:12.298429	1
196	967		415	1	3	2026-07-25 07:53:12.298429	1
197	22077		416	1	3	2026-07-25 07:53:12.298429	1
198	21066		417	1	3	2026-07-25 07:53:12.298429	1
199	23015		418	1	3	2026-07-25 07:53:12.298429	1
200	22040		419	1	3	2026-07-25 07:53:12.298429	1
201	22079		420	1	3	2026-07-25 07:53:12.298429	1
202	21090		421	1	3	2026-07-25 07:53:12.298429	1
203	22106		422	1	3	2026-07-25 07:53:12.298429	1
204	23004		423	1	3	2026-07-25 07:53:12.298429	1
205	946		424	1	3	2026-07-25 07:53:12.298429	1
206	21095		425	1	3	2026-07-25 07:53:12.298429	1
207	968		426	1	3	2026-07-25 07:53:12.298429	1
208	21111		427	1	3	2026-07-25 07:53:12.298429	1
209	963		428	1	3	2026-07-25 07:53:12.298429	1
210	21058		429	1	3	2026-07-25 07:53:12.298429	1
211	21112		430	1	3	2026-07-25 07:53:12.298429	1
212	21015		431	1	3	2026-07-25 07:53:12.298429	1
213	875		432	1	3	2026-07-25 07:53:12.298429	1
214	21026		433	1	3	2026-07-25 07:53:12.298429	1
215	21033		434	1	3	2026-07-25 07:53:12.298429	1
216	707		435	1	3	2026-07-25 07:53:12.298429	1
217	22110		436	1	3	2026-07-25 07:53:12.298429	1
218	21045		437	1	3	2026-07-25 07:53:12.298429	1
219	23064		438	1	3	2026-07-25 07:53:12.298429	1
220	701		439	1	3	2026-07-25 07:53:12.298429	1
221	932		440	1	3	2026-07-25 07:53:12.298429	1
222	24018		441	1	3	2026-07-25 07:53:12.298429	1
223	24001		442	1	3	2026-07-25 07:53:12.298429	1
224	24017		443	1	3	2026-07-25 07:53:12.298429	1
225	21110		444	1	3	2026-07-25 07:53:12.298429	1
226	21071		445	1	3	2026-07-25 07:53:12.298429	1
227	21079		446	1	3	2026-07-25 07:53:12.298429	1
228	948		447	1	3	2026-07-25 07:53:12.298429	1
229	23014		448	1	3	2026-07-25 07:53:12.298429	1
230	21051		449	1	3	2026-07-25 07:53:12.298429	1
231	927		450	1	3	2026-07-25 07:53:12.298429	1
232	958		451	1	3	2026-07-25 07:53:12.298429	1
233	23044		452	1	3	2026-07-25 07:53:12.298429	1
234	24014		453	1	3	2026-07-25 07:53:12.298429	1
235	22095		454	1	3	2026-07-25 07:53:12.298429	1
236	21041		455	1	3	2026-07-25 07:53:12.298429	1
237	21089		456	1	3	2026-07-25 07:53:12.298429	1
238	23041		457	1	3	2026-07-25 07:53:12.298429	1
239	21065		458	1	3	2026-07-25 07:53:12.298429	1
240	23024		459	1	3	2026-07-25 07:53:12.298429	1
241	698		460	1	3	2026-07-25 07:53:12.298429	1
242	22117		461	1	3	2026-07-25 07:53:12.298429	1
243	21055		462	1	3	2026-07-25 07:53:12.298429	1
244	692		463	1	3	2026-07-25 07:53:12.298429	1
245	23008		464	1	3	2026-07-25 07:53:12.298429	1
246	23083		465	1	3	2026-07-25 07:53:12.298429	1
247	21016		466	1	3	2026-07-25 07:53:12.298429	1
248	986		467	1	3	2026-07-25 07:53:12.298429	1
249	22107		468	1	3	2026-07-25 07:53:12.298429	1
250	21091		469	1	3	2026-07-25 07:53:12.298429	1
251	21032		470	1	3	2026-07-25 07:53:12.298429	1
252	23020		471	1	3	2026-07-25 07:53:12.298429	1
253	976		472	1	3	2026-07-25 07:53:12.298429	1
254	23019		473	1	3	2026-07-25 07:53:12.298429	1
255	22141		474	1	3	2026-07-25 07:53:12.298429	1
256	981		475	1	3	2026-07-25 07:53:12.298429	1
257	954		476	1	3	2026-07-25 07:53:12.298429	1
258	694		477	1	3	2026-07-25 07:53:12.298429	1
259	642		478	1	3	2026-07-25 07:53:12.298429	1
260	22116		479	1	3	2026-07-25 07:53:12.298429	1
261	25041		480	1	3	2026-07-25 07:53:12.298429	1
262	21064		481	1	3	2026-07-25 07:53:12.298429	1
263	22009		482	1	3	2026-07-25 07:53:12.298429	1
264	992		483	1	3	2026-07-25 07:53:12.298429	1
265	21006		484	1	3	2026-07-25 07:53:12.298429	1
266	854		485	1	3	2026-07-25 07:53:12.298429	1
267	853		486	1	3	2026-07-25 07:53:12.298429	1
268	598		487	1	3	2026-07-25 07:53:12.298429	1
269	99000		488	1	3	2026-07-25 07:53:12.298429	1
270	135		489	1	3	2026-07-25 07:53:12.298429	1
271	990001		490	1	3	2026-07-25 07:53:12.298429	1
272	25055		491	1	3	2026-07-25 07:53:12.298429	1
273	333734		492	1	3	2026-07-25 07:53:12.298429	1
274	884		493	1	3	2026-07-25 07:53:12.298429	1
275	21030		494	1	3	2026-07-25 07:53:12.298429	1
276	21040		495	1	3	2026-07-25 07:53:12.298429	1
277	22001		496	1	3	2026-07-25 07:53:12.298429	1
278	333961		497	1	3	2026-07-25 07:53:12.298429	1
279	25014		498	1	3	2026-07-25 07:53:12.298429	1
280	333370		499	1	3	2026-07-25 07:53:12.298429	1
281	333988		500	1	3	2026-07-25 07:53:12.298429	1
282	333257		501	1	3	2026-07-25 07:53:12.298429	1
283	333293		502	1	3	2026-07-25 07:53:12.298429	1
284	333933		503	1	3	2026-07-25 07:53:12.298429	1
285	333990		504	1	3	2026-07-25 07:53:12.298429	1
286	482		505	1	3	2026-07-25 07:53:12.298429	1
287	23035		506	1	3	2026-07-25 07:53:12.298429	1
288	22115		507	1	3	2026-07-25 07:53:12.298429	1
289	895		508	1	3	2026-07-25 07:53:12.298429	1
290	591		509	1	3	2026-07-25 07:53:12.298429	1
291	83		510	1	3	2026-07-25 07:53:12.298429	1
292	333141		511	1	3	2026-07-25 07:53:12.298429	1
293	333876		512	1	3	2026-07-25 07:53:12.298429	1
294	333278		513	1	3	2026-07-25 07:53:12.298429	1
295	333463		514	1	3	2026-07-25 07:53:12.298429	1
296	22134		515	1	3	2026-07-25 07:53:12.298429	1
297	894		516	1	3	2026-07-25 07:53:12.298429	1
298	195		517	1	3	2026-07-25 07:53:12.298429	1
299	22060		518	1	3	2026-07-25 07:53:12.298429	1
300	23036		519	1	3	2026-07-25 07:53:12.298429	1
301	22132		520	1	3	2026-07-25 07:53:12.298429	1
302	22068		521	1	3	2026-07-25 07:53:12.298429	1
303	21054		522	1	3	2026-07-25 07:53:12.298429	1
304	966		523	1	3	2026-07-25 07:53:12.298429	1
305	22007		524	1	3	2026-07-25 07:53:12.298429	1
306	333792		525	1	3	2026-07-25 07:53:12.298429	1
307	333769		526	1	3	2026-07-25 07:53:12.298429	1
308	333804		527	1	3	2026-07-25 07:53:12.298429	1
309	333752		528	1	3	2026-07-25 07:53:12.298429	1
310	333816		529	1	3	2026-07-25 07:53:12.298429	1
311	334016		530	1	3	2026-07-25 07:53:12.298429	1
312	333374		531	1	3	2026-07-25 07:53:12.298429	1
313	333757		532	1	3	2026-07-25 07:53:12.298429	1
314	333416		533	1	3	2026-07-25 07:53:12.298429	1
315	333764		534	1	3	2026-07-25 07:53:12.298429	1
316	333173		535	1	3	2026-07-25 07:53:12.298429	1
317	333123		536	1	3	2026-07-25 07:53:12.298429	1
318	333868		537	1	3	2026-07-25 07:53:12.298429	1
319	333811		538	1	3	2026-07-25 07:53:12.298429	1
320	333578		539	1	3	2026-07-25 07:53:12.298429	1
321	333567		540	1	3	2026-07-25 07:53:12.298429	1
322	333794		541	1	3	2026-07-25 07:53:12.298429	1
323	333736		542	1	3	2026-07-25 07:53:12.298429	1
324	333756		543	1	3	2026-07-25 07:53:12.298429	1
325	333939		544	1	3	2026-07-25 07:53:12.298429	1
326	333378		545	1	3	2026-07-25 07:53:12.298429	1
327	333729		546	1	3	2026-07-25 07:53:12.298429	1
328	333243		547	1	3	2026-07-25 07:53:12.298429	1
329	333565		548	1	3	2026-07-25 07:53:12.298429	1
330	333574		549	1	3	2026-07-25 07:53:12.298429	1
331	333791		550	1	3	2026-07-25 07:53:12.298429	1
332	333796		551	1	3	2026-07-25 07:53:12.298429	1
333	333144		552	1	3	2026-07-25 07:53:12.298429	1
334	333441		553	1	3	2026-07-25 07:53:12.298429	1
335	334002		554	1	3	2026-07-25 07:53:12.298429	1
336	333953		555	1	3	2026-07-25 07:53:12.298429	1
337	333753		556	1	3	2026-07-25 07:53:12.298429	1
338	333449		557	1	3	2026-07-25 07:53:12.298429	1
339	333987		558	1	3	2026-07-25 07:53:12.298429	1
340	333749		559	1	3	2026-07-25 07:53:12.298429	1
341	333964		560	1	3	2026-07-25 07:53:12.298429	1
342	333754		561	1	3	2026-07-25 07:53:12.298429	1
343	333841		562	1	3	2026-07-25 07:53:12.298429	1
344	333398		563	1	3	2026-07-25 07:53:12.298429	1
345	333138		564	1	3	2026-07-25 07:53:12.298429	1
346	333448		565	1	3	2026-07-25 07:53:12.298429	1
347	333414		566	1	3	2026-07-25 07:53:12.298429	1
348	333731		567	1	3	2026-07-25 07:53:12.298429	1
349	333935		568	1	3	2026-07-25 07:53:12.298429	1
350	333137		569	1	3	2026-07-25 07:53:12.298429	1
351	333766		570	1	3	2026-07-25 07:53:12.298429	1
352	333913		571	1	3	2026-07-25 07:53:12.298429	1
353	333806		572	1	3	2026-07-25 07:53:12.298429	1
354	333895		573	1	3	2026-07-25 07:53:12.298429	1
355	333442		574	1	3	2026-07-25 07:53:12.298429	1
356	333649		575	1	3	2026-07-25 07:53:12.298429	1
357	333936		576	1	3	2026-07-25 07:53:12.298429	1
358	333750		577	1	3	2026-07-25 07:53:12.298429	1
359	333992		578	1	3	2026-07-25 07:53:12.298429	1
360	333746		579	1	3	2026-07-25 07:53:12.298429	1
361	333743		580	1	3	2026-07-25 07:53:12.298429	1
362	333417		581	1	3	2026-07-25 07:53:12.298429	1
363	333415		582	1	3	2026-07-25 07:53:12.298429	1
364	333771		583	1	3	2026-07-25 07:53:12.298429	1
365	333858		584	1	3	2026-07-25 07:53:12.298429	1
366	333814		585	1	3	2026-07-25 07:53:12.298429	1
367	333563		586	1	3	2026-07-25 07:53:12.298429	1
368	333439		587	1	3	2026-07-25 07:53:12.298429	1
369	333283		588	1	3	2026-07-25 07:53:12.298429	1
370	333931		589	1	3	2026-07-25 07:53:12.298429	1
371	333608		590	1	3	2026-07-25 07:53:12.298429	1
372	333467		591	1	3	2026-07-25 07:53:12.298429	1
373	333812		592	1	3	2026-07-25 07:53:12.298429	1
374	333730		593	1	3	2026-07-25 07:53:12.298429	1
375	333867		594	1	3	2026-07-25 07:53:12.298429	1
376	333759		595	1	3	2026-07-25 07:53:12.298429	1
377	333418		596	1	3	2026-07-25 07:53:12.298429	1
378	333748		597	1	3	2026-07-25 07:53:12.298429	1
379	23076		598	1	3	2026-07-25 07:53:12.298429	1
380	22137		599	1	3	2026-07-25 07:53:12.298429	1
381	333546		600	1	3	2026-07-25 07:53:12.298429	1
382	21072		601	1	3	2026-07-25 07:53:12.298429	1
383	334009		602	1	3	2026-07-25 07:53:12.298429	1
384	333544		603	1	3	2026-07-25 07:53:12.298429	1
385	333986		604	1	3	2026-07-25 07:53:12.298429	1
386	333437		605	1	3	2026-07-25 07:53:12.298429	1
387	23003		606	1	3	2026-07-25 07:53:12.298429	1
\.


--
-- TOC entry 3830 (class 0 OID 466546)
-- Dependencies: 240
-- Data for Name: asset_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_models (id, asset_brand_id, model_type_id) FROM stdin;
1	1	1
2	2	2
3	3	5
4	4	6
5	5	3
6	6	4
7	9	8
8	12	9
9	16	10
10	17	11
11	17	12
12	18	13
13	16	14
14	19	15
15	20	16
16	21	17
17	22	18
18	23	20
19	24	21
20	17	22
21	18	23
22	25	24
23	25	25
24	17	26
25	17	27
26	26	28
27	29	29
28	26	30
29	16	31
30	5	32
31	31	33
32	32	34
33	33	35
34	34	36
35	23	37
36	17	38
37	35	39
38	36	40
39	37	41
40	38	42
41	38	43
42	18	44
43	1	45
44	40	46
45	41	47
46	42	48
47	43	49
48	43	50
49	43	51
50	44	52
51	37	53
52	5	55
53	5	56
54	5	57
55	5	58
56	5	59
57	18	60
58	45	61
59	34	62
60	38	64
61	37	65
62	46	66
63	1	67
64	31	68
65	31	69
66	31	70
67	31	71
68	47	72
69	19	73
70	43	74
71	29	75
72	17	76
73	37	77
74	31	78
75	31	79
76	48	80
77	49	81
78	50	82
79	25	83
80	17	84
81	51	84
82	17	85
83	31	86
84	31	87
85	31	88
86	31	89
87	52	90
88	51	91
89	49	92
90	53	93
91	25	94
92	54	95
93	55	96
94	56	97
95	19	98
96	38	99
97	1	100
98	43	101
99	29	102
100	24	103
101	22	104
102	47	105
103	1	106
104	22	107
105	37	108
106	1	109
107	33	110
108	43	111
109	45	112
110	45	113
111	29	114
112	38	115
113	57	116
114	58	117
115	52	118
116	59	119
117	26	120
118	60	121
119	43	122
120	61	123
121	5	124
122	5	125
123	29	126
124	5	127
125	62	128
126	22	129
127	63	130
128	45	131
129	34	132
130	64	133
131	17	134
132	23	135
133	43	136
134	23	137
135	29	138
136	65	139
137	23	140
138	29	141
139	23	142
140	66	143
141	67	144
142	67	145
143	1	146
144	68	63
\.


--
-- TOC entry 3865 (class 0 OID 466991)
-- Dependencies: 275
-- Data for Name: asset_placements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_placements (id, registered_asset_id, placement_type_id, event_notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.


--
-- TOC entry 3843 (class 0 OID 466643)
-- Dependencies: 253
-- Data for Name: asset_registrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_registrations (id, acquisition_type_id, reference_attachment, reference_type_id, supplier_id, notes, event_register_id, event_station_id, event_admin_id, stamp, reference_date, program_id) FROM stdin;
12	5		5	11		25	1	3	2026-07-25 06:03:05.303387	2024-12-04	1
13	5		5	12		26	1	3	2026-07-25 06:03:05.303387	2018-10-15	1
14	5		5	13		27	1	3	2026-07-25 06:03:05.303387	2018-02-13	1
15	5		5	12		28	1	3	2026-07-25 06:03:05.303387	2018-10-31	1
16	5		5	14		29	1	3	2026-07-25 06:03:05.303387	2020-12-23	1
17	5		5	15		30	1	3	2026-07-25 06:03:05.303387	2022-03-17	1
18	5		5	16		31	1	3	2026-07-25 06:03:05.303387	2022-02-18	1
19	5		5	12		32	1	3	2026-07-25 06:03:05.303387	2018-04-10	1
20	5		5	17		33	1	3	2026-07-25 06:03:05.303387	2018-03-05	1
21	5		5	17		34	1	3	2026-07-25 06:03:05.303387	2019-05-15	1
22	5		5	18		35	1	3	2026-07-25 06:03:05.303387	2019-05-15	1
23	5		5	19		36	1	3	2026-07-25 06:03:05.303387	2021-04-10	1
24	5		5	13		37	1	3	2026-07-25 06:03:05.303387	2019-10-29	1
25	5		5	20		38	1	3	2026-07-25 06:03:05.303387	2018-01-16	1
26	5		5	21		39	1	3	2026-07-25 06:03:05.303387	2018-06-07	1
27	5		5	22		40	1	3	2026-07-25 06:03:05.303387	2023-01-25	1
28	5		5	23		41	1	3	2026-07-25 06:03:05.303387	2018-10-24	1
29	5		5	20		42	1	3	2026-07-25 06:03:05.303387	2023-02-02	1
30	5		5	13		43	1	3	2026-07-25 06:03:05.303387	2017-02-13	1
31	5		5	17		44	1	3	2026-07-25 06:03:05.303387	2018-08-05	1
32	5		5	24		45	1	3	2026-07-25 06:03:05.303387	2019-10-29	1
33	5		5	12		46	1	3	2026-07-25 06:03:05.303387	2020-08-05	1
34	5		5	25		47	1	3	2026-07-25 06:03:05.303387	2021-08-17	1
35	5		5	26		48	1	3	2026-07-25 06:03:05.303387	2023-04-09	1
36	5		5	26		49	1	3	2026-07-25 06:03:05.303387	2020-06-18	1
37	5		5	12		50	1	3	2026-07-25 06:03:05.303387	2018-01-10	1
38	5		5	20		51	1	3	2026-07-25 06:03:05.303387	2023-06-20	1
39	5		5	27		52	1	3	2026-07-25 06:03:05.303387	2023-04-13	1
40	5		5	27		53	1	3	2026-07-25 06:03:05.303387	2023-04-17	1
41	5		5	28		54	1	3	2026-07-25 06:03:05.303387	2021-05-21	1
42	5		5	28		55	1	3	2026-07-25 06:03:05.303387	2022-03-18	1
43	5		5	29		56	1	3	2026-07-25 06:03:05.303387	2022-12-22	8
44	5		5	12		57	1	3	2026-07-25 06:03:05.303387	2018-02-11	1
45	5		5	12		58	1	3	2026-07-25 06:03:05.303387	2018-04-18	1
46	5		5	30		59	1	3	2026-07-25 06:03:05.303387	2025-06-23	1
47	5		5	31		60	1	3	2026-07-25 06:03:05.303387	2024-05-22	1
48	5		5	32		61	1	3	2026-07-25 06:03:05.303387	2021-12-10	1
49	5		5	32		62	1	3	2026-07-25 06:03:05.303387	2021-10-14	1
50	5		5	33		63	1	3	2026-07-25 06:03:05.303387	2025-08-18	9
51	5		5	15		64	1	3	2026-07-25 06:03:05.303387	2025-09-17	1
52	5		5	20		65	1	3	2026-07-25 06:03:05.303387	2024-05-09	1
53	5		5	20		66	1	3	2026-07-25 06:03:05.303387	2018-10-15	1
54	5		5	34		67	1	3	2026-07-25 06:03:05.303387	2023-02-08	1
55	5		5	32		68	1	3	2026-07-25 06:03:05.303387	2021-08-09	1
56	5		5	18		69	1	3	2026-07-25 06:03:05.303387	2018-01-16	1
57	5		5	30		70	1	3	2026-07-25 06:03:05.303387	2015-08-30	1
58	5		5	35		71	1	3	2026-07-25 06:03:05.303387	2023-07-20	10
59	5		5	12		72	1	3	2026-07-25 06:03:05.303387	2023-05-23	11
60	5		5	27		73	1	3	2026-07-25 06:03:05.303387	2025-05-28	10
61	5		5	36		74	1	3	2026-07-25 06:03:05.303387	2025-12-16	1
62	5		5	20		75	1	3	2026-07-25 06:03:05.303387	2021-04-29	1
63	5		5	12		76	1	3	2026-07-25 06:03:05.303387	2017-10-10	1
64	5		5	31		77	1	3	2026-07-25 06:03:05.303387	2022-09-06	1
65	5		5	37		78	1	3	2026-07-25 06:03:05.303387	2021-03-31	1
66	5		5	30		79	1	3	2026-07-25 06:03:05.303387	2017-03-30	1
67	5		5	37		80	1	3	2026-07-25 06:03:05.303387	2021-09-04	1
68	5		5	37		81	1	3	2026-07-25 06:03:05.303387	2022-01-14	1
69	5		5	30		82	1	3	2026-07-25 06:03:05.303387	2024-04-29	1
70	5		5	37		83	1	3	2026-07-25 06:03:05.303387	2020-04-20	1
71	5		5	37		84	1	3	2026-07-25 06:03:05.303387	2024-01-02	1
72	5		5	30		85	1	3	2026-07-25 06:03:05.303387	2018-05-03	1
73	5		5	38		86	1	3	2026-07-25 06:03:05.303387	2016-05-08	1
74	5		5	37		87	1	3	2026-07-25 06:03:05.303387	2024-01-02	10
75	5		5	37		88	1	3	2026-07-25 06:03:05.303387	2021-07-04	1
76	5		5	39		89	1	3	2026-07-25 06:03:05.303387	2017-10-20	1
77	5		5	40		90	1	3	2026-07-25 06:03:05.303387	2020-12-31	1
78	5		5	34		91	1	3	2026-07-25 06:03:05.303387	2024-05-17	1
79	5		5	34		92	1	3	2026-07-25 06:03:05.303387	2025-11-24	1
80	5		5	16		93	1	3	2026-07-25 06:03:05.303387	2023-08-25	1
81	5		5	41		94	1	3	2026-07-25 06:03:05.303387	2023-04-01	1
82	5		5	37		95	1	3	2026-07-25 06:03:05.303387	2023-12-19	1
83	5		5	37		96	1	3	2026-07-25 06:03:05.303387	2018-11-14	1
84	5		5	30		97	1	3	2026-07-25 06:03:05.303387	2021-02-19	1
85	5		5	37		98	1	3	2026-07-25 06:03:05.303387	2020-11-14	1
86	5		5	37		99	1	3	2026-07-25 06:03:05.303387	2018-11-23	1
87	5		5	37		100	1	3	2026-07-25 06:03:05.303387	2024-02-04	1
88	5		5	30		101	1	3	2026-07-25 06:03:05.303387	2017-08-05	1
89	5		5	37		102	1	3	2026-07-25 06:03:05.303387	2022-10-25	10
90	5		5	16		103	1	3	2026-07-25 06:03:05.303387	2023-02-06	1
91	5		5	20		104	1	3	2026-07-25 06:03:05.303387	2023-09-14	1
92	5		5	42		105	1	3	2026-07-25 06:03:05.303387	2021-06-29	1
93	5		5	16		106	1	3	2026-07-25 06:03:05.303387	2023-07-27	1
94	5		5	17		107	1	3	2026-07-25 06:03:05.303387	2017-03-04	1
95	5		5	20		108	1	3	2026-07-25 06:03:05.303387	2021-10-11	1
96	5		5	17		109	1	3	2026-07-25 06:03:05.303387	2019-04-23	1
97	5		5	12		110	1	3	2026-07-25 06:03:05.303387	2018-10-21	1
98	5		5	16		111	1	3	2026-07-25 06:03:05.303387	2018-10-15	1
99	5		5	20		112	1	3	2026-07-25 06:03:05.303387	2022-11-02	1
100	5		5	43		113	1	3	2026-07-25 06:03:05.303387	2021-01-02	1
101	5		5	20		114	1	3	2026-07-25 06:03:05.303387	2021-10-18	1
102	5		5	13		115	1	3	2026-07-25 06:03:05.303387	2017-12-19	1
103	5		5	13		116	1	3	2026-07-25 06:03:05.303387	2017-02-17	1
104	5		5	34		117	1	3	2026-07-25 06:03:05.303387	2018-10-17	1
105	5		5	44		118	1	3	2026-07-25 06:03:05.303387	2021-12-17	1
106	5		5	45		119	1	3	2026-07-25 06:03:05.303387	2021-08-02	1
107	5		5	46		120	1	3	2026-07-25 06:03:05.303387	2023-11-09	1
108	5		5	47		121	1	3	2026-07-25 06:03:05.303387	2024-03-07	1
109	5		5	48		122	1	3	2026-07-25 06:03:05.303387	2023-11-09	1
110	5		5	39		123	1	3	2026-07-25 06:03:05.303387	2024-05-03	1
111	5		5	22		124	1	3	2026-07-25 06:03:05.303387	2024-03-15	1
112	5		5	25		125	1	3	2026-07-25 06:03:05.303387	2021-02-08	1
113	5		5	25		126	1	3	2026-07-25 06:03:05.303387	2021-04-08	1
114	5		5	17		127	1	3	2026-07-25 06:03:05.303387	2019-01-04	1
115	5		5	12		128	1	3	2026-07-25 06:03:05.303387	2018-05-10	1
116	5		5	49		129	1	3	2026-07-25 06:03:05.303387	2021-10-30	1
117	5		5	50		130	1	3	2026-07-25 06:03:05.303387	2020-04-09	1
118	5		5	51		131	1	3	2026-07-25 06:03:05.303387	2023-12-18	1
119	5		5	52		132	1	3	2026-07-25 06:03:05.303387	2021-10-02	1
120	5		5	16		133	1	3	2026-07-25 06:03:05.303387	2022-03-18	1
121	5		5	53		134	1	3	2026-07-25 06:03:05.303387	2022-03-18	1
122	5		5	53		135	1	3	2026-07-25 06:03:05.303387	2018-10-15	1
123	5		5	54		136	1	3	2026-07-25 06:03:05.303387	2018-10-15	1
124	5		5	12		137	1	3	2026-07-25 06:03:05.303387	2019-08-01	1
125	5		5	55		138	1	3	2026-07-25 06:03:05.303387	2019-08-01	1
126	5		5	36		139	1	3	2026-07-25 06:03:05.303387	2026-01-14	1
127	5		5	53		140	1	3	2026-07-25 06:03:05.303387	2021-04-21	1
128	5		5	56		141	1	3	2026-07-25 06:03:05.303387	2021-02-27	1
129	5		5	53		142	1	3	2026-07-25 06:03:05.303387	2021-04-28	1
130	5		5	53		143	1	3	2026-07-25 06:03:05.303387	2024-05-08	8
131	5		5	20		144	1	3	2026-07-25 06:03:05.303387	2021-04-11	1
132	5		5	15		145	1	3	2026-07-25 06:03:05.303387	2021-09-17	1
133	5		5	57		146	1	3	2026-07-25 06:03:05.303387	2023-11-16	1
134	5		5	57		147	1	3	2026-07-25 06:03:05.303387	2024-03-06	1
135	5		5	58		148	1	3	2026-07-25 06:03:05.303387	2023-01-31	1
136	5		5	15		149	1	3	2026-07-25 06:03:05.303387	2021-10-11	1
137	5		5	15		150	1	3	2026-07-25 06:03:05.303387	2021-10-11	12
138	5		5	57		151	1	3	2026-07-25 06:03:05.303387	2024-09-07	1
139	5		5	15		152	1	3	2026-07-25 06:03:05.303387	2022-04-14	1
140	5		5	15		153	1	3	2026-07-25 06:03:05.303387	2022-03-28	1
141	5		5	37		154	1	3	2026-07-25 06:03:05.303387	2024-03-01	10
142	5		5	40		155	1	3	2026-07-25 06:03:05.303387	2021-05-03	1
143	5		5	15		156	1	3	2026-07-25 06:03:05.303387	2021-03-08	1
144	5		5	16		157	1	3	2026-07-25 06:03:05.303387	2021-05-31	1
145	5		5	20		158	1	3	2026-07-25 06:03:05.303387	2020-02-11	1
146	5		5	31		159	1	3	2026-07-25 06:03:05.303387	2019-10-15	1
147	5		5	17		160	1	3	2026-07-25 06:03:05.303387	2019-04-17	1
148	5		5	59		161	1	3	2026-07-25 06:03:05.303387	2019-07-01	1
149	5		5	59		162	1	3	2026-07-25 06:03:05.303387	2018-10-15	1
150	5		5	59		163	1	3	2026-07-25 06:03:05.303387	2021-07-07	1
151	5		5	59		164	1	3	2026-07-25 06:03:05.303387	2019-08-01	1
152	5		5	12		165	1	3	2026-07-25 06:03:05.303387	2021-12-20	1
153	5		5	60		166	1	3	2026-07-25 06:03:05.303387	2021-11-02	1
154	5		5	61		167	1	3	2026-07-25 06:03:05.303387	2024-05-17	1
155	5		5	47		168	1	3	2026-07-25 06:03:05.303387	2024-04-03	1
156	5		5	62		169	1	3	2026-07-25 06:03:05.303387	2024-04-12	13
157	5		5	15		170	1	3	2026-07-25 06:03:05.303387	2021-05-21	1
158	5		5	15		171	1	3	2026-07-25 06:03:05.303387	2021-04-28	1
159	5		5	12		172	1	3	2026-07-25 06:03:05.303387	2018-10-10	1
160	5		5	57		173	1	3	2026-07-25 06:03:05.303387	2025-03-10	9
161	5		5	16		174	1	3	2026-07-25 06:03:05.303387	2018-10-15	12
162	5		5	20		175	1	3	2026-07-25 06:03:05.303387	2021-07-26	1
163	5		5	12		176	1	3	2026-07-25 06:03:05.303387	2018-10-18	1
164	5		5	30		177	1	3	2026-07-25 06:03:05.303387	2017-08-30	1
165	5		5	30		178	1	3	2026-07-25 06:03:05.303387	2024-02-04	1
166	5		5	16		179	1	3	2026-07-25 06:03:05.303387	2021-07-21	1
167	5		5	16		180	1	3	2026-07-25 06:03:05.303387	2021-12-17	1
168	5		5	16		181	1	3	2026-07-25 06:03:05.303387	2021-02-27	1
169	5		5	15		182	1	3	2026-07-25 06:03:05.303387	2019-07-03	1
170	5		5	16		183	1	3	2026-07-25 06:03:05.303387	2022-05-13	1
171	5		5	12		184	1	3	2026-07-25 06:03:05.303387	2021-10-15	1
172	5		5	34		185	1	3	2026-07-25 06:03:05.303387	2021-02-26	1
173	5		5	63		186	1	3	2026-07-25 06:03:05.303387	2023-09-29	1
174	5		5	63		187	1	3	2026-07-25 06:03:05.303387	2023-11-13	1
175	5		5	64		188	1	3	2026-07-25 06:03:05.303387	2024-02-28	1
176	5		5	63		189	1	3	2026-07-25 06:03:05.303387	2024-02-23	1
177	5		5	20		190	1	3	2026-07-25 06:03:05.303387	2023-10-25	1
178	5		5	65		191	1	3	2026-07-25 06:03:05.303387	2024-11-25	1
179	5		5	65		192	1	3	2026-07-25 06:03:05.303387	2024-09-12	1
180	5		5	24		193	1	3	2026-07-25 06:03:05.303387	2017-12-19	1
181	5		5	49		194	1	3	2026-07-25 06:03:05.303387	2021-12-30	1
182	5		5	49		195	1	3	2026-07-25 06:03:05.303387	2021-08-23	1
183	5		5	49		196	1	3	2026-07-25 06:03:05.303387	2021-08-31	1
184	5		5	49		197	1	3	2026-07-25 06:03:05.303387	2021-12-28	1
185	5		5	12		198	1	3	2026-07-25 06:03:05.303387	2018-07-18	1
186	5		5	12		199	1	3	2026-07-25 06:03:05.303387	2018-07-27	1
187	5		5	18		200	1	3	2026-07-25 06:03:05.303387	2021-07-07	1
188	5		5	18		201	1	3	2026-07-25 06:03:05.303387	2018-04-07	1
189	5		5	12		202	1	3	2026-07-25 06:03:05.303387	2018-07-25	1
190	5		5	12		203	1	3	2026-07-25 06:03:05.303387	2013-12-02	1
191	5		5	12		204	1	3	2026-07-25 06:03:05.303387	2017-12-13	1
192	5		5	66		205	1	3	2026-07-25 06:03:05.303387	2020-12-21	1
193	5		5	66		206	1	3	2026-07-25 06:03:05.303387	2018-10-15	1
194	5		5	44		207	1	3	2026-07-25 06:03:05.303387	2024-03-06	10
195	5		5	15		208	1	3	2026-07-25 06:03:05.303387	2025-02-06	10
196	5		5	36		209	1	3	2026-07-25 06:03:05.303387	2026-09-02	1
197	5		5	67		210	1	3	2026-07-25 06:03:05.303387	2025-06-05	9
\.


--
-- TOC entry 3863 (class 0 OID 466971)
-- Dependencies: 273
-- Data for Name: asset_request_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_request_items (id, asset_request_id, requested_asset_type_id, requested_quantity) FROM stdin;
\.


--
-- TOC entry 3861 (class 0 OID 466939)
-- Dependencies: 271
-- Data for Name: asset_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_requests (id, event_notes, event_register_id, request_program_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.


--
-- TOC entry 3849 (class 0 OID 466747)
-- Dependencies: 259
-- Data for Name: asset_transfer_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_transfer_items (id, asset_transfer_id, registered_asset_id) FROM stdin;
8	6	18
9	6	43
10	6	115
11	6	145
12	6	146
13	6	170
14	6	171
15	6	172
16	6	173
17	6	174
18	6	362
19	6	403
20	6	437
21	6	438
22	6	439
23	6	440
24	6	441
25	6	442
26	6	443
27	6	444
28	6	445
29	6	446
30	6	447
31	6	448
32	6	449
33	6	450
34	6	451
35	6	452
36	6	453
37	6	454
38	6	497
39	6	498
40	6	546
41	6	572
42	6	578
43	6	579
44	6	580
45	6	581
46	6	582
47	6	583
48	6	584
49	6	676
50	6	685
51	6	707
52	6	710
53	6	730
54	6	731
55	6	767
56	6	771
57	6	790
58	6	791
59	6	802
60	6	820
61	6	850
62	6	855
63	6	878
64	6	879
65	6	925
66	6	926
67	6	927
68	6	928
69	6	929
70	6	930
71	6	931
72	6	966
73	6	978
74	6	987
75	6	999
76	6	1000
77	6	1001
78	6	1002
79	6	1003
80	6	1004
81	6	1005
82	6	1037
83	6	1038
84	6	1572
85	6	1573
86	6	1574
87	6	1612
88	6	1613
89	6	1694
90	6	1714
91	6	1738
92	6	1769
93	6	1777
94	6	1810
95	6	1811
96	6	1812
97	6	1866
98	6	1868
99	6	1869
100	6	1974
101	6	2158
102	6	2165
103	6	2178
104	6	2189
105	6	2199
106	6	2200
107	6	2228
108	6	2229
109	6	2230
110	6	2239
111	6	2267
112	6	2285
113	6	2302
114	6	2303
115	6	2304
116	6	2305
117	6	2306
118	6	2307
119	6	2308
120	6	2331
121	6	2332
122	6	2365
123	6	2366
124	6	2367
125	6	2368
126	6	2369
127	6	2370
128	6	2371
129	7	19
130	7	28
131	7	29
132	7	92
133	7	93
134	7	94
135	7	95
136	7	109
137	7	110
138	7	147
139	7	148
140	7	175
141	7	176
142	7	215
143	7	222
144	7	230
145	7	247
146	7	248
147	7	250
148	7	263
149	7	266
150	7	271
151	7	274
152	7	286
153	7	301
154	7	302
155	7	311
156	7	315
157	7	329
158	7	400
159	7	456
160	7	457
161	7	458
162	7	459
163	7	460
164	7	461
165	7	479
166	7	480
167	7	499
168	7	528
169	7	554
170	7	564
171	7	577
172	7	602
173	7	615
174	7	625
175	7	629
176	7	638
177	7	643
178	7	658
179	7	665
180	7	733
181	7	835
182	7	839
183	7	882
184	7	933
185	7	934
186	7	935
187	7	968
188	7	1045
189	7	1047
190	7	1049
191	7	1064
192	7	1065
193	7	1076
194	7	1078
195	7	1084
196	7	1093
197	7	1125
198	7	1126
199	7	1131
200	7	1132
201	7	1204
202	7	1205
203	7	1208
204	7	1215
205	7	1250
206	7	1251
207	7	1252
208	7	1255
209	7	1363
210	7	1364
211	7	1365
212	7	1366
213	7	1367
214	7	1368
215	7	1369
216	7	1370
217	7	1371
218	7	1372
219	7	1373
220	7	1374
221	7	1420
222	7	1496
223	7	1501
224	7	1502
225	7	1506
226	7	1507
227	7	1588
228	7	1616
229	7	1641
230	7	1644
231	7	1669
232	7	1680
233	7	1693
234	7	1697
235	7	1740
236	7	1753
237	7	1758
238	7	1818
239	7	1819
240	7	1820
241	7	1821
242	7	1822
243	7	1823
244	7	1824
245	7	1856
246	7	1870
247	7	1883
248	7	1914
249	7	1938
250	7	1939
251	7	1958
252	7	1960
253	7	1961
254	7	1978
255	7	1996
256	7	2013
257	7	2031
258	7	2040
259	7	2044
260	7	2074
261	7	2085
262	7	2086
263	7	2087
264	7	2088
265	7	2110
266	7	2111
267	7	2147
268	7	2154
269	7	2160
270	7	2201
271	7	2212
272	7	2213
273	7	2214
274	7	2215
275	7	2216
276	7	2240
277	7	2244
278	7	2245
279	7	2248
280	7	2255
281	7	2312
282	7	2385
283	7	2388
284	7	2391
285	7	2412
286	7	2413
287	7	2414
288	7	2415
289	7	2416
290	8	20
291	8	21
292	8	48
293	8	49
294	8	50
295	8	51
296	8	52
297	8	53
298	8	54
299	8	87
300	8	88
301	8	105
302	8	106
303	8	107
304	8	129
305	8	141
306	8	142
307	8	160
308	8	161
309	8	162
310	8	163
311	8	200
312	8	216
313	8	233
314	8	265
315	8	285
316	8	295
317	8	297
318	8	298
319	8	299
320	8	317
321	8	318
322	8	319
323	8	320
324	8	327
325	8	328
326	8	334
327	8	335
328	8	336
329	8	356
330	8	372
331	8	373
332	8	374
333	8	406
334	8	407
335	8	408
336	8	409
337	8	410
338	8	411
339	8	412
340	8	533
341	8	534
342	8	535
343	8	536
344	8	550
345	8	553
346	8	563
347	8	567
348	8	568
349	8	571
350	8	573
351	8	588
352	8	590
353	8	593
354	8	598
355	8	601
356	8	603
357	8	604
358	8	605
359	8	606
360	8	608
361	8	610
362	8	614
363	8	616
364	8	621
365	8	627
366	8	630
367	8	639
368	8	640
369	8	645
370	8	649
371	8	653
372	8	654
373	8	660
374	8	661
375	8	663
376	8	666
377	8	668
378	8	684
379	8	689
380	8	693
381	8	702
382	8	703
383	8	714
384	8	715
385	8	716
386	8	717
387	8	718
388	8	719
389	8	720
390	8	721
391	8	742
392	8	757
393	8	789
394	8	795
395	8	803
396	8	814
397	8	815
398	8	824
399	8	849
400	8	860
401	8	861
402	8	862
403	8	911
404	8	912
405	8	913
406	8	914
407	8	915
408	8	916
409	8	920
410	8	937
411	8	959
412	8	962
413	8	984
414	8	985
415	8	986
416	8	1019
417	8	1040
418	8	1097
419	8	1197
420	8	1198
421	8	1199
422	8	1200
423	8	1201
424	8	1258
425	8	1259
426	8	1260
427	8	1261
428	8	1262
429	8	1263
430	8	1264
431	8	1265
432	8	1266
433	8	1267
434	8	1268
435	8	1269
436	8	1270
437	8	1271
438	8	1272
439	8	1273
440	8	1274
441	8	1275
442	8	1276
443	8	1277
444	8	1278
445	8	1279
446	8	1280
447	8	1281
448	8	1282
449	8	1283
450	8	1284
451	8	1285
452	8	1286
453	8	1287
454	8	1288
455	8	1289
456	8	1290
457	8	1291
458	8	1292
459	8	1293
460	8	1294
461	8	1295
462	8	1296
463	8	1297
464	8	1298
465	8	1299
466	8	1300
467	8	1301
468	8	1302
469	8	1303
470	8	1304
471	8	1305
472	8	1509
473	8	1522
474	8	1568
475	8	1570
476	8	1576
477	8	1585
478	8	1586
479	8	1587
480	8	1597
481	8	1600
482	8	1601
483	8	1602
484	8	1605
485	8	1618
486	8	1619
487	8	1621
488	8	1627
489	8	1634
490	8	1635
491	8	1645
492	8	1646
493	8	1647
494	8	1650
495	8	1657
496	8	1661
497	8	1662
498	8	1664
499	8	1665
500	8	1666
501	8	1667
502	8	1675
503	8	1685
504	8	1686
505	8	1688
506	8	1711
507	8	1722
508	8	1736
509	8	1755
510	8	1763
511	8	1787
512	8	1788
513	8	1789
514	8	1790
515	8	1799
516	8	1840
517	8	1841
518	8	1842
519	8	1843
520	8	1844
521	8	1845
522	8	1846
523	8	1865
524	8	1871
525	8	1873
526	8	1874
527	8	1875
528	8	1877
529	8	1879
530	8	1890
531	8	1895
532	8	1905
533	8	1910
534	8	1912
535	8	1916
536	8	1919
537	8	1924
538	8	1925
539	8	1935
540	8	1936
541	8	1941
542	8	1942
543	8	1947
544	8	1963
545	8	1965
546	8	1968
547	8	1969
548	8	1970
549	8	1976
550	8	1979
551	8	1986
552	8	1989
553	8	1991
554	8	1993
555	8	1994
556	8	1998
557	8	2003
558	8	2022
559	8	2026
560	8	2027
561	8	2028
562	8	2029
563	8	2035
564	8	2037
565	8	2041
566	8	2054
567	8	2055
568	8	2057
569	8	2061
570	8	2063
571	8	2072
572	8	2073
573	8	2076
574	8	2077
575	8	2078
576	8	2079
577	8	2084
578	8	2093
579	8	2094
580	8	2095
581	8	2106
582	8	2118
583	8	2119
584	8	2126
585	8	2127
586	8	2128
587	8	2129
588	8	2130
589	8	2131
590	8	2132
591	8	2134
592	8	2135
593	8	2150
594	8	2174
595	8	2177
596	8	2180
597	8	2188
598	8	2194
599	8	2195
600	8	2196
601	8	2222
602	8	2223
603	8	2224
604	8	2226
605	8	2232
606	8	2282
607	8	2283
608	8	2284
609	8	2294
610	8	2328
611	8	2329
612	8	2330
613	8	2357
614	9	22
615	9	23
616	9	65
617	9	66
618	9	67
619	9	68
620	9	69
621	9	126
622	9	164
623	9	165
624	9	166
625	9	192
626	9	193
627	9	194
628	9	196
629	9	206
630	9	224
631	9	225
632	9	226
633	9	232
634	9	236
635	9	237
636	9	261
637	9	276
638	9	277
639	9	290
640	9	292
641	9	300
642	9	310
643	9	313
644	9	331
645	9	348
646	9	365
647	9	375
648	9	382
649	9	383
650	9	393
651	9	413
652	9	414
653	9	415
654	9	416
655	9	462
656	9	481
657	9	529
658	9	557
659	9	566
660	9	586
661	9	587
662	9	613
663	9	624
664	9	628
665	9	631
666	9	641
667	9	646
668	9	659
669	9	686
670	9	701
671	9	766
672	9	793
673	9	840
674	9	863
675	9	865
676	9	917
677	9	963
678	9	988
679	9	991
680	9	1009
681	9	1035
682	9	1056
683	9	1058
684	9	1063
685	9	1067
686	9	1068
687	9	1069
688	9	1088
689	9	1089
690	9	1095
691	9	1596
692	9	1617
693	9	1668
694	9	1670
695	9	1679
696	9	1692
697	9	1744
698	9	1760
699	9	1770
700	9	1791
701	9	1829
702	9	1908
703	9	1940
704	9	2034
705	9	2062
706	9	2069
707	9	2082
708	9	2083
709	9	2089
710	9	2090
711	9	2091
712	9	2099
713	9	2100
714	9	2101
715	9	2102
716	9	2103
717	9	2104
718	9	2105
719	9	2107
720	9	2123
721	9	2124
722	9	2125
723	9	2137
724	9	2138
725	9	2139
726	9	2140
727	9	2141
728	9	2142
729	9	2143
730	9	2153
731	9	2204
732	9	2233
733	9	2286
734	9	2289
735	9	2315
736	9	2364
737	9	2392
738	9	2401
739	9	2402
740	9	2403
741	9	2404
742	9	2417
743	9	2418
744	9	2419
745	10	24
746	10	25
747	10	55
748	10	56
749	10	57
750	10	58
751	10	59
752	10	60
753	10	61
754	10	91
755	10	108
756	10	113
757	10	125
758	10	143
759	10	144
760	10	167
761	10	168
762	10	169
763	10	198
764	10	199
765	10	218
766	10	221
767	10	235
768	10	255
769	10	256
770	10	269
771	10	278
772	10	279
773	10	282
774	10	291
775	10	293
776	10	312
777	10	337
778	10	338
779	10	361
780	10	417
781	10	418
782	10	419
783	10	420
784	10	421
785	10	422
786	10	423
787	10	424
788	10	425
789	10	431
790	10	432
791	10	433
792	10	434
793	10	435
794	10	495
795	10	496
796	10	509
797	10	544
798	10	562
799	10	569
800	10	576
801	10	585
802	10	594
803	10	597
804	10	611
805	10	617
806	10	619
807	10	622
808	10	634
809	10	695
810	10	697
811	10	770
812	10	799
813	10	821
814	10	826
815	10	873
816	10	874
817	10	875
818	10	876
819	10	922
820	10	923
821	10	965
822	10	1033
823	10	1080
824	10	1081
825	10	1082
826	10	1090
827	10	1091
828	10	1306
829	10	1307
830	10	1308
831	10	1309
832	10	1310
833	10	1316
834	10	1317
835	10	1318
836	10	1319
837	10	1320
838	10	1321
839	10	1322
840	10	1323
841	10	1324
842	10	1325
843	10	1326
844	10	1327
845	10	1328
846	10	1329
847	10	1330
848	10	1331
849	10	1332
850	10	1333
851	10	1334
852	10	1335
853	10	1336
854	10	1337
855	10	1338
856	10	1339
857	10	1340
858	10	1341
859	10	1342
860	10	1343
861	10	1344
862	10	1345
863	10	1346
864	10	1347
865	10	1348
866	10	1349
867	10	1350
868	10	1351
869	10	1352
870	10	1353
871	10	1354
872	10	1355
873	10	1356
874	10	1357
875	10	1358
876	10	1359
877	10	1360
878	10	1361
879	10	1362
880	10	1511
881	10	1512
882	10	1513
883	10	1514
884	10	1515
885	10	1516
886	10	1517
887	10	1518
888	10	1519
889	10	1520
890	10	1521
891	10	1550
892	10	1551
893	10	1553
894	10	1554
895	10	1561
896	10	1584
897	10	1590
898	10	1598
899	10	1608
900	10	1672
901	10	1673
902	10	1678
903	10	1687
904	10	1695
905	10	1696
906	10	1725
907	10	1737
908	10	1752
909	10	1756
910	10	1805
911	10	1806
912	10	1807
913	10	1808
914	10	1881
915	10	1897
916	10	1911
917	10	1920
918	10	1923
919	10	1927
920	10	1945
921	10	1956
922	10	1987
923	10	1999
924	10	2015
925	10	2033
926	10	2038
927	10	2043
928	10	2045
929	10	2047
930	10	2058
931	10	2068
932	10	2097
933	10	2098
934	10	2120
935	10	2133
936	10	2144
937	10	2145
938	10	2157
939	10	2198
940	10	2225
941	10	2227
942	10	2237
943	10	2238
944	10	2250
945	10	2252
946	10	2253
947	10	2254
948	10	2258
949	10	2298
950	10	2356
951	10	2382
952	10	2393
953	10	2394
954	10	2395
955	10	2396
956	10	2397
957	10	2400
958	11	26
959	11	27
960	11	63
961	11	64
962	11	89
963	11	97
964	11	98
965	11	101
966	11	102
967	11	124
968	11	149
969	11	177
970	11	178
971	11	179
972	11	207
973	11	208
974	11	241
975	11	244
976	11	252
977	11	283
978	11	289
979	11	294
980	11	307
981	11	309
982	11	332
983	11	333
984	11	364
985	11	371
986	11	384
987	11	385
988	11	386
989	11	387
990	11	388
991	11	389
992	11	390
993	11	391
994	11	392
995	11	490
996	11	491
997	11	556
998	11	565
999	11	575
1000	11	642
1001	11	648
1002	11	655
1003	11	657
1004	11	691
1005	11	694
1006	11	698
1007	11	699
1008	11	769
1009	11	792
1010	11	819
1011	11	857
1012	11	885
1013	11	910
1014	11	921
1015	11	924
1016	11	969
1017	11	982
1018	11	1034
1019	11	1050
1020	11	1051
1021	11	1052
1022	11	1053
1023	11	1054
1024	11	1055
1025	11	1094
1026	11	1133
1027	11	1134
1028	11	1135
1029	11	1136
1030	11	1137
1031	11	1138
1032	11	1139
1033	11	1140
1034	11	1141
1035	11	1142
1036	11	1143
1037	11	1144
1038	11	1145
1039	11	1146
1040	11	1147
1041	11	1148
1042	11	1149
1043	11	1150
1044	11	1151
1045	11	1152
1046	11	1153
1047	11	1154
1048	11	1155
1049	11	1156
1050	11	1157
1051	11	1158
1052	11	1159
1053	11	1160
1054	11	1161
1055	11	1162
1056	11	1163
1057	11	1164
1058	11	1165
1059	11	1166
1060	11	1167
1061	11	1168
1062	11	1169
1063	11	1170
1064	11	1171
1065	11	1172
1066	11	1173
1067	11	1174
1068	11	1175
1069	11	1176
1070	11	1177
1071	11	1178
1072	11	1179
1073	11	1180
1074	11	1181
1075	11	1182
1076	11	1183
1077	11	1184
1078	11	1185
1079	11	1186
1080	11	1187
1081	11	1188
1082	11	1528
1083	11	1529
1084	11	1530
1085	11	1531
1086	11	1556
1087	11	1571
1088	11	1604
1089	11	1609
1090	11	1642
1091	11	1649
1092	11	1671
1093	11	1689
1094	11	1712
1095	11	1724
1096	11	1726
1097	11	1727
1098	11	1728
1099	11	1729
1100	11	1742
1101	11	1768
1102	11	1784
1103	11	1792
1104	11	1801
1105	11	1825
1106	11	1826
1107	11	1827
1108	11	1828
1109	11	1867
1110	11	1884
1111	11	1907
1112	11	1917
1113	11	1921
1114	11	1932
1115	11	1944
1116	11	1948
1117	11	1959
1118	11	1967
1119	11	1975
1120	11	1983
1121	11	2001
1122	11	2007
1123	11	2021
1124	11	2023
1125	11	2024
1126	11	2039
1127	11	2048
1128	11	2050
1129	11	2059
1130	11	2060
1131	11	2092
1132	11	2112
1133	11	2113
1134	11	2114
1135	11	2192
1136	11	2299
1137	11	2313
1138	11	2314
1139	11	2372
1140	11	2377
1141	11	2378
1142	11	2381
1143	12	30
1144	12	31
1145	12	41
1146	12	46
1147	12	47
1148	12	96
1149	12	152
1150	12	153
1151	12	156
1152	12	157
1153	12	158
1154	12	195
1155	12	201
1156	12	212
1157	12	214
1158	12	217
1159	12	219
1160	12	228
1161	12	246
1162	12	253
1163	12	254
1164	12	257
1165	12	258
1166	12	268
1167	12	275
1168	12	281
1169	12	284
1170	12	287
1171	12	288
1172	12	426
1173	12	427
1174	12	428
1175	12	455
1176	12	549
1177	12	555
1178	12	558
1179	12	574
1180	12	591
1181	12	595
1182	12	599
1183	12	600
1184	12	609
1185	12	620
1186	12	623
1187	12	632
1188	12	650
1189	12	794
1190	12	804
1191	12	812
1192	12	813
1193	12	845
1194	12	858
1195	12	859
1196	12	881
1197	12	883
1198	12	884
1199	12	956
1200	12	967
1201	12	1043
1202	12	1044
1203	12	1057
1204	12	1061
1205	12	1062
1206	12	1077
1207	12	1121
1208	12	1122
1209	12	1123
1210	12	1124
1211	12	1189
1212	12	1190
1213	12	1193
1214	12	1194
1215	12	1195
1216	12	1196
1217	12	1202
1218	12	1203
1219	12	1206
1220	12	1207
1221	12	1209
1222	12	1210
1223	12	1211
1224	12	1212
1225	12	1213
1226	12	1214
1227	12	1216
1228	12	1217
1229	12	1218
1230	12	1219
1231	12	1220
1232	12	1221
1233	12	1222
1234	12	1223
1235	12	1224
1236	12	1225
1237	12	1226
1238	12	1227
1239	12	1228
1240	12	1229
1241	12	1230
1242	12	1231
1243	12	1232
1244	12	1233
1245	12	1253
1246	12	1254
1247	12	1375
1248	12	1376
1249	12	1377
1250	12	1378
1251	12	1379
1252	12	1380
1253	12	1381
1254	12	1382
1255	12	1383
1256	12	1384
1257	12	1385
1258	12	1386
1259	12	1494
1260	12	1495
1261	12	1499
1262	12	1503
1263	12	1555
1264	12	1564
1265	12	1565
1266	12	1566
1267	12	1567
1268	12	1595
1269	12	1633
1270	12	1643
1271	12	1654
1272	12	1674
1273	12	1677
1274	12	1682
1275	12	1683
1276	12	1684
1277	12	1690
1278	12	1691
1279	12	1698
1280	12	1730
1281	12	1733
1282	12	1741
1283	12	1757
1284	12	1780
1285	12	1817
1286	12	1878
1287	12	1893
1288	12	1894
1289	12	1904
1290	12	1906
1291	12	1913
1292	12	1926
1293	12	1943
1294	12	1953
1295	12	1980
1296	12	1982
1297	12	1985
1298	12	1990
1299	12	2000
1300	12	2002
1301	12	2006
1302	12	2009
1303	12	2010
1304	12	2012
1305	12	2016
1306	12	2018
1307	12	2019
1308	12	2032
1309	12	2051
1310	12	2053
1311	12	2066
1312	12	2067
1313	12	2115
1314	12	2116
1315	12	2117
1316	12	2121
1317	12	2122
1318	12	2136
1319	12	2146
1320	12	2151
1321	12	2152
1322	12	2159
1323	12	2191
1324	12	2210
1325	12	2231
1326	12	2235
1327	12	2241
1328	12	2251
1329	12	2292
1330	12	2346
1331	12	2363
1332	12	2379
1333	12	2380
1334	12	2389
1335	12	2390
1336	12	2398
1337	12	2399
1338	13	32
1339	13	33
1340	13	104
1341	13	154
1342	13	155
1343	13	182
1344	13	189
1345	13	191
1346	13	203
1347	13	210
1348	13	223
1349	13	227
1350	13	231
1351	13	234
1352	13	238
1353	13	239
1354	13	243
1355	13	249
1356	13	251
1357	13	259
1358	13	260
1359	13	270
1360	13	305
1361	13	351
1362	13	352
1363	13	358
1364	13	360
1365	13	370
1366	13	545
1367	13	547
1368	13	551
1369	13	552
1370	13	560
1371	13	570
1372	13	592
1373	13	596
1374	13	607
1375	13	618
1376	13	636
1377	13	647
1378	13	651
1379	13	662
1380	13	664
1381	13	688
1382	13	801
1383	13	823
1384	13	838
1385	13	848
1386	13	907
1387	13	908
1388	13	918
1389	13	954
1390	13	957
1391	13	958
1392	13	971
1393	13	993
1394	13	1026
1395	13	1042
1396	13	1060
1397	13	1071
1398	13	1072
1399	13	1073
1400	13	1074
1401	13	1075
1402	13	1096
1403	13	1246
1404	13	1247
1405	13	1248
1406	13	1249
1407	13	1504
1408	13	1510
1409	13	1545
1410	13	1563
1411	13	1589
1412	13	1594
1413	13	1599
1414	13	1632
1415	13	1648
1416	13	1651
1417	13	1652
1418	13	1653
1419	13	1655
1420	13	1660
1421	13	1734
1422	13	1762
1423	13	1767
1424	13	1779
1425	13	1858
1426	13	1859
1427	13	1902
1428	13	1909
1429	13	1915
1430	13	1922
1431	13	1928
1432	13	1929
1433	13	1933
1434	13	1937
1435	13	1951
1436	13	1952
1437	13	1954
1438	13	1955
1439	13	1957
1440	13	1981
1441	13	1988
1442	13	1992
1443	13	1995
1444	13	1997
1445	13	2008
1446	13	2011
1447	13	2014
1448	13	2017
1449	13	2020
1450	13	2042
1451	13	2049
1452	13	2056
1453	13	2148
1454	13	2149
1455	13	2155
1456	13	2163
1457	13	2176
1458	13	2193
1459	13	2234
1460	13	2243
1461	13	2266
1462	13	2273
1463	13	2373
1464	13	2374
1465	13	2375
1466	13	2376
1467	13	2383
1468	13	2386
1469	13	2387
1470	14	34
1471	14	62
1472	14	83
1473	14	84
1474	14	85
1475	14	86
1476	14	90
1477	14	99
1478	14	100
1479	14	103
1480	14	122
1481	14	202
1482	14	205
1483	14	211
1484	14	213
1485	14	242
1486	14	262
1487	14	272
1488	14	303
1489	14	304
1490	14	306
1491	14	308
1492	14	326
1493	14	330
1494	14	340
1495	14	341
1496	14	342
1497	14	343
1498	14	346
1499	14	347
1500	14	349
1501	14	350
1502	14	353
1503	14	366
1504	14	429
1505	14	467
1506	14	468
1507	14	469
1508	14	470
1509	14	471
1510	14	472
1511	14	473
1512	14	474
1513	14	475
1514	14	476
1515	14	477
1516	14	541
1517	14	559
1518	14	612
1519	14	637
1520	14	669
1521	14	670
1522	14	672
1523	14	673
1524	14	674
1525	14	680
1526	14	681
1527	14	682
1528	14	683
1529	14	724
1530	14	725
1531	14	726
1532	14	727
1533	14	788
1534	14	805
1535	14	806
1536	14	807
1537	14	808
1538	14	809
1539	14	810
1540	14	825
1541	14	827
1542	14	856
1543	14	869
1544	14	870
1545	14	871
1546	14	909
1547	14	919
1548	14	936
1549	14	960
1550	14	973
1551	14	974
1552	14	975
1553	14	976
1554	14	977
1555	14	994
1556	14	1036
1557	14	1086
1558	14	1087
1559	14	1092
1560	14	1098
1561	14	1099
1562	14	1101
1563	14	1104
1564	14	1105
1565	14	1114
1566	14	1116
1567	14	1117
1568	14	1118
1569	14	1119
1570	14	1120
1571	14	1234
1572	14	1235
1573	14	1236
1574	14	1237
1575	14	1238
1576	14	1239
1577	14	1240
1578	14	1241
1579	14	1242
1580	14	1243
1581	14	1244
1582	14	1245
1583	14	1311
1584	14	1312
1585	14	1313
1586	14	1314
1587	14	1315
1588	14	1421
1589	14	1422
1590	14	1423
1591	14	1424
1592	14	1425
1593	14	1426
1594	14	1427
1595	14	1428
1596	14	1429
1597	14	1430
1598	14	1431
1599	14	1432
1600	14	1433
1601	14	1434
1602	14	1435
1603	14	1436
1604	14	1437
1605	14	1438
1606	14	1439
1607	14	1440
1608	14	1505
1609	14	1523
1610	14	1524
1611	14	1525
1612	14	1526
1613	14	1527
1614	14	1552
1615	14	1569
1616	14	1591
1617	14	1592
1618	14	1610
1619	14	1611
1620	14	1615
1621	14	1625
1622	14	1626
1623	14	1628
1624	14	1629
1625	14	1676
1626	14	1701
1627	14	1702
1628	14	1703
1629	14	1704
1630	14	1705
1631	14	1706
1632	14	1707
1633	14	1708
1634	14	1747
1635	14	1751
1636	14	1761
1637	14	1765
1638	14	1766
1639	14	1771
1640	14	1772
1641	14	1775
1642	14	1776
1643	14	1798
1644	14	1838
1645	14	1839
1646	14	1848
1647	14	1857
1648	14	1888
1649	14	1889
1650	14	1898
1651	14	1899
1652	14	1900
1653	14	1901
1654	14	1903
1655	14	1930
1656	14	1931
1657	14	1949
1658	14	1950
1659	14	1964
1660	14	2025
1661	14	2096
1662	14	2162
1663	14	2185
1664	14	2202
1665	14	2207
1666	14	2208
1667	14	2211
1668	14	2217
1669	14	2218
1670	14	2242
1671	14	2265
1672	14	2268
1673	14	2269
1674	14	2270
1675	14	2271
1676	14	2293
1677	14	2347
1678	15	111
1679	15	112
1680	15	180
1681	15	181
1682	15	190
1683	15	197
1684	15	204
1685	15	220
1686	15	229
1687	15	240
1688	15	245
1689	15	264
1690	15	267
1691	15	273
1692	15	280
1693	15	339
1694	15	354
1695	15	355
1696	15	357
1697	15	363
1698	15	377
1699	15	378
1700	15	379
1701	15	380
1702	15	381
1703	15	404
1704	15	464
1705	15	465
1706	15	530
1707	15	542
1708	15	543
1709	15	548
1710	15	561
1711	15	589
1712	15	626
1713	15	633
1714	15	635
1715	15	644
1716	15	652
1717	15	656
1718	15	687
1719	15	696
1720	15	700
1721	15	704
1722	15	705
1723	15	706
1724	15	768
1725	15	822
1726	15	836
1727	15	886
1728	15	938
1729	15	939
1730	15	940
1731	15	941
1732	15	942
1733	15	961
1734	15	970
1735	15	996
1736	15	1008
1737	15	1012
1738	15	1022
1739	15	1023
1740	15	1046
1741	15	1048
1742	15	1059
1743	15	1066
1744	15	1070
1745	15	1079
1746	15	1083
1747	15	1085
1748	15	1127
1749	15	1128
1750	15	1129
1751	15	1130
1752	15	1191
1753	15	1192
1754	15	1256
1755	15	1257
1756	15	1387
1757	15	1388
1758	15	1389
1759	15	1390
1760	15	1391
1761	15	1392
1762	15	1393
1763	15	1394
1764	15	1395
1765	15	1396
1766	15	1397
1767	15	1398
1768	15	1399
1769	15	1400
1770	15	1401
1771	15	1402
1772	15	1403
1773	15	1404
1774	15	1405
1775	15	1406
1776	15	1407
1777	15	1408
1778	15	1409
1779	15	1410
1780	15	1411
1781	15	1412
1782	15	1413
1783	15	1414
1784	15	1415
1785	15	1416
1786	15	1417
1787	15	1418
1788	15	1419
1789	15	1497
1790	15	1498
1791	15	1500
1792	15	1508
1793	15	1532
1794	15	1533
1795	15	1534
1796	15	1535
1797	15	1536
1798	15	1537
1799	15	1538
1800	15	1539
1801	15	1540
1802	15	1541
1803	15	1542
1804	15	1543
1805	15	1544
1806	15	1562
1807	15	1606
1808	15	1622
1809	15	1630
1810	15	1656
1811	15	1658
1812	15	1659
1813	15	1663
1814	15	1681
1815	15	1743
1816	15	1754
1817	15	1759
1818	15	1802
1819	15	1803
1820	15	1850
1821	15	1851
1822	15	1852
1823	15	1891
1824	15	1918
1825	15	1946
1826	15	1962
1827	15	1966
1828	15	1971
1829	15	1972
1830	15	1973
1831	15	1977
1832	15	1984
1833	15	2004
1834	15	2005
1835	15	2030
1836	15	2036
1837	15	2046
1838	15	2052
1839	15	2064
1840	15	2065
1841	15	2070
1842	15	2071
1843	15	2075
1844	15	2080
1845	15	2081
1846	15	2108
1847	15	2109
1848	15	2161
1849	15	2203
1850	15	2264
1851	15	2279
1852	15	2320
1853	15	2337
1854	15	2338
1855	15	2339
1856	15	2340
1857	15	2341
1858	15	2342
1859	15	2384
1860	15	2405
1861	15	2406
1862	15	2407
1863	15	2408
1864	15	2409
1865	15	2410
1866	15	2411
1867	16	758
1868	16	759
1869	16	760
1870	16	761
1871	16	762
1872	16	763
1873	16	764
1874	16	782
1875	16	783
1876	16	784
1877	16	785
1878	16	786
1879	16	787
1880	16	816
1881	16	817
\.


--
-- TOC entry 3847 (class 0 OID 466714)
-- Dependencies: 257
-- Data for Name: asset_transfers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_transfers (id, receiving_station_id, notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
6	554		211	1	3	2026-07-25 07:32:40.681162
7	61		212	1	3	2026-07-25 07:32:40.681162
8	59		213	1	3	2026-07-25 07:32:40.681162
9	567		214	1	3	2026-07-25 07:32:40.681162
10	393		215	1	3	2026-07-25 07:32:40.681162
11	1034		216	1	3	2026-07-25 07:32:40.681162
12	345		217	1	3	2026-07-25 07:32:40.681162
13	29		218	1	3	2026-07-25 07:32:40.681162
14	196		219	1	3	2026-07-25 07:32:40.681162
15	506		220	1	3	2026-07-25 07:32:40.681162
16	363		221	1	3	2026-07-25 07:32:40.681162
\.


--
-- TOC entry 3802 (class 0 OID 466403)
-- Dependencies: 212
-- Data for Name: asset_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_types (id, name) FROM stdin;
1	Laptop
2	Cellphone
3	Desktop
4	Printer
5	Scanner
56	Cabinet
57	Camera
58	Cash Box
59	Chair
60	Cooler Box
61	Desk
62	Fan
63	Fire Extinguisher
64	Generator
65	Grass-Cutter
66	Heater
67	Height Body
68	Jerry Can
69	Microwave
70	Money-counter
71	Monitor
72	Motor-Cycle
73	Motor-trailer
74	Network Switch
75	Notice Board
76	Pedastal
77	Projector
78	Projector-screen
79	Refrigerator
80	Router
81	Safe
82	Scale
83	Shredder
84	Stove
85	Suggestion Box
86	Table
87	Tablet
88	Tent
89	Trunk
90	Vehicle
91	Water Dispenser
92	Wheelbarrow
93	X-Ray Machine
\.


--
-- TOC entry 3855 (class 0 OID 466822)
-- Dependencies: 265
-- Data for Name: asset_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.asset_verifications (id, registered_asset_id, verification_type_id, verified_condition_type_id, event_notes, event_register_id, event_station_id, event_admin_id, stamp) FROM stdin;
\.


--
-- TOC entry 3804 (class 0 OID 466412)
-- Dependencies: 214
-- Data for Name: brand_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brand_types (id, name) FROM stdin;
1	HP
2	Samsung
3	Lenovo
4	Dell
5	Honor
6	Apple
9	Unknown
10	Itel
12	LG
13	Honda
14	Epson
15	Hisense
16	Toyota
17	Ford
18	LTE
\.


--
-- TOC entry 3812 (class 0 OID 466448)
-- Dependencies: 222
-- Data for Name: condition_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.condition_types (id, name) FROM stdin;
1	New
2	Good
4	Poor
5	Damaged
6	Other
3	Fair
8	Old
\.


--
-- TOC entry 3824 (class 0 OID 466507)
-- Dependencies: 234
-- Data for Name: disposal_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.disposal_types (id, name) FROM stdin;
1	Sale
2	Donation
3	Auction
4	Incidental
5	Other
6	Written Off/Scrapped
\.


--
-- TOC entry 3814 (class 0 OID 466457)
-- Dependencies: 224
-- Data for Name: evaluation_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.evaluation_types (id, name) FROM stdin;
1	Depreciated
4	Impairment
5	Other
2	Market Value Change
3	Value Correction
\.


--
-- TOC entry 3869 (class 0 OID 467065)
-- Dependencies: 279
-- Data for Name: event_approvals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_approvals (id, event_register_id, approval_type_id, approval_notes, event_admin_id, stamp) FROM stdin;
1207	237	10	 	21020	2026-07-25 08:38:14.351276
43	25	40		3	2026-07-25 08:22:44.731106
44	26	40		3	2026-07-25 08:22:44.731106
45	27	40		3	2026-07-25 08:22:44.731106
46	28	40		3	2026-07-25 08:22:44.731106
47	29	40		3	2026-07-25 08:22:44.731106
48	30	40		3	2026-07-25 08:22:44.731106
49	31	40		3	2026-07-25 08:22:44.731106
50	32	40		3	2026-07-25 08:22:44.731106
51	33	40		3	2026-07-25 08:22:44.731106
52	34	40		3	2026-07-25 08:22:44.731106
53	35	40		3	2026-07-25 08:22:44.731106
54	36	40		3	2026-07-25 08:22:44.731106
55	37	40		3	2026-07-25 08:22:44.731106
56	38	40		3	2026-07-25 08:22:44.731106
57	39	40		3	2026-07-25 08:22:44.731106
58	40	40		3	2026-07-25 08:22:44.731106
59	41	40		3	2026-07-25 08:22:44.731106
60	42	40		3	2026-07-25 08:22:44.731106
61	43	40		3	2026-07-25 08:22:44.731106
62	44	40		3	2026-07-25 08:22:44.731106
63	45	40		3	2026-07-25 08:22:44.731106
64	46	40		3	2026-07-25 08:22:44.731106
65	47	40		3	2026-07-25 08:22:44.731106
66	48	40		3	2026-07-25 08:22:44.731106
67	49	40		3	2026-07-25 08:22:44.731106
68	50	40		3	2026-07-25 08:22:44.731106
69	51	40		3	2026-07-25 08:22:44.731106
70	52	40		3	2026-07-25 08:22:44.731106
71	53	40		3	2026-07-25 08:22:44.731106
72	54	40		3	2026-07-25 08:22:44.731106
73	55	40		3	2026-07-25 08:22:44.731106
74	56	40		3	2026-07-25 08:22:44.731106
75	57	40		3	2026-07-25 08:22:44.731106
76	58	40		3	2026-07-25 08:22:44.731106
77	59	40		3	2026-07-25 08:22:44.731106
78	60	40		3	2026-07-25 08:22:44.731106
79	61	40		3	2026-07-25 08:22:44.731106
80	62	40		3	2026-07-25 08:22:44.731106
81	63	40		3	2026-07-25 08:22:44.731106
82	64	40		3	2026-07-25 08:22:44.731106
83	65	40		3	2026-07-25 08:22:44.731106
84	66	40		3	2026-07-25 08:22:44.731106
85	67	40		3	2026-07-25 08:22:44.731106
86	68	40		3	2026-07-25 08:22:44.731106
87	69	40		3	2026-07-25 08:22:44.731106
88	70	40		3	2026-07-25 08:22:44.731106
89	71	40		3	2026-07-25 08:22:44.731106
90	72	40		3	2026-07-25 08:22:44.731106
91	73	40		3	2026-07-25 08:22:44.731106
92	74	40		3	2026-07-25 08:22:44.731106
93	75	40		3	2026-07-25 08:22:44.731106
94	76	40		3	2026-07-25 08:22:44.731106
95	77	40		3	2026-07-25 08:22:44.731106
96	78	40		3	2026-07-25 08:22:44.731106
97	79	40		3	2026-07-25 08:22:44.731106
98	80	40		3	2026-07-25 08:22:44.731106
99	81	40		3	2026-07-25 08:22:44.731106
100	82	40		3	2026-07-25 08:22:44.731106
101	83	40		3	2026-07-25 08:22:44.731106
102	84	40		3	2026-07-25 08:22:44.731106
103	85	40		3	2026-07-25 08:22:44.731106
104	86	40		3	2026-07-25 08:22:44.731106
105	87	40		3	2026-07-25 08:22:44.731106
106	88	40		3	2026-07-25 08:22:44.731106
107	89	40		3	2026-07-25 08:22:44.731106
108	90	40		3	2026-07-25 08:22:44.731106
109	91	40		3	2026-07-25 08:22:44.731106
110	92	40		3	2026-07-25 08:22:44.731106
111	93	40		3	2026-07-25 08:22:44.731106
112	94	40		3	2026-07-25 08:22:44.731106
113	95	40		3	2026-07-25 08:22:44.731106
114	96	40		3	2026-07-25 08:22:44.731106
115	97	40		3	2026-07-25 08:22:44.731106
116	98	40		3	2026-07-25 08:22:44.731106
117	99	40		3	2026-07-25 08:22:44.731106
118	100	40		3	2026-07-25 08:22:44.731106
119	101	40		3	2026-07-25 08:22:44.731106
120	102	40		3	2026-07-25 08:22:44.731106
121	103	40		3	2026-07-25 08:22:44.731106
122	104	40		3	2026-07-25 08:22:44.731106
123	105	40		3	2026-07-25 08:22:44.731106
124	106	40		3	2026-07-25 08:22:44.731106
125	107	40		3	2026-07-25 08:22:44.731106
126	108	40		3	2026-07-25 08:22:44.731106
127	109	40		3	2026-07-25 08:22:44.731106
128	110	40		3	2026-07-25 08:22:44.731106
129	111	40		3	2026-07-25 08:22:44.731106
130	112	40		3	2026-07-25 08:22:44.731106
131	113	40		3	2026-07-25 08:22:44.731106
132	114	40		3	2026-07-25 08:22:44.731106
133	115	40		3	2026-07-25 08:22:44.731106
134	116	40		3	2026-07-25 08:22:44.731106
135	117	40		3	2026-07-25 08:22:44.731106
136	118	40		3	2026-07-25 08:22:44.731106
137	119	40		3	2026-07-25 08:22:44.731106
138	120	40		3	2026-07-25 08:22:44.731106
139	121	40		3	2026-07-25 08:22:44.731106
140	122	40		3	2026-07-25 08:22:44.731106
141	123	40		3	2026-07-25 08:22:44.731106
142	124	40		3	2026-07-25 08:22:44.731106
143	125	40		3	2026-07-25 08:22:44.731106
144	126	40		3	2026-07-25 08:22:44.731106
145	127	40		3	2026-07-25 08:22:44.731106
146	128	40		3	2026-07-25 08:22:44.731106
147	129	40		3	2026-07-25 08:22:44.731106
148	130	40		3	2026-07-25 08:22:44.731106
149	131	40		3	2026-07-25 08:22:44.731106
150	132	40		3	2026-07-25 08:22:44.731106
151	133	40		3	2026-07-25 08:22:44.731106
152	134	40		3	2026-07-25 08:22:44.731106
153	135	40		3	2026-07-25 08:22:44.731106
154	136	40		3	2026-07-25 08:22:44.731106
155	137	40		3	2026-07-25 08:22:44.731106
156	138	40		3	2026-07-25 08:22:44.731106
157	139	40		3	2026-07-25 08:22:44.731106
158	140	40		3	2026-07-25 08:22:44.731106
159	141	40		3	2026-07-25 08:22:44.731106
160	142	40		3	2026-07-25 08:22:44.731106
161	143	40		3	2026-07-25 08:22:44.731106
162	144	40		3	2026-07-25 08:22:44.731106
163	145	40		3	2026-07-25 08:22:44.731106
164	146	40		3	2026-07-25 08:22:44.731106
165	147	40		3	2026-07-25 08:22:44.731106
166	148	40		3	2026-07-25 08:22:44.731106
167	149	40		3	2026-07-25 08:22:44.731106
168	150	40		3	2026-07-25 08:22:44.731106
169	151	40		3	2026-07-25 08:22:44.731106
170	152	40		3	2026-07-25 08:22:44.731106
171	153	40		3	2026-07-25 08:22:44.731106
172	154	40		3	2026-07-25 08:22:44.731106
173	155	40		3	2026-07-25 08:22:44.731106
174	156	40		3	2026-07-25 08:22:44.731106
175	157	40		3	2026-07-25 08:22:44.731106
176	158	40		3	2026-07-25 08:22:44.731106
177	159	40		3	2026-07-25 08:22:44.731106
178	160	40		3	2026-07-25 08:22:44.731106
179	161	40		3	2026-07-25 08:22:44.731106
180	162	40		3	2026-07-25 08:22:44.731106
181	163	40		3	2026-07-25 08:22:44.731106
182	164	40		3	2026-07-25 08:22:44.731106
183	165	40		3	2026-07-25 08:22:44.731106
184	166	40		3	2026-07-25 08:22:44.731106
185	167	40		3	2026-07-25 08:22:44.731106
186	168	40		3	2026-07-25 08:22:44.731106
187	169	40		3	2026-07-25 08:22:44.731106
188	170	40		3	2026-07-25 08:22:44.731106
189	171	40		3	2026-07-25 08:22:44.731106
190	172	40		3	2026-07-25 08:22:44.731106
191	173	40		3	2026-07-25 08:22:44.731106
192	174	40		3	2026-07-25 08:22:44.731106
193	175	40		3	2026-07-25 08:22:44.731106
194	176	40		3	2026-07-25 08:22:44.731106
195	177	40		3	2026-07-25 08:22:44.731106
196	178	40		3	2026-07-25 08:22:44.731106
197	179	40		3	2026-07-25 08:22:44.731106
198	180	40		3	2026-07-25 08:22:44.731106
199	181	40		3	2026-07-25 08:22:44.731106
200	182	40		3	2026-07-25 08:22:44.731106
201	183	40		3	2026-07-25 08:22:44.731106
202	184	40		3	2026-07-25 08:22:44.731106
203	185	40		3	2026-07-25 08:22:44.731106
204	186	40		3	2026-07-25 08:22:44.731106
205	187	40		3	2026-07-25 08:22:44.731106
206	188	40		3	2026-07-25 08:22:44.731106
207	189	40		3	2026-07-25 08:22:44.731106
208	190	40		3	2026-07-25 08:22:44.731106
209	191	40		3	2026-07-25 08:22:44.731106
210	192	40		3	2026-07-25 08:22:44.731106
211	193	40		3	2026-07-25 08:22:44.731106
212	194	40		3	2026-07-25 08:22:44.731106
213	195	40		3	2026-07-25 08:22:44.731106
214	196	40		3	2026-07-25 08:22:44.731106
215	197	40		3	2026-07-25 08:22:44.731106
216	198	40		3	2026-07-25 08:22:44.731106
217	199	40		3	2026-07-25 08:22:44.731106
218	200	40		3	2026-07-25 08:22:44.731106
219	201	40		3	2026-07-25 08:22:44.731106
220	202	40		3	2026-07-25 08:22:44.731106
221	203	40		3	2026-07-25 08:22:44.731106
222	204	40		3	2026-07-25 08:22:44.731106
223	205	40		3	2026-07-25 08:22:44.731106
224	206	40		3	2026-07-25 08:22:44.731106
225	207	40		3	2026-07-25 08:22:44.731106
226	208	40		3	2026-07-25 08:22:44.731106
227	209	40		3	2026-07-25 08:22:44.731106
228	210	40		3	2026-07-25 08:22:44.731106
229	211	40		3	2026-07-25 08:22:44.731106
230	212	40		3	2026-07-25 08:22:44.731106
231	213	40		3	2026-07-25 08:22:44.731106
232	214	40		3	2026-07-25 08:22:44.731106
233	215	40		3	2026-07-25 08:22:44.731106
234	216	40		3	2026-07-25 08:22:44.731106
235	217	40		3	2026-07-25 08:22:44.731106
236	218	40		3	2026-07-25 08:22:44.731106
237	219	40		3	2026-07-25 08:22:44.731106
238	220	40		3	2026-07-25 08:22:44.731106
239	221	40		3	2026-07-25 08:22:44.731106
240	222	40		3	2026-07-25 08:22:44.731106
241	223	40		3	2026-07-25 08:22:44.731106
242	224	40		3	2026-07-25 08:22:44.731106
243	225	40		3	2026-07-25 08:22:44.731106
244	226	40		3	2026-07-25 08:22:44.731106
245	227	40		3	2026-07-25 08:22:44.731106
246	228	40		3	2026-07-25 08:22:44.731106
247	229	40		3	2026-07-25 08:22:44.731106
248	230	40		3	2026-07-25 08:22:44.731106
249	231	40		3	2026-07-25 08:22:44.731106
250	232	40		3	2026-07-25 08:22:44.731106
251	233	40		3	2026-07-25 08:22:44.731106
252	234	40		3	2026-07-25 08:22:44.731106
253	235	40		3	2026-07-25 08:22:44.731106
254	236	40		3	2026-07-25 08:22:44.731106
255	237	40		3	2026-07-25 08:22:44.731106
256	238	40		3	2026-07-25 08:22:44.731106
257	239	40		3	2026-07-25 08:22:44.731106
258	240	40		3	2026-07-25 08:22:44.731106
259	241	40		3	2026-07-25 08:22:44.731106
260	242	40		3	2026-07-25 08:22:44.731106
261	243	40		3	2026-07-25 08:22:44.731106
262	244	40		3	2026-07-25 08:22:44.731106
263	245	40		3	2026-07-25 08:22:44.731106
264	246	40		3	2026-07-25 08:22:44.731106
265	247	40		3	2026-07-25 08:22:44.731106
266	248	40		3	2026-07-25 08:22:44.731106
267	249	40		3	2026-07-25 08:22:44.731106
268	250	40		3	2026-07-25 08:22:44.731106
269	251	40		3	2026-07-25 08:22:44.731106
270	252	40		3	2026-07-25 08:22:44.731106
271	253	40		3	2026-07-25 08:22:44.731106
272	254	40		3	2026-07-25 08:22:44.731106
273	255	40		3	2026-07-25 08:22:44.731106
274	256	40		3	2026-07-25 08:22:44.731106
275	257	40		3	2026-07-25 08:22:44.731106
276	258	40		3	2026-07-25 08:22:44.731106
277	259	40		3	2026-07-25 08:22:44.731106
278	260	40		3	2026-07-25 08:22:44.731106
279	261	40		3	2026-07-25 08:22:44.731106
280	262	40		3	2026-07-25 08:22:44.731106
281	263	40		3	2026-07-25 08:22:44.731106
282	264	40		3	2026-07-25 08:22:44.731106
283	265	40		3	2026-07-25 08:22:44.731106
284	266	40		3	2026-07-25 08:22:44.731106
285	267	40		3	2026-07-25 08:22:44.731106
286	268	40		3	2026-07-25 08:22:44.731106
287	269	40		3	2026-07-25 08:22:44.731106
288	270	40		3	2026-07-25 08:22:44.731106
289	271	40		3	2026-07-25 08:22:44.731106
290	272	40		3	2026-07-25 08:22:44.731106
291	273	40		3	2026-07-25 08:22:44.731106
292	274	40		3	2026-07-25 08:22:44.731106
293	275	40		3	2026-07-25 08:22:44.731106
294	276	40		3	2026-07-25 08:22:44.731106
295	277	40		3	2026-07-25 08:22:44.731106
296	278	40		3	2026-07-25 08:22:44.731106
297	279	40		3	2026-07-25 08:22:44.731106
298	280	40		3	2026-07-25 08:22:44.731106
299	281	40		3	2026-07-25 08:22:44.731106
300	282	40		3	2026-07-25 08:22:44.731106
301	283	40		3	2026-07-25 08:22:44.731106
302	284	40		3	2026-07-25 08:22:44.731106
303	285	40		3	2026-07-25 08:22:44.731106
304	286	40		3	2026-07-25 08:22:44.731106
305	287	40		3	2026-07-25 08:22:44.731106
306	288	40		3	2026-07-25 08:22:44.731106
307	289	40		3	2026-07-25 08:22:44.731106
308	290	40		3	2026-07-25 08:22:44.731106
309	291	40		3	2026-07-25 08:22:44.731106
310	292	40		3	2026-07-25 08:22:44.731106
311	293	40		3	2026-07-25 08:22:44.731106
312	294	40		3	2026-07-25 08:22:44.731106
313	295	40		3	2026-07-25 08:22:44.731106
314	296	40		3	2026-07-25 08:22:44.731106
315	297	40		3	2026-07-25 08:22:44.731106
316	298	40		3	2026-07-25 08:22:44.731106
317	299	40		3	2026-07-25 08:22:44.731106
318	300	40		3	2026-07-25 08:22:44.731106
319	301	40		3	2026-07-25 08:22:44.731106
320	302	40		3	2026-07-25 08:22:44.731106
321	303	40		3	2026-07-25 08:22:44.731106
322	304	40		3	2026-07-25 08:22:44.731106
323	305	40		3	2026-07-25 08:22:44.731106
324	306	40		3	2026-07-25 08:22:44.731106
325	307	40		3	2026-07-25 08:22:44.731106
326	308	40		3	2026-07-25 08:22:44.731106
327	309	40		3	2026-07-25 08:22:44.731106
328	310	40		3	2026-07-25 08:22:44.731106
329	311	40		3	2026-07-25 08:22:44.731106
330	312	40		3	2026-07-25 08:22:44.731106
331	313	40		3	2026-07-25 08:22:44.731106
332	314	40		3	2026-07-25 08:22:44.731106
333	315	40		3	2026-07-25 08:22:44.731106
334	316	40		3	2026-07-25 08:22:44.731106
335	317	40		3	2026-07-25 08:22:44.731106
336	318	40		3	2026-07-25 08:22:44.731106
337	319	40		3	2026-07-25 08:22:44.731106
338	320	40		3	2026-07-25 08:22:44.731106
339	321	40		3	2026-07-25 08:22:44.731106
340	322	40		3	2026-07-25 08:22:44.731106
341	323	40		3	2026-07-25 08:22:44.731106
342	324	40		3	2026-07-25 08:22:44.731106
343	325	40		3	2026-07-25 08:22:44.731106
344	326	40		3	2026-07-25 08:22:44.731106
345	327	40		3	2026-07-25 08:22:44.731106
346	328	40		3	2026-07-25 08:22:44.731106
347	329	40		3	2026-07-25 08:22:44.731106
348	330	40		3	2026-07-25 08:22:44.731106
349	331	40		3	2026-07-25 08:22:44.731106
350	332	40		3	2026-07-25 08:22:44.731106
351	333	40		3	2026-07-25 08:22:44.731106
352	334	40		3	2026-07-25 08:22:44.731106
353	335	40		3	2026-07-25 08:22:44.731106
354	336	40		3	2026-07-25 08:22:44.731106
355	337	40		3	2026-07-25 08:22:44.731106
356	338	40		3	2026-07-25 08:22:44.731106
357	339	40		3	2026-07-25 08:22:44.731106
358	340	40		3	2026-07-25 08:22:44.731106
359	341	40		3	2026-07-25 08:22:44.731106
360	342	40		3	2026-07-25 08:22:44.731106
361	343	40		3	2026-07-25 08:22:44.731106
362	344	40		3	2026-07-25 08:22:44.731106
363	345	40		3	2026-07-25 08:22:44.731106
364	346	40		3	2026-07-25 08:22:44.731106
365	347	40		3	2026-07-25 08:22:44.731106
366	348	40		3	2026-07-25 08:22:44.731106
367	349	40		3	2026-07-25 08:22:44.731106
368	350	40		3	2026-07-25 08:22:44.731106
369	351	40		3	2026-07-25 08:22:44.731106
370	352	40		3	2026-07-25 08:22:44.731106
371	353	40		3	2026-07-25 08:22:44.731106
372	354	40		3	2026-07-25 08:22:44.731106
373	355	40		3	2026-07-25 08:22:44.731106
374	356	40		3	2026-07-25 08:22:44.731106
375	357	40		3	2026-07-25 08:22:44.731106
376	358	40		3	2026-07-25 08:22:44.731106
377	359	40		3	2026-07-25 08:22:44.731106
378	360	40		3	2026-07-25 08:22:44.731106
379	361	40		3	2026-07-25 08:22:44.731106
380	362	40		3	2026-07-25 08:22:44.731106
381	363	40		3	2026-07-25 08:22:44.731106
382	364	40		3	2026-07-25 08:22:44.731106
383	365	40		3	2026-07-25 08:22:44.731106
384	366	40		3	2026-07-25 08:22:44.731106
385	367	40		3	2026-07-25 08:22:44.731106
386	368	40		3	2026-07-25 08:22:44.731106
387	369	40		3	2026-07-25 08:22:44.731106
388	370	40		3	2026-07-25 08:22:44.731106
389	371	40		3	2026-07-25 08:22:44.731106
390	372	40		3	2026-07-25 08:22:44.731106
391	373	40		3	2026-07-25 08:22:44.731106
392	374	40		3	2026-07-25 08:22:44.731106
393	375	40		3	2026-07-25 08:22:44.731106
394	376	40		3	2026-07-25 08:22:44.731106
395	377	40		3	2026-07-25 08:22:44.731106
396	378	40		3	2026-07-25 08:22:44.731106
397	379	40		3	2026-07-25 08:22:44.731106
398	380	40		3	2026-07-25 08:22:44.731106
399	381	40		3	2026-07-25 08:22:44.731106
400	382	40		3	2026-07-25 08:22:44.731106
401	383	40		3	2026-07-25 08:22:44.731106
402	384	40		3	2026-07-25 08:22:44.731106
403	385	40		3	2026-07-25 08:22:44.731106
404	386	40		3	2026-07-25 08:22:44.731106
405	387	40		3	2026-07-25 08:22:44.731106
406	388	40		3	2026-07-25 08:22:44.731106
407	389	40		3	2026-07-25 08:22:44.731106
408	390	40		3	2026-07-25 08:22:44.731106
409	391	40		3	2026-07-25 08:22:44.731106
410	392	40		3	2026-07-25 08:22:44.731106
411	393	40		3	2026-07-25 08:22:44.731106
412	394	40		3	2026-07-25 08:22:44.731106
413	395	40		3	2026-07-25 08:22:44.731106
414	396	40		3	2026-07-25 08:22:44.731106
415	397	40		3	2026-07-25 08:22:44.731106
416	398	40		3	2026-07-25 08:22:44.731106
417	399	40		3	2026-07-25 08:22:44.731106
418	400	40		3	2026-07-25 08:22:44.731106
419	401	40		3	2026-07-25 08:22:44.731106
420	402	40		3	2026-07-25 08:22:44.731106
421	403	40		3	2026-07-25 08:22:44.731106
422	404	40		3	2026-07-25 08:22:44.731106
423	405	40		3	2026-07-25 08:22:44.731106
424	406	40		3	2026-07-25 08:22:44.731106
425	407	40		3	2026-07-25 08:22:44.731106
426	408	40		3	2026-07-25 08:22:44.731106
427	409	40		3	2026-07-25 08:22:44.731106
428	410	40		3	2026-07-25 08:22:44.731106
429	411	40		3	2026-07-25 08:22:44.731106
430	412	40		3	2026-07-25 08:22:44.731106
431	413	40		3	2026-07-25 08:22:44.731106
432	414	40		3	2026-07-25 08:22:44.731106
433	415	40		3	2026-07-25 08:22:44.731106
434	416	40		3	2026-07-25 08:22:44.731106
435	417	40		3	2026-07-25 08:22:44.731106
436	418	40		3	2026-07-25 08:22:44.731106
437	419	40		3	2026-07-25 08:22:44.731106
438	420	40		3	2026-07-25 08:22:44.731106
439	421	40		3	2026-07-25 08:22:44.731106
440	422	40		3	2026-07-25 08:22:44.731106
441	423	40		3	2026-07-25 08:22:44.731106
442	424	40		3	2026-07-25 08:22:44.731106
443	425	40		3	2026-07-25 08:22:44.731106
444	426	40		3	2026-07-25 08:22:44.731106
445	427	40		3	2026-07-25 08:22:44.731106
446	428	40		3	2026-07-25 08:22:44.731106
447	429	40		3	2026-07-25 08:22:44.731106
448	430	40		3	2026-07-25 08:22:44.731106
449	431	40		3	2026-07-25 08:22:44.731106
450	432	40		3	2026-07-25 08:22:44.731106
451	433	40		3	2026-07-25 08:22:44.731106
452	434	40		3	2026-07-25 08:22:44.731106
453	435	40		3	2026-07-25 08:22:44.731106
454	436	40		3	2026-07-25 08:22:44.731106
455	437	40		3	2026-07-25 08:22:44.731106
456	438	40		3	2026-07-25 08:22:44.731106
457	439	40		3	2026-07-25 08:22:44.731106
458	440	40		3	2026-07-25 08:22:44.731106
459	441	40		3	2026-07-25 08:22:44.731106
460	442	40		3	2026-07-25 08:22:44.731106
461	443	40		3	2026-07-25 08:22:44.731106
462	444	40		3	2026-07-25 08:22:44.731106
463	445	40		3	2026-07-25 08:22:44.731106
464	446	40		3	2026-07-25 08:22:44.731106
465	447	40		3	2026-07-25 08:22:44.731106
466	448	40		3	2026-07-25 08:22:44.731106
467	449	40		3	2026-07-25 08:22:44.731106
468	450	40		3	2026-07-25 08:22:44.731106
469	451	40		3	2026-07-25 08:22:44.731106
470	452	40		3	2026-07-25 08:22:44.731106
471	453	40		3	2026-07-25 08:22:44.731106
472	454	40		3	2026-07-25 08:22:44.731106
473	455	40		3	2026-07-25 08:22:44.731106
474	456	40		3	2026-07-25 08:22:44.731106
475	457	40		3	2026-07-25 08:22:44.731106
476	458	40		3	2026-07-25 08:22:44.731106
477	459	40		3	2026-07-25 08:22:44.731106
478	460	40		3	2026-07-25 08:22:44.731106
479	461	40		3	2026-07-25 08:22:44.731106
480	462	40		3	2026-07-25 08:22:44.731106
481	463	40		3	2026-07-25 08:22:44.731106
482	464	40		3	2026-07-25 08:22:44.731106
483	465	40		3	2026-07-25 08:22:44.731106
484	466	40		3	2026-07-25 08:22:44.731106
485	467	40		3	2026-07-25 08:22:44.731106
486	468	40		3	2026-07-25 08:22:44.731106
487	469	40		3	2026-07-25 08:22:44.731106
488	470	40		3	2026-07-25 08:22:44.731106
489	471	40		3	2026-07-25 08:22:44.731106
490	472	40		3	2026-07-25 08:22:44.731106
491	473	40		3	2026-07-25 08:22:44.731106
492	474	40		3	2026-07-25 08:22:44.731106
493	475	40		3	2026-07-25 08:22:44.731106
494	476	40		3	2026-07-25 08:22:44.731106
495	477	40		3	2026-07-25 08:22:44.731106
496	478	40		3	2026-07-25 08:22:44.731106
497	479	40		3	2026-07-25 08:22:44.731106
498	480	40		3	2026-07-25 08:22:44.731106
499	481	40		3	2026-07-25 08:22:44.731106
500	482	40		3	2026-07-25 08:22:44.731106
501	483	40		3	2026-07-25 08:22:44.731106
502	484	40		3	2026-07-25 08:22:44.731106
503	485	40		3	2026-07-25 08:22:44.731106
504	486	40		3	2026-07-25 08:22:44.731106
505	487	40		3	2026-07-25 08:22:44.731106
506	488	40		3	2026-07-25 08:22:44.731106
507	489	40		3	2026-07-25 08:22:44.731106
508	490	40		3	2026-07-25 08:22:44.731106
509	491	40		3	2026-07-25 08:22:44.731106
510	492	40		3	2026-07-25 08:22:44.731106
511	493	40		3	2026-07-25 08:22:44.731106
512	494	40		3	2026-07-25 08:22:44.731106
513	495	40		3	2026-07-25 08:22:44.731106
514	496	40		3	2026-07-25 08:22:44.731106
515	497	40		3	2026-07-25 08:22:44.731106
516	498	40		3	2026-07-25 08:22:44.731106
517	499	40		3	2026-07-25 08:22:44.731106
518	500	40		3	2026-07-25 08:22:44.731106
519	501	40		3	2026-07-25 08:22:44.731106
520	502	40		3	2026-07-25 08:22:44.731106
521	503	40		3	2026-07-25 08:22:44.731106
522	504	40		3	2026-07-25 08:22:44.731106
523	505	40		3	2026-07-25 08:22:44.731106
524	506	40		3	2026-07-25 08:22:44.731106
525	507	40		3	2026-07-25 08:22:44.731106
526	508	40		3	2026-07-25 08:22:44.731106
527	509	40		3	2026-07-25 08:22:44.731106
528	510	40		3	2026-07-25 08:22:44.731106
529	511	40		3	2026-07-25 08:22:44.731106
530	512	40		3	2026-07-25 08:22:44.731106
531	513	40		3	2026-07-25 08:22:44.731106
532	514	40		3	2026-07-25 08:22:44.731106
533	515	40		3	2026-07-25 08:22:44.731106
534	516	40		3	2026-07-25 08:22:44.731106
535	517	40		3	2026-07-25 08:22:44.731106
536	518	40		3	2026-07-25 08:22:44.731106
537	519	40		3	2026-07-25 08:22:44.731106
538	520	40		3	2026-07-25 08:22:44.731106
539	521	40		3	2026-07-25 08:22:44.731106
540	522	40		3	2026-07-25 08:22:44.731106
541	523	40		3	2026-07-25 08:22:44.731106
542	524	40		3	2026-07-25 08:22:44.731106
543	525	40		3	2026-07-25 08:22:44.731106
544	526	40		3	2026-07-25 08:22:44.731106
545	527	40		3	2026-07-25 08:22:44.731106
546	528	40		3	2026-07-25 08:22:44.731106
547	529	40		3	2026-07-25 08:22:44.731106
548	530	40		3	2026-07-25 08:22:44.731106
549	531	40		3	2026-07-25 08:22:44.731106
550	532	40		3	2026-07-25 08:22:44.731106
551	533	40		3	2026-07-25 08:22:44.731106
552	534	40		3	2026-07-25 08:22:44.731106
553	535	40		3	2026-07-25 08:22:44.731106
554	536	40		3	2026-07-25 08:22:44.731106
555	537	40		3	2026-07-25 08:22:44.731106
556	538	40		3	2026-07-25 08:22:44.731106
557	539	40		3	2026-07-25 08:22:44.731106
558	540	40		3	2026-07-25 08:22:44.731106
559	541	40		3	2026-07-25 08:22:44.731106
560	542	40		3	2026-07-25 08:22:44.731106
561	543	40		3	2026-07-25 08:22:44.731106
562	544	40		3	2026-07-25 08:22:44.731106
563	545	40		3	2026-07-25 08:22:44.731106
564	546	40		3	2026-07-25 08:22:44.731106
565	547	40		3	2026-07-25 08:22:44.731106
566	548	40		3	2026-07-25 08:22:44.731106
567	549	40		3	2026-07-25 08:22:44.731106
568	550	40		3	2026-07-25 08:22:44.731106
569	551	40		3	2026-07-25 08:22:44.731106
570	552	40		3	2026-07-25 08:22:44.731106
571	553	40		3	2026-07-25 08:22:44.731106
572	554	40		3	2026-07-25 08:22:44.731106
573	555	40		3	2026-07-25 08:22:44.731106
574	556	40		3	2026-07-25 08:22:44.731106
575	557	40		3	2026-07-25 08:22:44.731106
576	558	40		3	2026-07-25 08:22:44.731106
577	559	40		3	2026-07-25 08:22:44.731106
578	560	40		3	2026-07-25 08:22:44.731106
579	561	40		3	2026-07-25 08:22:44.731106
580	562	40		3	2026-07-25 08:22:44.731106
581	563	40		3	2026-07-25 08:22:44.731106
582	564	40		3	2026-07-25 08:22:44.731106
583	565	40		3	2026-07-25 08:22:44.731106
584	566	40		3	2026-07-25 08:22:44.731106
585	567	40		3	2026-07-25 08:22:44.731106
586	568	40		3	2026-07-25 08:22:44.731106
587	569	40		3	2026-07-25 08:22:44.731106
588	570	40		3	2026-07-25 08:22:44.731106
589	571	40		3	2026-07-25 08:22:44.731106
590	572	40		3	2026-07-25 08:22:44.731106
591	573	40		3	2026-07-25 08:22:44.731106
592	574	40		3	2026-07-25 08:22:44.731106
593	575	40		3	2026-07-25 08:22:44.731106
594	576	40		3	2026-07-25 08:22:44.731106
595	577	40		3	2026-07-25 08:22:44.731106
596	578	40		3	2026-07-25 08:22:44.731106
597	579	40		3	2026-07-25 08:22:44.731106
598	580	40		3	2026-07-25 08:22:44.731106
599	581	40		3	2026-07-25 08:22:44.731106
600	582	40		3	2026-07-25 08:22:44.731106
601	583	40		3	2026-07-25 08:22:44.731106
602	584	40		3	2026-07-25 08:22:44.731106
603	585	40		3	2026-07-25 08:22:44.731106
604	586	40		3	2026-07-25 08:22:44.731106
605	587	40		3	2026-07-25 08:22:44.731106
606	588	40		3	2026-07-25 08:22:44.731106
607	589	40		3	2026-07-25 08:22:44.731106
608	590	40		3	2026-07-25 08:22:44.731106
609	591	40		3	2026-07-25 08:22:44.731106
610	592	40		3	2026-07-25 08:22:44.731106
611	593	40		3	2026-07-25 08:22:44.731106
612	594	40		3	2026-07-25 08:22:44.731106
613	595	40		3	2026-07-25 08:22:44.731106
614	596	40		3	2026-07-25 08:22:44.731106
615	597	40		3	2026-07-25 08:22:44.731106
616	598	40		3	2026-07-25 08:22:44.731106
617	599	40		3	2026-07-25 08:22:44.731106
618	600	40		3	2026-07-25 08:22:44.731106
619	601	40		3	2026-07-25 08:22:44.731106
620	602	40		3	2026-07-25 08:22:44.731106
621	603	40		3	2026-07-25 08:22:44.731106
622	604	40		3	2026-07-25 08:22:44.731106
623	605	40		3	2026-07-25 08:22:44.731106
624	606	40		3	2026-07-25 08:22:44.731106
625	25	50		3	2026-07-25 08:22:52.060579
626	26	50		3	2026-07-25 08:22:52.060579
627	27	50		3	2026-07-25 08:22:52.060579
628	28	50		3	2026-07-25 08:22:52.060579
629	29	50		3	2026-07-25 08:22:52.060579
630	30	50		3	2026-07-25 08:22:52.060579
631	31	50		3	2026-07-25 08:22:52.060579
632	32	50		3	2026-07-25 08:22:52.060579
633	33	50		3	2026-07-25 08:22:52.060579
634	34	50		3	2026-07-25 08:22:52.060579
635	35	50		3	2026-07-25 08:22:52.060579
636	36	50		3	2026-07-25 08:22:52.060579
637	37	50		3	2026-07-25 08:22:52.060579
638	38	50		3	2026-07-25 08:22:52.060579
639	39	50		3	2026-07-25 08:22:52.060579
640	40	50		3	2026-07-25 08:22:52.060579
641	41	50		3	2026-07-25 08:22:52.060579
642	42	50		3	2026-07-25 08:22:52.060579
643	43	50		3	2026-07-25 08:22:52.060579
644	44	50		3	2026-07-25 08:22:52.060579
645	45	50		3	2026-07-25 08:22:52.060579
646	46	50		3	2026-07-25 08:22:52.060579
647	47	50		3	2026-07-25 08:22:52.060579
648	48	50		3	2026-07-25 08:22:52.060579
649	49	50		3	2026-07-25 08:22:52.060579
650	50	50		3	2026-07-25 08:22:52.060579
651	51	50		3	2026-07-25 08:22:52.060579
652	52	50		3	2026-07-25 08:22:52.060579
653	53	50		3	2026-07-25 08:22:52.060579
654	54	50		3	2026-07-25 08:22:52.060579
655	55	50		3	2026-07-25 08:22:52.060579
656	56	50		3	2026-07-25 08:22:52.060579
657	57	50		3	2026-07-25 08:22:52.060579
658	58	50		3	2026-07-25 08:22:52.060579
659	59	50		3	2026-07-25 08:22:52.060579
660	60	50		3	2026-07-25 08:22:52.060579
661	61	50		3	2026-07-25 08:22:52.060579
662	62	50		3	2026-07-25 08:22:52.060579
663	63	50		3	2026-07-25 08:22:52.060579
664	64	50		3	2026-07-25 08:22:52.060579
665	65	50		3	2026-07-25 08:22:52.060579
666	66	50		3	2026-07-25 08:22:52.060579
667	67	50		3	2026-07-25 08:22:52.060579
668	68	50		3	2026-07-25 08:22:52.060579
669	69	50		3	2026-07-25 08:22:52.060579
670	70	50		3	2026-07-25 08:22:52.060579
671	71	50		3	2026-07-25 08:22:52.060579
672	72	50		3	2026-07-25 08:22:52.060579
673	73	50		3	2026-07-25 08:22:52.060579
674	74	50		3	2026-07-25 08:22:52.060579
675	75	50		3	2026-07-25 08:22:52.060579
676	76	50		3	2026-07-25 08:22:52.060579
677	77	50		3	2026-07-25 08:22:52.060579
678	78	50		3	2026-07-25 08:22:52.060579
679	79	50		3	2026-07-25 08:22:52.060579
680	80	50		3	2026-07-25 08:22:52.060579
681	81	50		3	2026-07-25 08:22:52.060579
682	82	50		3	2026-07-25 08:22:52.060579
683	83	50		3	2026-07-25 08:22:52.060579
684	84	50		3	2026-07-25 08:22:52.060579
685	85	50		3	2026-07-25 08:22:52.060579
686	86	50		3	2026-07-25 08:22:52.060579
687	87	50		3	2026-07-25 08:22:52.060579
688	88	50		3	2026-07-25 08:22:52.060579
689	89	50		3	2026-07-25 08:22:52.060579
690	90	50		3	2026-07-25 08:22:52.060579
691	91	50		3	2026-07-25 08:22:52.060579
692	92	50		3	2026-07-25 08:22:52.060579
693	93	50		3	2026-07-25 08:22:52.060579
694	94	50		3	2026-07-25 08:22:52.060579
695	95	50		3	2026-07-25 08:22:52.060579
696	96	50		3	2026-07-25 08:22:52.060579
697	97	50		3	2026-07-25 08:22:52.060579
698	98	50		3	2026-07-25 08:22:52.060579
699	99	50		3	2026-07-25 08:22:52.060579
700	100	50		3	2026-07-25 08:22:52.060579
701	101	50		3	2026-07-25 08:22:52.060579
702	102	50		3	2026-07-25 08:22:52.060579
703	103	50		3	2026-07-25 08:22:52.060579
704	104	50		3	2026-07-25 08:22:52.060579
705	105	50		3	2026-07-25 08:22:52.060579
706	106	50		3	2026-07-25 08:22:52.060579
707	107	50		3	2026-07-25 08:22:52.060579
708	108	50		3	2026-07-25 08:22:52.060579
709	109	50		3	2026-07-25 08:22:52.060579
710	110	50		3	2026-07-25 08:22:52.060579
711	111	50		3	2026-07-25 08:22:52.060579
712	112	50		3	2026-07-25 08:22:52.060579
713	113	50		3	2026-07-25 08:22:52.060579
714	114	50		3	2026-07-25 08:22:52.060579
715	115	50		3	2026-07-25 08:22:52.060579
716	116	50		3	2026-07-25 08:22:52.060579
717	117	50		3	2026-07-25 08:22:52.060579
718	118	50		3	2026-07-25 08:22:52.060579
719	119	50		3	2026-07-25 08:22:52.060579
720	120	50		3	2026-07-25 08:22:52.060579
721	121	50		3	2026-07-25 08:22:52.060579
722	122	50		3	2026-07-25 08:22:52.060579
723	123	50		3	2026-07-25 08:22:52.060579
724	124	50		3	2026-07-25 08:22:52.060579
725	125	50		3	2026-07-25 08:22:52.060579
726	126	50		3	2026-07-25 08:22:52.060579
727	127	50		3	2026-07-25 08:22:52.060579
728	128	50		3	2026-07-25 08:22:52.060579
729	129	50		3	2026-07-25 08:22:52.060579
730	130	50		3	2026-07-25 08:22:52.060579
731	131	50		3	2026-07-25 08:22:52.060579
732	132	50		3	2026-07-25 08:22:52.060579
733	133	50		3	2026-07-25 08:22:52.060579
734	134	50		3	2026-07-25 08:22:52.060579
735	135	50		3	2026-07-25 08:22:52.060579
736	136	50		3	2026-07-25 08:22:52.060579
737	137	50		3	2026-07-25 08:22:52.060579
738	138	50		3	2026-07-25 08:22:52.060579
739	139	50		3	2026-07-25 08:22:52.060579
740	140	50		3	2026-07-25 08:22:52.060579
741	141	50		3	2026-07-25 08:22:52.060579
742	142	50		3	2026-07-25 08:22:52.060579
743	143	50		3	2026-07-25 08:22:52.060579
744	144	50		3	2026-07-25 08:22:52.060579
745	145	50		3	2026-07-25 08:22:52.060579
746	146	50		3	2026-07-25 08:22:52.060579
747	147	50		3	2026-07-25 08:22:52.060579
748	148	50		3	2026-07-25 08:22:52.060579
749	149	50		3	2026-07-25 08:22:52.060579
750	150	50		3	2026-07-25 08:22:52.060579
751	151	50		3	2026-07-25 08:22:52.060579
752	152	50		3	2026-07-25 08:22:52.060579
753	153	50		3	2026-07-25 08:22:52.060579
754	154	50		3	2026-07-25 08:22:52.060579
755	155	50		3	2026-07-25 08:22:52.060579
756	156	50		3	2026-07-25 08:22:52.060579
757	157	50		3	2026-07-25 08:22:52.060579
758	158	50		3	2026-07-25 08:22:52.060579
759	159	50		3	2026-07-25 08:22:52.060579
760	160	50		3	2026-07-25 08:22:52.060579
761	161	50		3	2026-07-25 08:22:52.060579
762	162	50		3	2026-07-25 08:22:52.060579
763	163	50		3	2026-07-25 08:22:52.060579
764	164	50		3	2026-07-25 08:22:52.060579
765	165	50		3	2026-07-25 08:22:52.060579
766	166	50		3	2026-07-25 08:22:52.060579
767	167	50		3	2026-07-25 08:22:52.060579
768	168	50		3	2026-07-25 08:22:52.060579
769	169	50		3	2026-07-25 08:22:52.060579
770	170	50		3	2026-07-25 08:22:52.060579
771	171	50		3	2026-07-25 08:22:52.060579
772	172	50		3	2026-07-25 08:22:52.060579
773	173	50		3	2026-07-25 08:22:52.060579
774	174	50		3	2026-07-25 08:22:52.060579
775	175	50		3	2026-07-25 08:22:52.060579
776	176	50		3	2026-07-25 08:22:52.060579
777	177	50		3	2026-07-25 08:22:52.060579
778	178	50		3	2026-07-25 08:22:52.060579
779	179	50		3	2026-07-25 08:22:52.060579
780	180	50		3	2026-07-25 08:22:52.060579
781	181	50		3	2026-07-25 08:22:52.060579
782	182	50		3	2026-07-25 08:22:52.060579
783	183	50		3	2026-07-25 08:22:52.060579
784	184	50		3	2026-07-25 08:22:52.060579
785	185	50		3	2026-07-25 08:22:52.060579
786	186	50		3	2026-07-25 08:22:52.060579
787	187	50		3	2026-07-25 08:22:52.060579
788	188	50		3	2026-07-25 08:22:52.060579
789	189	50		3	2026-07-25 08:22:52.060579
790	190	50		3	2026-07-25 08:22:52.060579
791	191	50		3	2026-07-25 08:22:52.060579
792	192	50		3	2026-07-25 08:22:52.060579
793	193	50		3	2026-07-25 08:22:52.060579
794	194	50		3	2026-07-25 08:22:52.060579
795	195	50		3	2026-07-25 08:22:52.060579
796	196	50		3	2026-07-25 08:22:52.060579
797	197	50		3	2026-07-25 08:22:52.060579
798	198	50		3	2026-07-25 08:22:52.060579
799	199	50		3	2026-07-25 08:22:52.060579
800	200	50		3	2026-07-25 08:22:52.060579
801	201	50		3	2026-07-25 08:22:52.060579
802	202	50		3	2026-07-25 08:22:52.060579
803	203	50		3	2026-07-25 08:22:52.060579
804	204	50		3	2026-07-25 08:22:52.060579
805	205	50		3	2026-07-25 08:22:52.060579
806	206	50		3	2026-07-25 08:22:52.060579
807	207	50		3	2026-07-25 08:22:52.060579
808	208	50		3	2026-07-25 08:22:52.060579
809	209	50		3	2026-07-25 08:22:52.060579
810	210	50		3	2026-07-25 08:22:52.060579
811	211	50		3	2026-07-25 08:22:52.060579
812	212	50		3	2026-07-25 08:22:52.060579
813	213	50		3	2026-07-25 08:22:52.060579
814	214	50		3	2026-07-25 08:22:52.060579
815	215	50		3	2026-07-25 08:22:52.060579
816	216	50		3	2026-07-25 08:22:52.060579
817	217	50		3	2026-07-25 08:22:52.060579
818	218	50		3	2026-07-25 08:22:52.060579
819	219	50		3	2026-07-25 08:22:52.060579
820	220	50		3	2026-07-25 08:22:52.060579
821	221	50		3	2026-07-25 08:22:52.060579
822	222	50		3	2026-07-25 08:22:52.060579
823	223	50		3	2026-07-25 08:22:52.060579
824	224	50		3	2026-07-25 08:22:52.060579
825	225	50		3	2026-07-25 08:22:52.060579
826	226	50		3	2026-07-25 08:22:52.060579
827	227	50		3	2026-07-25 08:22:52.060579
828	228	50		3	2026-07-25 08:22:52.060579
829	229	50		3	2026-07-25 08:22:52.060579
830	230	50		3	2026-07-25 08:22:52.060579
831	231	50		3	2026-07-25 08:22:52.060579
832	232	50		3	2026-07-25 08:22:52.060579
833	233	50		3	2026-07-25 08:22:52.060579
834	234	50		3	2026-07-25 08:22:52.060579
835	235	50		3	2026-07-25 08:22:52.060579
836	236	50		3	2026-07-25 08:22:52.060579
837	237	50		3	2026-07-25 08:22:52.060579
838	238	50		3	2026-07-25 08:22:52.060579
839	239	50		3	2026-07-25 08:22:52.060579
840	240	50		3	2026-07-25 08:22:52.060579
841	241	50		3	2026-07-25 08:22:52.060579
842	242	50		3	2026-07-25 08:22:52.060579
843	243	50		3	2026-07-25 08:22:52.060579
844	244	50		3	2026-07-25 08:22:52.060579
845	245	50		3	2026-07-25 08:22:52.060579
846	246	50		3	2026-07-25 08:22:52.060579
847	247	50		3	2026-07-25 08:22:52.060579
848	248	50		3	2026-07-25 08:22:52.060579
849	249	50		3	2026-07-25 08:22:52.060579
850	250	50		3	2026-07-25 08:22:52.060579
851	251	50		3	2026-07-25 08:22:52.060579
852	252	50		3	2026-07-25 08:22:52.060579
853	253	50		3	2026-07-25 08:22:52.060579
854	254	50		3	2026-07-25 08:22:52.060579
855	255	50		3	2026-07-25 08:22:52.060579
856	256	50		3	2026-07-25 08:22:52.060579
857	257	50		3	2026-07-25 08:22:52.060579
858	258	50		3	2026-07-25 08:22:52.060579
859	259	50		3	2026-07-25 08:22:52.060579
860	260	50		3	2026-07-25 08:22:52.060579
861	261	50		3	2026-07-25 08:22:52.060579
862	262	50		3	2026-07-25 08:22:52.060579
863	263	50		3	2026-07-25 08:22:52.060579
864	264	50		3	2026-07-25 08:22:52.060579
865	265	50		3	2026-07-25 08:22:52.060579
866	266	50		3	2026-07-25 08:22:52.060579
867	267	50		3	2026-07-25 08:22:52.060579
868	268	50		3	2026-07-25 08:22:52.060579
869	269	50		3	2026-07-25 08:22:52.060579
870	270	50		3	2026-07-25 08:22:52.060579
871	271	50		3	2026-07-25 08:22:52.060579
872	272	50		3	2026-07-25 08:22:52.060579
873	273	50		3	2026-07-25 08:22:52.060579
874	274	50		3	2026-07-25 08:22:52.060579
875	275	50		3	2026-07-25 08:22:52.060579
876	276	50		3	2026-07-25 08:22:52.060579
877	277	50		3	2026-07-25 08:22:52.060579
878	278	50		3	2026-07-25 08:22:52.060579
879	279	50		3	2026-07-25 08:22:52.060579
880	280	50		3	2026-07-25 08:22:52.060579
881	281	50		3	2026-07-25 08:22:52.060579
882	282	50		3	2026-07-25 08:22:52.060579
883	283	50		3	2026-07-25 08:22:52.060579
884	284	50		3	2026-07-25 08:22:52.060579
885	285	50		3	2026-07-25 08:22:52.060579
886	286	50		3	2026-07-25 08:22:52.060579
887	287	50		3	2026-07-25 08:22:52.060579
888	288	50		3	2026-07-25 08:22:52.060579
889	289	50		3	2026-07-25 08:22:52.060579
890	290	50		3	2026-07-25 08:22:52.060579
891	291	50		3	2026-07-25 08:22:52.060579
892	292	50		3	2026-07-25 08:22:52.060579
893	293	50		3	2026-07-25 08:22:52.060579
894	294	50		3	2026-07-25 08:22:52.060579
895	295	50		3	2026-07-25 08:22:52.060579
896	296	50		3	2026-07-25 08:22:52.060579
897	297	50		3	2026-07-25 08:22:52.060579
898	298	50		3	2026-07-25 08:22:52.060579
899	299	50		3	2026-07-25 08:22:52.060579
900	300	50		3	2026-07-25 08:22:52.060579
901	301	50		3	2026-07-25 08:22:52.060579
902	302	50		3	2026-07-25 08:22:52.060579
903	303	50		3	2026-07-25 08:22:52.060579
904	304	50		3	2026-07-25 08:22:52.060579
905	305	50		3	2026-07-25 08:22:52.060579
906	306	50		3	2026-07-25 08:22:52.060579
907	307	50		3	2026-07-25 08:22:52.060579
908	308	50		3	2026-07-25 08:22:52.060579
909	309	50		3	2026-07-25 08:22:52.060579
910	310	50		3	2026-07-25 08:22:52.060579
911	311	50		3	2026-07-25 08:22:52.060579
912	312	50		3	2026-07-25 08:22:52.060579
913	313	50		3	2026-07-25 08:22:52.060579
914	314	50		3	2026-07-25 08:22:52.060579
915	315	50		3	2026-07-25 08:22:52.060579
916	316	50		3	2026-07-25 08:22:52.060579
917	317	50		3	2026-07-25 08:22:52.060579
918	318	50		3	2026-07-25 08:22:52.060579
919	319	50		3	2026-07-25 08:22:52.060579
920	320	50		3	2026-07-25 08:22:52.060579
921	321	50		3	2026-07-25 08:22:52.060579
922	322	50		3	2026-07-25 08:22:52.060579
923	323	50		3	2026-07-25 08:22:52.060579
924	324	50		3	2026-07-25 08:22:52.060579
925	325	50		3	2026-07-25 08:22:52.060579
926	326	50		3	2026-07-25 08:22:52.060579
927	327	50		3	2026-07-25 08:22:52.060579
928	328	50		3	2026-07-25 08:22:52.060579
929	329	50		3	2026-07-25 08:22:52.060579
930	330	50		3	2026-07-25 08:22:52.060579
931	331	50		3	2026-07-25 08:22:52.060579
932	332	50		3	2026-07-25 08:22:52.060579
933	333	50		3	2026-07-25 08:22:52.060579
934	334	50		3	2026-07-25 08:22:52.060579
935	335	50		3	2026-07-25 08:22:52.060579
936	336	50		3	2026-07-25 08:22:52.060579
937	337	50		3	2026-07-25 08:22:52.060579
938	338	50		3	2026-07-25 08:22:52.060579
939	339	50		3	2026-07-25 08:22:52.060579
940	340	50		3	2026-07-25 08:22:52.060579
941	341	50		3	2026-07-25 08:22:52.060579
942	342	50		3	2026-07-25 08:22:52.060579
943	343	50		3	2026-07-25 08:22:52.060579
944	344	50		3	2026-07-25 08:22:52.060579
945	345	50		3	2026-07-25 08:22:52.060579
946	346	50		3	2026-07-25 08:22:52.060579
947	347	50		3	2026-07-25 08:22:52.060579
948	348	50		3	2026-07-25 08:22:52.060579
949	349	50		3	2026-07-25 08:22:52.060579
950	350	50		3	2026-07-25 08:22:52.060579
951	351	50		3	2026-07-25 08:22:52.060579
952	352	50		3	2026-07-25 08:22:52.060579
953	353	50		3	2026-07-25 08:22:52.060579
954	354	50		3	2026-07-25 08:22:52.060579
955	355	50		3	2026-07-25 08:22:52.060579
956	356	50		3	2026-07-25 08:22:52.060579
957	357	50		3	2026-07-25 08:22:52.060579
958	358	50		3	2026-07-25 08:22:52.060579
959	359	50		3	2026-07-25 08:22:52.060579
960	360	50		3	2026-07-25 08:22:52.060579
961	361	50		3	2026-07-25 08:22:52.060579
962	362	50		3	2026-07-25 08:22:52.060579
963	363	50		3	2026-07-25 08:22:52.060579
964	364	50		3	2026-07-25 08:22:52.060579
965	365	50		3	2026-07-25 08:22:52.060579
966	366	50		3	2026-07-25 08:22:52.060579
967	367	50		3	2026-07-25 08:22:52.060579
968	368	50		3	2026-07-25 08:22:52.060579
969	369	50		3	2026-07-25 08:22:52.060579
970	370	50		3	2026-07-25 08:22:52.060579
971	371	50		3	2026-07-25 08:22:52.060579
972	372	50		3	2026-07-25 08:22:52.060579
973	373	50		3	2026-07-25 08:22:52.060579
974	374	50		3	2026-07-25 08:22:52.060579
975	375	50		3	2026-07-25 08:22:52.060579
976	376	50		3	2026-07-25 08:22:52.060579
977	377	50		3	2026-07-25 08:22:52.060579
978	378	50		3	2026-07-25 08:22:52.060579
979	379	50		3	2026-07-25 08:22:52.060579
980	380	50		3	2026-07-25 08:22:52.060579
981	381	50		3	2026-07-25 08:22:52.060579
982	382	50		3	2026-07-25 08:22:52.060579
983	383	50		3	2026-07-25 08:22:52.060579
984	384	50		3	2026-07-25 08:22:52.060579
985	385	50		3	2026-07-25 08:22:52.060579
986	386	50		3	2026-07-25 08:22:52.060579
987	387	50		3	2026-07-25 08:22:52.060579
988	388	50		3	2026-07-25 08:22:52.060579
989	389	50		3	2026-07-25 08:22:52.060579
990	390	50		3	2026-07-25 08:22:52.060579
991	391	50		3	2026-07-25 08:22:52.060579
992	392	50		3	2026-07-25 08:22:52.060579
993	393	50		3	2026-07-25 08:22:52.060579
994	394	50		3	2026-07-25 08:22:52.060579
995	395	50		3	2026-07-25 08:22:52.060579
996	396	50		3	2026-07-25 08:22:52.060579
997	397	50		3	2026-07-25 08:22:52.060579
998	398	50		3	2026-07-25 08:22:52.060579
999	399	50		3	2026-07-25 08:22:52.060579
1000	400	50		3	2026-07-25 08:22:52.060579
1001	401	50		3	2026-07-25 08:22:52.060579
1002	402	50		3	2026-07-25 08:22:52.060579
1003	403	50		3	2026-07-25 08:22:52.060579
1004	404	50		3	2026-07-25 08:22:52.060579
1005	405	50		3	2026-07-25 08:22:52.060579
1006	406	50		3	2026-07-25 08:22:52.060579
1007	407	50		3	2026-07-25 08:22:52.060579
1008	408	50		3	2026-07-25 08:22:52.060579
1009	409	50		3	2026-07-25 08:22:52.060579
1010	410	50		3	2026-07-25 08:22:52.060579
1011	411	50		3	2026-07-25 08:22:52.060579
1012	412	50		3	2026-07-25 08:22:52.060579
1013	413	50		3	2026-07-25 08:22:52.060579
1014	414	50		3	2026-07-25 08:22:52.060579
1015	415	50		3	2026-07-25 08:22:52.060579
1016	416	50		3	2026-07-25 08:22:52.060579
1017	417	50		3	2026-07-25 08:22:52.060579
1018	418	50		3	2026-07-25 08:22:52.060579
1019	419	50		3	2026-07-25 08:22:52.060579
1020	420	50		3	2026-07-25 08:22:52.060579
1021	421	50		3	2026-07-25 08:22:52.060579
1022	422	50		3	2026-07-25 08:22:52.060579
1023	423	50		3	2026-07-25 08:22:52.060579
1024	424	50		3	2026-07-25 08:22:52.060579
1025	425	50		3	2026-07-25 08:22:52.060579
1026	426	50		3	2026-07-25 08:22:52.060579
1027	427	50		3	2026-07-25 08:22:52.060579
1028	428	50		3	2026-07-25 08:22:52.060579
1029	429	50		3	2026-07-25 08:22:52.060579
1030	430	50		3	2026-07-25 08:22:52.060579
1031	431	50		3	2026-07-25 08:22:52.060579
1032	432	50		3	2026-07-25 08:22:52.060579
1033	433	50		3	2026-07-25 08:22:52.060579
1034	434	50		3	2026-07-25 08:22:52.060579
1035	435	50		3	2026-07-25 08:22:52.060579
1036	436	50		3	2026-07-25 08:22:52.060579
1037	437	50		3	2026-07-25 08:22:52.060579
1038	438	50		3	2026-07-25 08:22:52.060579
1039	439	50		3	2026-07-25 08:22:52.060579
1040	440	50		3	2026-07-25 08:22:52.060579
1041	441	50		3	2026-07-25 08:22:52.060579
1042	442	50		3	2026-07-25 08:22:52.060579
1043	443	50		3	2026-07-25 08:22:52.060579
1044	444	50		3	2026-07-25 08:22:52.060579
1045	445	50		3	2026-07-25 08:22:52.060579
1046	446	50		3	2026-07-25 08:22:52.060579
1047	447	50		3	2026-07-25 08:22:52.060579
1048	448	50		3	2026-07-25 08:22:52.060579
1049	449	50		3	2026-07-25 08:22:52.060579
1050	450	50		3	2026-07-25 08:22:52.060579
1051	451	50		3	2026-07-25 08:22:52.060579
1052	452	50		3	2026-07-25 08:22:52.060579
1053	453	50		3	2026-07-25 08:22:52.060579
1054	454	50		3	2026-07-25 08:22:52.060579
1055	455	50		3	2026-07-25 08:22:52.060579
1056	456	50		3	2026-07-25 08:22:52.060579
1057	457	50		3	2026-07-25 08:22:52.060579
1058	458	50		3	2026-07-25 08:22:52.060579
1059	459	50		3	2026-07-25 08:22:52.060579
1060	460	50		3	2026-07-25 08:22:52.060579
1061	461	50		3	2026-07-25 08:22:52.060579
1062	462	50		3	2026-07-25 08:22:52.060579
1063	463	50		3	2026-07-25 08:22:52.060579
1064	464	50		3	2026-07-25 08:22:52.060579
1065	465	50		3	2026-07-25 08:22:52.060579
1066	466	50		3	2026-07-25 08:22:52.060579
1067	467	50		3	2026-07-25 08:22:52.060579
1068	468	50		3	2026-07-25 08:22:52.060579
1069	469	50		3	2026-07-25 08:22:52.060579
1070	470	50		3	2026-07-25 08:22:52.060579
1071	471	50		3	2026-07-25 08:22:52.060579
1072	472	50		3	2026-07-25 08:22:52.060579
1073	473	50		3	2026-07-25 08:22:52.060579
1074	474	50		3	2026-07-25 08:22:52.060579
1075	475	50		3	2026-07-25 08:22:52.060579
1076	476	50		3	2026-07-25 08:22:52.060579
1077	477	50		3	2026-07-25 08:22:52.060579
1078	478	50		3	2026-07-25 08:22:52.060579
1079	479	50		3	2026-07-25 08:22:52.060579
1080	480	50		3	2026-07-25 08:22:52.060579
1081	481	50		3	2026-07-25 08:22:52.060579
1082	482	50		3	2026-07-25 08:22:52.060579
1083	483	50		3	2026-07-25 08:22:52.060579
1084	484	50		3	2026-07-25 08:22:52.060579
1085	485	50		3	2026-07-25 08:22:52.060579
1086	486	50		3	2026-07-25 08:22:52.060579
1087	487	50		3	2026-07-25 08:22:52.060579
1088	488	50		3	2026-07-25 08:22:52.060579
1089	489	50		3	2026-07-25 08:22:52.060579
1090	490	50		3	2026-07-25 08:22:52.060579
1091	491	50		3	2026-07-25 08:22:52.060579
1092	492	50		3	2026-07-25 08:22:52.060579
1093	493	50		3	2026-07-25 08:22:52.060579
1094	494	50		3	2026-07-25 08:22:52.060579
1095	495	50		3	2026-07-25 08:22:52.060579
1096	496	50		3	2026-07-25 08:22:52.060579
1097	497	50		3	2026-07-25 08:22:52.060579
1098	498	50		3	2026-07-25 08:22:52.060579
1099	499	50		3	2026-07-25 08:22:52.060579
1100	500	50		3	2026-07-25 08:22:52.060579
1101	501	50		3	2026-07-25 08:22:52.060579
1102	502	50		3	2026-07-25 08:22:52.060579
1103	503	50		3	2026-07-25 08:22:52.060579
1104	504	50		3	2026-07-25 08:22:52.060579
1105	505	50		3	2026-07-25 08:22:52.060579
1106	506	50		3	2026-07-25 08:22:52.060579
1107	507	50		3	2026-07-25 08:22:52.060579
1108	508	50		3	2026-07-25 08:22:52.060579
1109	509	50		3	2026-07-25 08:22:52.060579
1110	510	50		3	2026-07-25 08:22:52.060579
1111	511	50		3	2026-07-25 08:22:52.060579
1112	512	50		3	2026-07-25 08:22:52.060579
1113	513	50		3	2026-07-25 08:22:52.060579
1114	514	50		3	2026-07-25 08:22:52.060579
1115	515	50		3	2026-07-25 08:22:52.060579
1116	516	50		3	2026-07-25 08:22:52.060579
1117	517	50		3	2026-07-25 08:22:52.060579
1118	518	50		3	2026-07-25 08:22:52.060579
1119	519	50		3	2026-07-25 08:22:52.060579
1120	520	50		3	2026-07-25 08:22:52.060579
1121	521	50		3	2026-07-25 08:22:52.060579
1122	522	50		3	2026-07-25 08:22:52.060579
1123	523	50		3	2026-07-25 08:22:52.060579
1124	524	50		3	2026-07-25 08:22:52.060579
1125	525	50		3	2026-07-25 08:22:52.060579
1126	526	50		3	2026-07-25 08:22:52.060579
1127	527	50		3	2026-07-25 08:22:52.060579
1128	528	50		3	2026-07-25 08:22:52.060579
1129	529	50		3	2026-07-25 08:22:52.060579
1130	530	50		3	2026-07-25 08:22:52.060579
1131	531	50		3	2026-07-25 08:22:52.060579
1132	532	50		3	2026-07-25 08:22:52.060579
1133	533	50		3	2026-07-25 08:22:52.060579
1134	534	50		3	2026-07-25 08:22:52.060579
1135	535	50		3	2026-07-25 08:22:52.060579
1136	536	50		3	2026-07-25 08:22:52.060579
1137	537	50		3	2026-07-25 08:22:52.060579
1138	538	50		3	2026-07-25 08:22:52.060579
1139	539	50		3	2026-07-25 08:22:52.060579
1140	540	50		3	2026-07-25 08:22:52.060579
1141	541	50		3	2026-07-25 08:22:52.060579
1142	542	50		3	2026-07-25 08:22:52.060579
1143	543	50		3	2026-07-25 08:22:52.060579
1144	544	50		3	2026-07-25 08:22:52.060579
1145	545	50		3	2026-07-25 08:22:52.060579
1146	546	50		3	2026-07-25 08:22:52.060579
1147	547	50		3	2026-07-25 08:22:52.060579
1148	548	50		3	2026-07-25 08:22:52.060579
1149	549	50		3	2026-07-25 08:22:52.060579
1150	550	50		3	2026-07-25 08:22:52.060579
1151	551	50		3	2026-07-25 08:22:52.060579
1152	552	50		3	2026-07-25 08:22:52.060579
1153	553	50		3	2026-07-25 08:22:52.060579
1154	554	50		3	2026-07-25 08:22:52.060579
1155	555	50		3	2026-07-25 08:22:52.060579
1156	556	50		3	2026-07-25 08:22:52.060579
1157	557	50		3	2026-07-25 08:22:52.060579
1158	558	50		3	2026-07-25 08:22:52.060579
1159	559	50		3	2026-07-25 08:22:52.060579
1160	560	50		3	2026-07-25 08:22:52.060579
1161	561	50		3	2026-07-25 08:22:52.060579
1162	562	50		3	2026-07-25 08:22:52.060579
1163	563	50		3	2026-07-25 08:22:52.060579
1164	564	50		3	2026-07-25 08:22:52.060579
1165	565	50		3	2026-07-25 08:22:52.060579
1166	566	50		3	2026-07-25 08:22:52.060579
1167	567	50		3	2026-07-25 08:22:52.060579
1168	568	50		3	2026-07-25 08:22:52.060579
1169	569	50		3	2026-07-25 08:22:52.060579
1170	570	50		3	2026-07-25 08:22:52.060579
1171	571	50		3	2026-07-25 08:22:52.060579
1172	572	50		3	2026-07-25 08:22:52.060579
1173	573	50		3	2026-07-25 08:22:52.060579
1174	574	50		3	2026-07-25 08:22:52.060579
1175	575	50		3	2026-07-25 08:22:52.060579
1176	576	50		3	2026-07-25 08:22:52.060579
1177	577	50		3	2026-07-25 08:22:52.060579
1178	578	50		3	2026-07-25 08:22:52.060579
1179	579	50		3	2026-07-25 08:22:52.060579
1180	580	50		3	2026-07-25 08:22:52.060579
1181	581	50		3	2026-07-25 08:22:52.060579
1182	582	50		3	2026-07-25 08:22:52.060579
1183	583	50		3	2026-07-25 08:22:52.060579
1184	584	50		3	2026-07-25 08:22:52.060579
1185	585	50		3	2026-07-25 08:22:52.060579
1186	586	50		3	2026-07-25 08:22:52.060579
1187	587	50		3	2026-07-25 08:22:52.060579
1188	588	50		3	2026-07-25 08:22:52.060579
1189	589	50		3	2026-07-25 08:22:52.060579
1190	590	50		3	2026-07-25 08:22:52.060579
1191	591	50		3	2026-07-25 08:22:52.060579
1192	592	50		3	2026-07-25 08:22:52.060579
1193	593	50		3	2026-07-25 08:22:52.060579
1194	594	50		3	2026-07-25 08:22:52.060579
1195	595	50		3	2026-07-25 08:22:52.060579
1196	596	50		3	2026-07-25 08:22:52.060579
1197	597	50		3	2026-07-25 08:22:52.060579
1198	598	50		3	2026-07-25 08:22:52.060579
1199	599	50		3	2026-07-25 08:22:52.060579
1200	600	50		3	2026-07-25 08:22:52.060579
1201	601	50		3	2026-07-25 08:22:52.060579
1202	602	50		3	2026-07-25 08:22:52.060579
1203	603	50		3	2026-07-25 08:22:52.060579
1204	604	50		3	2026-07-25 08:22:52.060579
1205	605	50		3	2026-07-25 08:22:52.060579
1206	606	50		3	2026-07-25 08:22:52.060579
\.


--
-- TOC entry 3841 (class 0 OID 466636)
-- Dependencies: 251
-- Data for Name: event_register; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.event_register (id) FROM stdin;
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91
92
93
94
95
96
97
98
99
100
101
102
103
104
105
106
107
108
109
110
111
112
113
114
115
116
117
118
119
120
121
122
123
124
125
126
127
128
129
130
131
132
133
134
135
136
137
138
139
140
141
142
143
144
145
146
147
148
149
150
151
152
153
154
155
156
157
158
159
160
161
162
163
164
165
166
167
168
169
170
171
172
173
174
175
176
177
178
179
180
181
182
183
184
185
186
187
188
189
190
191
192
193
194
195
196
197
198
199
200
201
202
203
204
205
206
207
208
209
210
211
212
213
214
215
216
217
218
219
220
221
222
223
224
225
226
227
228
229
230
231
232
233
234
235
236
237
238
239
240
241
242
243
244
245
246
247
248
249
250
251
252
253
254
255
256
257
258
259
260
261
262
263
264
265
266
267
268
269
270
271
272
273
274
275
276
277
278
279
280
281
282
283
284
285
286
287
288
289
290
291
292
293
294
295
296
297
298
299
300
301
302
303
304
305
306
307
308
309
310
311
312
313
314
315
316
317
318
319
320
321
322
323
324
325
326
327
328
329
330
331
332
333
334
335
336
337
338
339
340
341
342
343
344
345
346
347
348
349
350
351
352
353
354
355
356
357
358
359
360
361
362
363
364
365
366
367
368
369
370
371
372
373
374
375
376
377
378
379
380
381
382
383
384
385
386
387
388
389
390
391
392
393
394
395
396
397
398
399
400
401
402
403
404
405
406
407
408
409
410
411
412
413
414
415
416
417
418
419
420
421
422
423
424
425
426
427
428
429
430
431
432
433
434
435
436
437
438
439
440
441
442
443
444
445
446
447
448
449
450
451
452
453
454
455
456
457
458
459
460
461
462
463
464
465
466
467
468
469
470
471
472
473
474
475
476
477
478
479
480
481
482
483
484
485
486
487
488
489
490
491
492
493
494
495
496
497
498
499
500
501
502
503
504
505
506
507
508
509
510
511
512
513
514
515
516
517
518
519
520
521
522
523
524
525
526
527
528
529
530
531
532
533
534
535
536
537
538
539
540
541
542
543
544
545
546
547
548
549
550
551
552
553
554
555
556
557
558
559
560
561
562
563
564
565
566
567
568
569
570
571
572
573
574
575
576
577
578
579
580
581
582
583
584
585
586
587
588
589
590
591
592
593
594
595
596
597
598
599
600
601
602
603
604
605
606
\.


--
-- TOC entry 3818 (class 0 OID 466475)
-- Dependencies: 228
-- Data for Name: incident_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incident_types (id, name) FROM stdin;
1	Theft
2	Missing
3	Damage
4	Malfunction
5	Misuse
6	Other
7	Lost
\.


--
-- TOC entry 3819 (class 0 OID 466483)
-- Dependencies: 229
-- Data for Name: issuance_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issuance_types (id, name) FROM stdin;
1	Keep
2	Use
\.


--
-- TOC entry 3806 (class 0 OID 466421)
-- Dependencies: 216
-- Data for Name: model_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.model_types (id, name) FROM stdin;
1	ProBook 450 G12
2	Galaxy Book Pro
3	Samsung Galaxy S23
4	Honor 100
5	ThinkPad T490
6	Latitude 5490
7	Z-Book Pro
8	Iphone XR
9	10.9 Inch Apple Ipad
10	1Kg
11	2 Door & 2 Drawer
12	2 Door 3 Tier
13	2 Plate Stove
14	2.2Kg
15	20 Kva Perkins
16	20 Litre
17	24 Port Gigabit Poe Switch
18	24F Display Monitor Screen
19	3 Door 3 Tier
20	3 Drawer Wooden
21	3M X 3M Canvas ,Zip Window & Door Easy To Pitch
22	4 Drawer Wooden
23	4 Plate Black Stove
24	426 Dw Printer
25	428 Fdw Printer
26	6 Shelves
27	6 Tier
28	65 Inch
29	8 Seater 2.1M X1.1M
30	85 Inch
31	9Kg
32	A04S Phone
33	B405Dn Mfp
34	Bathroom Scale
35	Black In Colour
36	Blue Noticeboard
37	Boardroom Table
38	Bookshelf & Cupboard
39	Cashbox
40	Cooler Box
41	Corrola
42	Desk Heater
43	Electric Heater
44	Electronic
45	Envy 360 2 In 1
46	Eos 2000D
47	Epson Projector
48	Epson Projector Screen
49	Everywhere Armless Chair
50	Everywhere Chair
51	Everywhere No Arms- Blue
52	Ford Ranger
53	Fortuner
54	Galaxy A51
55	Galaxy A51 Phone
56	Galaxy A7 Lite 8 Inch
57	Galaxy S25 Ultra
58	Galaxy Tab A9+
59	Galaxy Tablet A Tablet 8 Inch
60	Gas
61	Goldair Small Desk Fan
62	Green Notice Board
63	Green Wheelbarrow
64	Halogen
65	Hilux
66	Hisence Refridgerator
67	Hp 15- Da2197Nia
68	Hp 4303 Dw Printer
69	Hp Lasejet Pro Mfp M428Dw
70	Hp Laserjet Pro Mfp M426Fdw Printer
71	Im2702 Printer
72	Itel S16
73	Kde 6600T Yellow Diesel Generator
74	Kitchen Chair
75	Kitchen Table
76	Kitchen Unit For Plate
77	Land Cruiser
78	Laserjet 479 Printer
79	Laserjet Pro Mfp M127Fn
80	Lg Monitor 21 Inch
81	Lince 600 Model ,Black And Grey Colour
82	M27F Monitor
83	M4080Fx Printer
84	Metal
85	Metal Cabinet
86	Mfp 477Fdw Printer
87	Mfp M130 Fw Printer
88	Mfp M428Dw
89	Mfp M725Dn
90	Microwave
91	Modern 3 Drawer Mobile On Castors In Summer Oak
92	Money Counter
93	Motor Trailers To Ferry Motor Bikes
94	Mp 7503 Sp
95	Nano Trb9020 Ultra Portable Backpack X- Ray
96	Nxbc520
97	Ofcad Medicine Trunk
98	Ohv Gasoline Nx2700Dc Generator
99	Oil Heater
100	Omnibook 5
101	Outreach Fodable Chairs
102	Outreach Foldable Tables
103	Outreach Tent
104	P21B G4 Monitor 20.7 Inch
105	P37 Pro
106	Pavillion 15
107	Payroll Servor Set Monitor
108	Prado
109	Probook 450 G7
110	Rds2250 Office Shredder
111	Red Chair
112	Room Fan
113	Room Fan Room Fan
114	Round Table
115	Royal Homeware Black Heater
116	Safe
117	Scanjet Flow 7500 Scanner
118	Sharp Microwave
119	Small Projector
120	Smart Led 4K
121	Suggestion Box
122	Swivel Chair
123	Tab 1
124	Tab A 10 Inch
125	Tab A7 8 Inch
126	Table With Black Spot On Top
127	Tablet 8 Inch
128	Top Freezer 290L
129	V270 Monitors 27 Inch
130	Water Dispenser
131	White
132	White Notice Board
133	WiFi Router
134	Woden 5 Tier Cabinet
135	Wooden 3 Drawer
136	Wooden Arm Chair
137	Wooden Desk
138	Wooden Food Table
139	Wooden Height Body
140	Wooden Receiption Desk
141	Wooden Round Table
142	Wooden V Shaped
143	Xl125Lek
144	Xps 15 5910 I9
145	Xps 9350
146	Z Book
\.


--
-- TOC entry 3821 (class 0 OID 466491)
-- Dependencies: 231
-- Data for Name: placement_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.placement_types (id, name) FROM stdin;
1	Office
2	Field
3	Lent Out
4	Sent for Repair/Service
5	Other
\.


--
-- TOC entry 3837 (class 0 OID 466616)
-- Dependencies: 247
-- Data for Name: programs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.programs (id, program_code, program_name) FROM stdin;
2	MNCH	MNCH
3	SHIFT	SHIFT
4	BOOST	BOOST
5	NEOTREE	NEOTREE
1	TASQC	USAID TASQC
8	SANOFI	SANOFI
9	LSHTM	LSHTM-ZVATINODA
10	OPHID	OPHID
11	EpiC	Epidemic Control
12	TASQC-COVIDGO	USAID TASQC-COVIDGO
13	TRIPLE-P	TRIPLE-P
\.


--
-- TOC entry 3810 (class 0 OID 466439)
-- Dependencies: 220
-- Data for Name: reference_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reference_types (id, name) FROM stdin;
1	Invoice
2	Receipt
3	Goods Received Voucher
4	Other
5	Migration Note
\.


--
-- TOC entry 3845 (class 0 OID 466685)
-- Dependencies: 255
-- Data for Name: registered_assets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registered_assets (id, asset_registration_id, asset_model_id, serial_number, asset_number, condition_type_id, acquisition_value) FROM stdin;
12	12	8	SHJT77GKF6D	TASQC/USAID TASQC/Tablet/8	2	980.00
13	12	8	SFC96QR3Q9D	TASQC/USAID TASQC/Tablet/3	2	980.00
14	12	8	SFJQX4FVYH9	TASQC/USAID TASQC/Tablet/4	2	980.00
15	12	8	SG3KMV039JJ	TASQC/USAID TASQC/Tablet/5	2	980.00
16	12	8	SJ44NMC72QW	TASQC/USAID TASQC/Tablet/7	2	980.00
17	12	8	SHVF0K95Y6C	TASQC/USAID TASQC/Tablet/6	2	980.00
18	13	9	SGSN-00008	TASQC/USAID TASQC/Fire Extinguisher/37	2	10.00
19	13	9	SGSN-00009	TASQC/USAID TASQC/Fire Extinguisher/32	2	10.00
20	13	9	SGSN-00010	TASQC/USAID TASQC/Fire Extinguisher/33	2	10.00
21	13	9	SGSN-00011	TASQC/USAID TASQC/Fire Extinguisher/34	2	10.00
22	13	9	SGSN-00012	TASQC/USAID TASQC/Fire Extinguisher/13	2	10.00
23	13	9	SGSN-00013	TASQC/USAID TASQC/Fire Extinguisher/14	2	10.00
24	13	9	SGSN-00014	TASQC/USAID TASQC/Fire Extinguisher/25	2	10.00
25	13	9	SGSN-00015	TASQC/USAID TASQC/Fire Extinguisher/26	2	10.00
26	13	9	SGSN-00016	TASQC/USAID TASQC/Fire Extinguisher/4	2	10.00
27	13	9	SGSN-00017	TASQC/USAID TASQC/Fire Extinguisher/5	2	10.00
28	13	9	SGSN-00018	TASQC/USAID TASQC/Fire Extinguisher/8	2	40.00
29	13	9	SGSN-00019	TASQC/USAID TASQC/Fire Extinguisher/9	2	40.00
30	13	9	SGSN-00020	TASQC/USAID TASQC/Fire Extinguisher/52	2	45.00
31	13	9	SGSN-00021	TASQC/USAID TASQC/Fire Extinguisher/53	2	45.00
32	13	9	SGSN-00022	TASQC/USAID TASQC/Fire Extinguisher/20	8	10.00
33	13	9	SGSN-00023	TASQC/USAID TASQC/Fire Extinguisher/21	8	10.00
34	13	10	SGSN-00024	TASQC/USAID TASQC/Cabinet/92	2	110.00
35	14	11	SGSN-00025	TASQC/USAID TASQC/Cabinet/76	2	357.00
36	13	11	SGSN-00026	TASQC/USAID TASQC/Cabinet/127	2	70.00
37	15	11	SGSN-00027	TASQC/USAID TASQC/Cabinet/68	2	110.00
38	14	11	SGSN-00028	TASQC/USAID TASQC/Cabinet/72	2	357.00
39	14	11	SGSN-00029	TASQC/USAID TASQC/Cabinet/75	2	357.00
40	14	11	SGSN-00030	TASQC/USAID TASQC/Cabinet/62	2	357.00
41	13	12	SGSN-00031	TASQC/USAID TASQC/Stove/14	2	350.00
42	13	13	SGSN-00032	TASQC/USAID TASQC/Fire Extinguisher/62	2	20.00
43	13	13	SGSN-00033	TASQC/USAID TASQC/Fire Extinguisher/44	2	20.00
44	13	13	SGSN-00034	TASQC/USAID TASQC/Fire Extinguisher/61	2	20.00
45	16	14	2355/ZM	TASQC/USAID TASQC/Generator/1	2	13950.00
46	13	15	SGSN-00036	TASQC/USAID TASQC/Jerry Can/17	2	45.00
47	13	15	SGSN-00037	TASQC/USAID TASQC/Jerry Can/19	2	45.00
48	13	15	SGSN-00038	TASQC/USAID TASQC/Jerry Can/20	2	45.00
49	13	15	SGSN-00039	TASQC/USAID TASQC/Jerry Can/21	2	45.00
50	13	15	SGSN-00040	TASQC/USAID TASQC/Jerry Can/22	2	45.00
51	13	15	SGSN-00041	TASQC/USAID TASQC/Jerry Can/23	2	45.00
52	13	15	SGSN-00042	TASQC/USAID TASQC/Jerry Can/27	2	45.00
53	13	15	SGSN-00043	TASQC/USAID TASQC/Jerry Can/28	2	45.00
54	13	15	SGSN-00044	TASQC/USAID TASQC/Jerry Can/31	2	45.00
55	13	15	SGSN-00045	TASQC/USAID TASQC/Jerry Can/1	2	45.00
56	13	15	SGSN-00046	TASQC/USAID TASQC/Jerry Can/2	2	45.00
57	13	15	SGSN-00047	TASQC/USAID TASQC/Jerry Can/3	2	45.00
58	13	15	SGSN-00048	TASQC/USAID TASQC/Jerry Can/4	2	45.00
59	13	15	SGSN-00049	TASQC/USAID TASQC/Jerry Can/5	2	45.00
60	13	15	SGSN-00050	TASQC/USAID TASQC/Jerry Can/6	2	45.00
61	13	15	SGSN-00051	TASQC/USAID TASQC/Jerry Can/7	2	45.00
62	13	15	SGSN-00052	TASQC/USAID TASQC/Jerry Can/40	2	45.00
63	13	15	SGSN-00053	TASQC/USAID TASQC/Jerry Can/8	2	45.00
64	13	15	SGSN-00054	TASQC/USAID TASQC/Jerry Can/9	2	45.00
65	13	15	SGSN-00055	TASQC/USAID TASQC/Jerry Can/11	2	25.00
66	13	15	SGSN-00056	TASQC/USAID TASQC/Jerry Can/12	2	25.00
67	13	15	SGSN-00057	TASQC/USAID TASQC/Jerry Can/13	2	25.00
68	13	15	SGSN-00058	TASQC/USAID TASQC/Jerry Can/14	2	25.00
69	13	15	SGSN-00059	TASQC/USAID TASQC/Jerry Can/15	2	25.00
70	13	15	SGSN-00060	TASQC/USAID TASQC/Jerry Can/41	2	45.00
71	13	15	SGSN-00061	TASQC/USAID TASQC/Jerry Can/42	2	45.00
72	13	15	SGSN-00062	TASQC/USAID TASQC/Jerry Can/43	2	45.00
73	13	15	SGSN-00063	TASQC/USAID TASQC/Jerry Can/44	2	45.00
74	13	15	SGSN-00064	TASQC/USAID TASQC/Jerry Can/45	2	45.00
75	13	15	SGSN-00065	TASQC/USAID TASQC/Jerry Can/46	2	45.00
76	13	15	SGSN-00066	TASQC/USAID TASQC/Jerry Can/47	2	45.00
77	13	15	SGSN-00067	TASQC/USAID TASQC/Jerry Can/48	2	45.00
78	13	15	SGSN-00068	TASQC/USAID TASQC/Jerry Can/49	2	45.00
79	13	15	SGSN-00069	TASQC/USAID TASQC/Jerry Can/50	2	45.00
80	13	15	SGSN-00070	TASQC/USAID TASQC/Jerry Can/51	2	45.00
81	17	16	CA1HT42000708	TASQC/USAID TASQC/Network Switch/1	2	1458.73
82	18	17	6CM62426QF	TASQC/USAID TASQC/Monitor/20	2	292.00
83	19	18	SGSN-00073	TASQC/USAID TASQC/Desk/148	2	270.00
84	19	18	SGSN-00074	TASQC/USAID TASQC/Desk/150	2	270.00
85	19	18	SGSN-00075	TASQC/USAID TASQC/Desk/147	2	270.00
86	19	18	SGSN-00076	TASQC/USAID TASQC/Desk/149	2	270.00
87	20	18	SGSN-00077	TASQC/USAID TASQC/Desk/159	2	300.00
88	21	18	SGSN-00078	TASQC/USAID TASQC/Desk/161	2	350.00
89	13	18	SGSN-00079	TASQC/USAID TASQC/Desk/170	2	130.00
90	19	18	SGSN-00080	TASQC/USAID TASQC/Desk/146	2	270.00
91	22	18	SGSN-00081	TASQC/USAID TASQC/Desk/172	2	300.00
92	19	18	SGSN-00082	TASQC/USAID TASQC/Desk/163	2	270.00
93	19	18	SGSN-00083	TASQC/USAID TASQC/Desk/164	2	270.00
94	19	18	SGSN-00084	TASQC/USAID TASQC/Desk/165	2	270.00
95	19	18	SGSN-00085	TASQC/USAID TASQC/Desk/166	2	270.00
96	13	18	SGSN-00086	TASQC/USAID TASQC/Desk/206	2	210.00
97	13	18	SGSN-00087	TASQC/USAID TASQC/Desk/168	2	130.00
98	13	18	SGSN-00088	TASQC/USAID TASQC/Desk/171	2	130.00
99	19	18	SGSN-00089	TASQC/USAID TASQC/Desk/143	2	270.00
100	19	18	SGSN-00090	TASQC/USAID TASQC/Desk/145	2	270.00
101	23	19	SGSN-00091	TASQC/USAID TASQC/Tent/7	2	937.00
102	23	19	SGSN-00092	TASQC/USAID TASQC/Tent/8	2	937.00
103	23	19	SGSN-00093	TASQC/USAID TASQC/Tent/18	2	937.00
104	23	19	SGSN-00094	TASQC/USAID TASQC/Tent/1	2	937.00
105	23	19	SGSN-00095	TASQC/USAID TASQC/Tent/17	2	937.00
106	23	19	SGSN-00096	TASQC/USAID TASQC/Tent/15	2	937.00
107	23	19	SGSN-00097	TASQC/USAID TASQC/Tent/16	2	937.00
108	23	19	SGSN-00098	TASQC/USAID TASQC/Tent/9	2	937.00
109	23	19	SGSN-00099	TASQC/USAID TASQC/Tent/11	2	937.00
110	23	19	SGSN-00100	TASQC/USAID TASQC/Tent/12	2	937.00
111	23	19	SGSN-00101	TASQC/USAID TASQC/Tent/3	2	937.00
112	23	19	SGSN-00102	TASQC/USAID TASQC/Tent/4	2	937.00
113	21	20	SGSN-00103	TASQC/USAID TASQC/Cabinet/104	2	230.00
114	24	20	SGSN-00104	TASQC/USAID TASQC/Cabinet/73	2	351.00
115	25	20	SGSN-00105	TASQC/USAID TASQC/Cabinet/109	3	340.00
116	24	20	SGSN-00106	TASQC/USAID TASQC/Cabinet/77	2	351.00
117	24	20	SGSN-00107	TASQC/USAID TASQC/Cabinet/74	2	351.00
118	26	20	SGSN-00108	TASQC/USAID TASQC/Cabinet/61	2	320.00
119	13	20	SGSN-00109	TASQC/USAID TASQC/Cabinet/154	2	120.00
120	27	21	22122821	TASQC/USAID TASQC/Stove/11	2	634.96
121	13	22	PHBLL7N170	TASQC/USAID TASQC/Printer/24	2	500.00
122	13	22	PHBLL7N174	TASQC/USAID TASQC/Printer/13	2	500.00
123	28	22	PHBLLD2C7C	TASQC/USAID TASQC/Printer/11	2	495.01
124	29	23	CNDRQ384Y4	TASQC/USAID TASQC/Printer/29	2	675.25
125	22	23	CNBKMBV3W7	TASQC/USAID TASQC/Printer/15	2	580.00
126	13	23	CNBKMC63RX	TASQC/USAID TASQC/Printer/18	2	500.00
127	19	23	CNBKM63B9M	TASQC/USAID TASQC/Printer/12	2	500.00
128	30	24	SGSN-00118	TASQC/USAID TASQC/Cabinet/54	2	381.00
129	31	24	SGSN-00119	TASQC/USAID TASQC/Cabinet/85	2	250.00
130	32	25	SGSN-00120	TASQC/USAID TASQC/Cabinet/50	2	517.50
131	32	25	SGSN-00121	TASQC/USAID TASQC/Cabinet/51	2	517.50
132	32	25	SGSN-00122	TASQC/USAID TASQC/Cabinet/52	2	517.50
133	32	25	SGSN-00123	TASQC/USAID TASQC/Cabinet/53	2	517.50
134	32	25	SGSN-00124	TASQC/USAID TASQC/Cabinet/47	3	517.50
135	32	25	SGSN-00125	TASQC/USAID TASQC/Cabinet/48	2	517.50
136	32	25	SGSN-00126	TASQC/USAID TASQC/Cabinet/49	2	517.50
137	32	25	SGSN-00127	TASQC/USAID TASQC/Cabinet/55	2	517.50
138	32	25	SGSN-00128	TASQC/USAID TASQC/Cabinet/56	2	517.50
139	32	25	SGSN-00129	TASQC/USAID TASQC/Cabinet/57	2	517.50
140	33	26	VNW52FT3007T521	TASQC/USAID TASQC/Projector-screen/12	2	1809.10
141	34	27	SGSN-00131	TASQC/USAID TASQC/Table/1	2	224.10
142	34	27	SGSN-00132	TASQC/USAID TASQC/Table/2	2	224.10
143	34	27	SGSN-00133	TASQC/USAID TASQC/Table/10	2	224.10
144	34	27	SGSN-00134	TASQC/USAID TASQC/Table/11	2	224.10
145	34	27	SGSN-00135	TASQC/USAID TASQC/Table/4	2	224.10
146	34	27	SGSN-00136	TASQC/USAID TASQC/Table/5	2	224.10
147	34	27	SGSN-00137	TASQC/USAID TASQC/Table/12	2	224.10
148	34	27	SGSN-00138	TASQC/USAID TASQC/Table/13	2	224.10
149	34	27	SGSN-00139	TASQC/USAID TASQC/Table/6	2	224.10
150	35	28	SGSN-00140	TASQC/USAID TASQC/Projector-screen/15	2	2950.00
151	36	28	00YN3FAN200234	TASQC/USAID TASQC/Projector-screen/11	2	3790.00
152	13	29	SGSN-00142	TASQC/USAID TASQC/Fire Extinguisher/48	2	45.00
153	13	29	SGSN-00143	TASQC/USAID TASQC/Fire Extinguisher/50	2	45.00
154	13	29	SGSN-00144	TASQC/USAID TASQC/Fire Extinguisher/15	8	40.00
155	13	29	SGSN-00145	TASQC/USAID TASQC/Fire Extinguisher/16	8	40.00
156	13	29	SGSN-00146	TASQC/USAID TASQC/Fire Extinguisher/47	2	45.00
157	13	29	SGSN-00147	TASQC/USAID TASQC/Fire Extinguisher/49	2	45.00
158	13	29	SGSN-00148	TASQC/USAID TASQC/Fire Extinguisher/51	2	45.00
159	37	29	SGSN-00149	TASQC/USAID TASQC/Fire Extinguisher/64	2	45.00
160	13	29	SGSN-00150	TASQC/USAID TASQC/Fire Extinguisher/27	2	45.00
161	13	29	SGSN-00151	TASQC/USAID TASQC/Fire Extinguisher/29	2	45.00
162	13	29	SGSN-00152	TASQC/USAID TASQC/Fire Extinguisher/30	2	45.00
163	13	29	SGSN-00153	TASQC/USAID TASQC/Fire Extinguisher/31	2	45.00
164	13	29	SGSN-00154	TASQC/USAID TASQC/Fire Extinguisher/10	2	40.00
165	13	29	SGSN-00155	TASQC/USAID TASQC/Fire Extinguisher/11	2	40.00
166	13	29	SGSN-00156	TASQC/USAID TASQC/Fire Extinguisher/12	2	40.00
167	13	29	SGSN-00157	TASQC/USAID TASQC/Fire Extinguisher/22	2	40.00
168	13	29	SGSN-00158	TASQC/USAID TASQC/Fire Extinguisher/23	2	40.00
169	13	29	SGSN-00159	TASQC/USAID TASQC/Fire Extinguisher/24	2	40.00
170	13	29	SGSN-00160	TASQC/USAID TASQC/Fire Extinguisher/39	2	45.00
171	13	29	SGSN-00161	TASQC/USAID TASQC/Fire Extinguisher/40	2	45.00
172	13	29	SGSN-00162	TASQC/USAID TASQC/Fire Extinguisher/41	2	45.00
173	13	29	SGSN-00163	TASQC/USAID TASQC/Fire Extinguisher/42	2	45.00
174	13	29	SGSN-00164	TASQC/USAID TASQC/Fire Extinguisher/43	2	45.00
175	13	29	SGSN-00165	TASQC/USAID TASQC/Fire Extinguisher/6	2	40.00
176	13	29	SGSN-00166	TASQC/USAID TASQC/Fire Extinguisher/7	2	40.00
177	13	29	SGSN-00167	TASQC/USAID TASQC/Fire Extinguisher/1	2	40.00
178	13	29	SGSN-00168	TASQC/USAID TASQC/Fire Extinguisher/2	2	40.00
179	13	29	SGSN-00169	TASQC/USAID TASQC/Fire Extinguisher/3	2	40.00
180	13	29	SGSN-00170	TASQC/USAID TASQC/Fire Extinguisher/45	2	20.00
181	13	29	SGSN-00171	TASQC/USAID TASQC/Fire Extinguisher/46	2	45.00
182	13	29	SGSN-00172	TASQC/USAID TASQC/Fire Extinguisher/17	8	40.00
183	13	29	SGSN-00173	TASQC/USAID TASQC/Fire Extinguisher/55	2	40.00
184	13	29	SGSN-00174	TASQC/USAID TASQC/Fire Extinguisher/56	2	40.00
185	13	29	SGSN-00175	TASQC/USAID TASQC/Fire Extinguisher/57	2	40.00
186	13	29	SGSN-00176	TASQC/USAID TASQC/Fire Extinguisher/59	2	40.00
187	13	29	SGSN-00177	TASQC/USAID TASQC/Fire Extinguisher/60	2	40.00
188	37	29	SGSN-00178	TASQC/USAID TASQC/Fire Extinguisher/63	2	45.00
189	38	30	356769545841876	TASQC/USAID TASQC/Cell-Phone/865	3	165.00
190	39	30	350246952900111	TASQC/USAID TASQC/Cell-Phone/720	2	172.50
191	39	30	350246952911761	TASQC/USAID TASQC/Cell-Phone/785	3	172.50
192	39	30	350246952896814	TASQC/USAID TASQC/Cell-Phone/762	2	172.50
193	39	30	350246952919269	TASQC/USAID TASQC/Cell-Phone/770	2	172.50
194	39	30	350246952924897	TASQC/USAID TASQC/Cell-Phone/759	2	172.50
195	39	30	350246952921604	TASQC/USAID TASQC/Cell-Phone/653	2	172.50
196	39	30	350246952896491	TASQC/USAID TASQC/Cell-Phone/771	2	172.50
197	39	30	358799697672397	TASQC/USAID TASQC/Cell-Phone/743	2	172.50
198	39	30	350246952922214	TASQC/USAID TASQC/Cell-Phone/822	2	172.50
199	39	30	350246952472129	TASQC/USAID TASQC/Cell-Phone/830	2	172.50
200	38	30	356769545852014	TASQC/USAID TASQC/Cell-Phone/839	8	165.00
201	39	30	358799697672793	TASQC/USAID TASQC/Cell-Phone/671	2	172.50
202	38	30	356769545847220	TASQC/USAID TASQC/Cell-Phone/819	2	165.00
203	39	30	350246952467533	TASQC/USAID TASQC/Cell-Phone/773	3	172.50
204	39	30	358799697673007	TASQC/USAID TASQC/Cell-Phone/727	2	172.50
205	40	30	350246952924525	TASQC/USAID TASQC/Cell-Phone/613	2	172.50
206	39	30	350246952921463	TASQC/USAID TASQC/Cell-Phone/755	2	172.50
207	39	30	350246952474257	TASQC/USAID TASQC/Cell-Phone/641	2	172.50
208	39	30	350246952926199	TASQC/USAID TASQC/Cell-Phone/639	2	172.50
209	40	30	350246952921513	TASQC/USAID TASQC/Cell-Phone/634	2	172.50
210	39	30	350246952473952	TASQC/USAID TASQC/Cell-Phone/775	3	172.50
211	40	30	350246952911571	TASQC/USAID TASQC/Cell-Phone/621	2	172.50
212	39	30	350246952923097	TASQC/USAID TASQC/Cell-Phone/664	2	172.50
213	40	30	350246952897648	TASQC/USAID TASQC/Cell-Phone/629	2	172.50
214	39	30	350246952917685	TASQC/USAID TASQC/Cell-Phone/691	2	172.50
215	39	30	358799697673171	TASQC/USAID TASQC/Cell-Phone/695	2	172.50
216	38	30	356769545865149	TASQC/USAID TASQC/Cell-Phone/903	8	165.00
217	39	30	350246952921729	TASQC/USAID TASQC/Cell-Phone/658	2	172.50
218	39	30	350246952899313	TASQC/USAID TASQC/Cell-Phone/838	2	172.50
219	39	30	350246952897564	TASQC/USAID TASQC/Cell-Phone/681	2	172.50
220	39	30	358799697670250	TASQC/USAID TASQC/Cell-Phone/735	2	172.50
221	39	30	350246952919285	TASQC/USAID TASQC/Cell-Phone/861	2	172.50
222	39	30	350246952900129	TASQC/USAID TASQC/Cell-Phone/707	2	172.50
223	39	30	350246952509748	TASQC/USAID TASQC/Cell-Phone/787	3	172.50
224	39	30	350246952923295	TASQC/USAID TASQC/Cell-Phone/766	2	172.50
225	39	30	358799697673056	TASQC/USAID TASQC/Cell-Phone/772	2	172.50
226	39	30	350246952915168	TASQC/USAID TASQC/Cell-Phone/754	2	172.50
227	39	30	350246952924400	TASQC/USAID TASQC/Cell-Phone/798	3	172.50
228	39	30	350246952919202	TASQC/USAID TASQC/Cell-Phone/662	2	172.50
229	39	30	358799697668999	TASQC/USAID TASQC/Cell-Phone/736	2	172.50
230	39	30	350246952924475	TASQC/USAID TASQC/Cell-Phone/703	2	172.50
231	39	30	350246952923410	TASQC/USAID TASQC/Cell-Phone/805	3	172.50
232	39	30	350246952894694	TASQC/USAID TASQC/Cell-Phone/750	2	172.50
233	38	30	356769545854077	TASQC/USAID TASQC/Cell-Phone/893	8	165.00
234	39	30	350246952919277	TASQC/USAID TASQC/Cell-Phone/783	3	172.50
235	39	30	350246952464712	TASQC/USAID TASQC/Cell-Phone/844	2	172.50
236	39	30	350246952923329	TASQC/USAID TASQC/Cell-Phone/769	2	172.50
237	39	30	350246952471750	TASQC/USAID TASQC/Cell-Phone/748	2	172.50
238	39	30	350246952898588	TASQC/USAID TASQC/Cell-Phone/807	3	172.50
239	38	30	356769545839953	TASQC/USAID TASQC/Cell-Phone/850	3	165.00
240	39	30	358799697671969	TASQC/USAID TASQC/Cell-Phone/744	2	172.50
241	39	30	358799697673973	TASQC/USAID TASQC/Cell-Phone/642	2	172.50
242	40	30	350246952901507	TASQC/USAID TASQC/Cell-Phone/618	2	172.50
243	39	30	350246952900095	TASQC/USAID TASQC/Cell-Phone/777	3	172.50
244	39	30	358799697673585	TASQC/USAID TASQC/Cell-Phone/644	2	172.50
245	39	30	358799697670409	TASQC/USAID TASQC/Cell-Phone/745	2	172.50
246	39	30	358799697673635	TASQC/USAID TASQC/Cell-Phone/655	2	172.50
247	39	30	350246952924772	TASQC/USAID TASQC/Cell-Phone/712	2	172.50
248	39	30	350246952913619	TASQC/USAID TASQC/Cell-Phone/706	2	172.50
249	38	30	350246954031378	TASQC/USAID TASQC/Cell-Phone/876	3	165.00
250	39	30	358799697673965	TASQC/USAID TASQC/Cell-Phone/705	2	172.50
251	39	30	358799697676026	TASQC/USAID TASQC/Cell-Phone/801	3	172.50
252	39	30	350246952925050	TASQC/USAID TASQC/Cell-Phone/637	2	172.50
253	39	30	358799697672660	TASQC/USAID TASQC/Cell-Phone/659	2	172.50
254	39	30	350246952923212	TASQC/USAID TASQC/Cell-Phone/683	2	172.50
255	39	30	358799697674666	TASQC/USAID TASQC/Cell-Phone/880	2	172.50
256	39	30	350246952924988	TASQC/USAID TASQC/Cell-Phone/834	2	172.50
257	39	30	358799697675085	TASQC/USAID TASQC/Cell-Phone/657	2	172.50
258	39	30	350246952916075	TASQC/USAID TASQC/Cell-Phone/688	2	172.50
259	39	30	350246952466725	TASQC/USAID TASQC/Cell-Phone/804	3	172.50
260	39	30	358799697679403	TASQC/USAID TASQC/Cell-Phone/778	3	172.50
261	39	30	350246952926132	TASQC/USAID TASQC/Cell-Phone/767	2	172.50
262	40	30	350246952922966	TASQC/USAID TASQC/Cell-Phone/620	2	172.50
263	39	30	358799697672843	TASQC/USAID TASQC/Cell-Phone/697	2	172.50
264	39	30	358799697669062	TASQC/USAID TASQC/Cell-Phone/733	2	172.50
265	38	30	350246954029315	TASQC/USAID TASQC/Cell-Phone/883	8	165.00
266	39	30	350246952911696	TASQC/USAID TASQC/Cell-Phone/717	2	172.50
267	39	30	358799697669955	TASQC/USAID TASQC/Cell-Phone/738	2	172.50
268	38	30	356769545841579	TASQC/USAID TASQC/Cell-Phone/811	2	165.00
269	39	30	350246952921745	TASQC/USAID TASQC/Cell-Phone/831	2	172.50
270	39	30	350246952919251	TASQC/USAID TASQC/Cell-Phone/779	3	172.50
271	39	30	358799697673395	TASQC/USAID TASQC/Cell-Phone/708	2	172.50
272	38	30	350246954035163	TASQC/USAID TASQC/Cell-Phone/874	2	165.00
273	39	30	358799697669591	TASQC/USAID TASQC/Cell-Phone/737	2	172.50
274	39	30	350246952920986	TASQC/USAID TASQC/Cell-Phone/710	2	172.50
275	39	30	350246952473309	TASQC/USAID TASQC/Cell-Phone/668	2	172.50
276	39	30	358799697675598	TASQC/USAID TASQC/Cell-Phone/749	2	172.50
277	39	30	350246952924376	TASQC/USAID TASQC/Cell-Phone/760	2	172.50
278	39	30	350246952899438	TASQC/USAID TASQC/Cell-Phone/864	2	172.50
279	39	30	350246952921778	TASQC/USAID TASQC/Cell-Phone/825	2	172.50
280	39	30	350246952921000	TASQC/USAID TASQC/Cell-Phone/722	2	172.50
281	39	30	350246952901721	TASQC/USAID TASQC/Cell-Phone/666	2	172.50
282	39	30	350246952900236	TASQC/USAID TASQC/Cell-Phone/870	2	172.50
283	39	30	358799697670375	TASQC/USAID TASQC/Cell-Phone/650	2	172.50
284	39	30	350246952904881	TASQC/USAID TASQC/Cell-Phone/672	2	172.50
285	38	30	356769545855645	TASQC/USAID TASQC/Cell-Phone/884	8	165.00
286	39	30	350246952916042	TASQC/USAID TASQC/Cell-Phone/716	2	172.50
287	39	30	353931242900206	TASQC/USAID TASQC/Cell-Phone/663	2	172.50
288	39	30	358799697673122	TASQC/USAID TASQC/Cell-Phone/685	2	172.50
289	39	30	358799697671985	TASQC/USAID TASQC/Cell-Phone/651	2	172.50
290	39	30	350246952464845	TASQC/USAID TASQC/Cell-Phone/768	2	172.50
291	39	30	350246952898562	TASQC/USAID TASQC/Cell-Phone/813	2	172.50
292	39	30	358799697675200	TASQC/USAID TASQC/Cell-Phone/747	2	172.50
293	39	30	350246952919152	TASQC/USAID TASQC/Cell-Phone/820	2	172.50
294	39	30	358799697671571	TASQC/USAID TASQC/Cell-Phone/649	2	172.50
295	38	30	356769545842429	TASQC/USAID TASQC/Cell-Phone/886	8	165.00
296	39	30	358799697675051	TASQC/USAID TASQC/Cell-Phone/848	2	172.50
297	38	30	356769545857864	TASQC/USAID TASQC/Cell-Phone/833	8	165.00
298	38	30	356769545841686	TASQC/USAID TASQC/Cell-Phone/855	8	165.00
299	38	30	350246954033663	TASQC/USAID TASQC/Cell-Phone/872	8	165.00
300	39	30	350246952920903	TASQC/USAID TASQC/Cell-Phone/721	2	172.50
301	39	30	350246952475171	TASQC/USAID TASQC/Cell-Phone/701	2	172.50
302	39	30	350246952927718	TASQC/USAID TASQC/Cell-Phone/709	2	172.50
303	38	30	356769545840373	TASQC/USAID TASQC/Cell-Phone/824	2	165.00
304	40	30	350246952463631	TASQC/USAID TASQC/Cell-Phone/630	2	172.50
305	39	30	358799697672769	TASQC/USAID TASQC/Cell-Phone/788	3	172.50
306	38	30	350246953951402	TASQC/USAID TASQC/Cell-Phone/878	2	165.00
307	38	30	356769545857583	TASQC/USAID TASQC/Cell-Phone/832	2	165.00
308	40	30	350246952920499	TASQC/USAID TASQC/Cell-Phone/632	2	172.50
309	39	30	350246952911548	TASQC/USAID TASQC/Cell-Phone/640	2	172.50
310	39	30	350246952927544	TASQC/USAID TASQC/Cell-Phone/756	2	172.50
311	39	30	350246952906316	TASQC/USAID TASQC/Cell-Phone/692	2	172.50
312	39	30	350246952904360	TASQC/USAID TASQC/Cell-Phone/857	2	172.50
313	38	30	356769545842403	TASQC/USAID TASQC/Cell-Phone/895	2	165.00
314	38	30	356769545850000	TASQC/USAID TASQC/Cell-Phone/905	2	165.00
315	41	31	3719711366	TASQC/USAID TASQC/Printer/36	2	2000.00
316	42	31	3719704017	TASQC/USAID TASQC/Printer/5	2	2000.00
317	43	32	SGSN-00307	SANOFI/SANOFI/Scale/21	8	207.82
318	43	32	SGSN-00308	SANOFI/SANOFI/Scale/22	8	207.82
319	43	32	SGSN-00309	SANOFI/SANOFI/Scale/26	8	207.82
320	43	32	SGSN-00310	SANOFI/SANOFI/Scale/19	2	207.82
321	13	33	PM1736305470	TASQC/USAID TASQC/Shredder/3	2	600.00
322	44	33	SGSN-00312	TASQC/USAID TASQC/Shredder/2	2	1800.00
323	13	34	SGSN-00313	TASQC/USAID TASQC/Notice Board/30	2	70.00
324	13	34	SGSN-00314	TASQC/USAID TASQC/Notice Board/29	2	70.00
325	45	35	SGSN-00315	TASQC/USAID TASQC/Desk/135	2	825.00
326	13	36	SGSN-00316	TASQC/USAID TASQC/Cabinet/91	2	100.00
327	22	36	SGSN-00317	TASQC/USAID TASQC/Cabinet/90	2	200.00
328	22	36	SGSN-00318	TASQC/USAID TASQC/Cabinet/94	2	200.00
329	19	36	SGSN-00319	TASQC/USAID TASQC/Cabinet/95	2	110.00
330	13	36	SGSN-00320	TASQC/USAID TASQC/Cabinet/88	2	100.00
331	13	37	SGSN-00321	TASQC/USAID TASQC/Cash Box/1	2	150.00
332	13	38	SGSN-00322	TASQC/USAID TASQC/Cooler Box/10	2	45.00
333	13	38	SGSN-00323	TASQC/USAID TASQC/Cooler Box/11	2	45.00
334	13	38	SGSN-00324	TASQC/USAID TASQC/Cooler Box/12	2	45.00
335	13	38	SGSN-00325	TASQC/USAID TASQC/Cooler Box/13	2	45.00
336	13	38	SGSN-00326	TASQC/USAID TASQC/Cooler Box/14	2	45.00
337	13	38	SGSN-00327	TASQC/USAID TASQC/Cooler Box/8	2	45.00
338	13	38	SGSN-00328	TASQC/USAID TASQC/Cooler Box/9	2	45.00
339	13	38	SGSN-00329	TASQC/USAID TASQC/Cooler Box/6	2	45.00
340	13	38	SGSN-00330	TASQC/USAID TASQC/Cooler Box/17	2	45.00
341	13	38	SGSN-00331	TASQC/USAID TASQC/Cooler Box/18	2	45.00
342	13	38	SGSN-00332	TASQC/USAID TASQC/Cooler Box/19	2	45.00
343	13	38	SGSN-00333	TASQC/USAID TASQC/Cooler Box/20	2	45.00
344	46	39	AFS6354	TASQC/USAID TASQC/Vehicle/79	2	23500.00
345	13	40	SGSN-00335	TASQC/USAID TASQC/Heater/47	2	40.00
346	13	40	SGSN-00336	TASQC/USAID TASQC/Heater/113	2	35.00
347	13	40	SGSN-00337	TASQC/USAID TASQC/Heater/114	2	35.00
348	13	40	SGSN-00338	TASQC/USAID TASQC/Heater/32	2	50.00
349	13	40	SGSN-00339	TASQC/USAID TASQC/Heater/112	2	35.00
350	13	41	SGSN-00340	TASQC/USAID TASQC/Heater/20	2	35.00
351	13	41	SGSN-00341	TASQC/USAID TASQC/Heater/86	3	50.00
352	13	41	SGSN-00342	TASQC/USAID TASQC/Heater/85	3	50.00
353	13	41	SGSN-00343	TASQC/USAID TASQC/Heater/21	2	35.00
354	13	41	SGSN-00344	TASQC/USAID TASQC/Heater/43	2	50.00
355	13	41	SGSN-00345	TASQC/USAID TASQC/Heater/41	2	50.00
356	13	41	SGSN-00346	TASQC/USAID TASQC/Heater/91	8	45.00
357	13	41	SGSN-00347	TASQC/USAID TASQC/Heater/40	2	50.00
358	13	41	SGSN-00348	TASQC/USAID TASQC/Heater/87	3	50.00
359	47	41	SGSN-00349	TASQC/USAID TASQC/Heater/119	2	12.00
360	13	42	SGSN-00350	TASQC/USAID TASQC/Stove/12	2	500.00
361	48	42	2130904020A0265	TASQC/USAID TASQC/Stove/2	2	550.00
362	48	42	2130904020A0273	TASQC/USAID TASQC/Stove/4	2	550.00
363	48	42	2130904020A0294	TASQC/USAID TASQC/Stove/5	2	550.00
364	48	42	2130904020A0256	TASQC/USAID TASQC/Stove/6	2	550.00
365	48	42	2130904020A0250	TASQC/USAID TASQC/Stove/3	2	550.00
366	49	42	2130904020A0234	TASQC/USAID TASQC/Stove/1	2	550.00
367	50	43	CND4392CKH	LSHTM/LSHTM-ZVATINODA/Laptop/487	8	1782.50
368	51	43	CND43712PJ	TASQC/USAID TASQC/Laptop/488	2	1782.50
369	52	44	3616C011	TASQC/USAID TASQC/Camera/3	2	2300.00
370	13	45	X4K20700010	TASQC/USAID TASQC/Projector/7	2	500.00
371	13	45	X4K20700053	TASQC/USAID TASQC/Projector/8	2	600.00
372	53	45	wduk640083	TASQC/USAID TASQC/Projector/4	2	250.00
373	53	45	X4K20700081	TASQC/USAID TASQC/Projector/5	2	250.00
374	53	45	X4K20700002	TASQC/USAID TASQC/Projector/6	2	250.00
375	13	45	X8AL0701539	TASQC/USAID TASQC/Projector/9	2	1000.00
376	54	45	X6652Y01703	TASQC/USAID TASQC/Projector/10	2	1995.00
377	13	46	SGSN-00367	TASQC/USAID TASQC/Projector-screen/13	2	300.00
378	55	47	SGSN-00368	TASQC/USAID TASQC/Chair/87	2	105.00
379	55	47	SGSN-00369	TASQC/USAID TASQC/Chair/89	2	105.00
380	55	47	SGSN-00370	TASQC/USAID TASQC/Chair/130	2	105.00
381	55	47	SGSN-00371	TASQC/USAID TASQC/Chair/131	2	105.00
382	55	47	SGSN-00372	TASQC/USAID TASQC/Chair/68	2	105.00
383	55	47	SGSN-00373	TASQC/USAID TASQC/Chair/69	2	105.00
384	55	47	SGSN-00374	TASQC/USAID TASQC/Chair/90	2	105.00
385	55	47	SGSN-00375	TASQC/USAID TASQC/Chair/118	2	105.00
386	55	47	SGSN-00376	TASQC/USAID TASQC/Chair/119	2	105.00
387	55	47	SGSN-00377	TASQC/USAID TASQC/Chair/120	2	105.00
388	55	47	SGSN-00378	TASQC/USAID TASQC/Chair/121	2	105.00
389	55	47	SGSN-00379	TASQC/USAID TASQC/Chair/122	2	105.00
390	55	47	SGSN-00380	TASQC/USAID TASQC/Chair/123	2	105.00
391	55	47	SGSN-00381	TASQC/USAID TASQC/Chair/124	2	105.00
392	55	47	SGSN-00382	TASQC/USAID TASQC/Chair/126	2	105.00
393	55	47	SGSN-00383	TASQC/USAID TASQC/Chair/70	2	105.00
394	13	47	SGSN-00384	TASQC/USAID TASQC/Chair/331	2	110.00
395	13	47	SGSN-00385	TASQC/USAID TASQC/Chair/334	2	110.00
396	13	47	SGSN-00386	TASQC/USAID TASQC/Chair/335	2	110.00
397	13	47	SGSN-00387	TASQC/USAID TASQC/Chair/336	2	110.00
398	13	47	SGSN-00388	TASQC/USAID TASQC/Chair/337	2	110.00
399	13	47	SGSN-00389	TASQC/USAID TASQC/Chair/338	2	110.00
400	13	47	SGSN-00390	TASQC/USAID TASQC/Chair/414	2	110.00
401	13	47	SGSN-00391	TASQC/USAID TASQC/Chair/328	2	110.00
402	13	47	SGSN-00392	TASQC/USAID TASQC/Chair/361	2	110.00
403	56	47	SGSN-00393	TASQC/USAID TASQC/Chair/478	8	95.00
404	55	47	SGSN-00394	TASQC/USAID TASQC/Chair/88	2	105.00
405	13	47	SGSN-00395	TASQC/USAID TASQC/Chair/332	2	110.00
406	55	47	SGSN-00396	TASQC/USAID TASQC/Chair/58	2	105.00
407	55	47	SGSN-00397	TASQC/USAID TASQC/Chair/60	2	105.00
408	55	47	SGSN-00398	TASQC/USAID TASQC/Chair/62	2	105.00
409	55	47	SGSN-00399	TASQC/USAID TASQC/Chair/63	2	105.00
410	55	47	SGSN-00400	TASQC/USAID TASQC/Chair/64	2	105.00
411	55	47	SGSN-00401	TASQC/USAID TASQC/Chair/65	2	105.00
412	13	47	SGSN-00402	TASQC/USAID TASQC/Chair/1070	2	110.00
413	55	47	SGSN-00403	TASQC/USAID TASQC/Chair/73	2	105.00
414	55	47	SGSN-00404	TASQC/USAID TASQC/Chair/77	2	105.00
415	55	47	SGSN-00405	TASQC/USAID TASQC/Chair/76	2	105.00
416	55	47	SGSN-00406	TASQC/USAID TASQC/Chair/80	2	105.00
417	55	47	SGSN-00407	TASQC/USAID TASQC/Chair/95	2	105.00
418	55	47	SGSN-00408	TASQC/USAID TASQC/Chair/97	2	105.00
419	55	47	SGSN-00409	TASQC/USAID TASQC/Chair/99	2	105.00
420	55	47	SGSN-00410	TASQC/USAID TASQC/Chair/115	2	105.00
421	55	47	SGSN-00411	TASQC/USAID TASQC/Chair/133	2	105.00
422	55	47	SGSN-00412	TASQC/USAID TASQC/Chair/134	2	105.00
423	55	47	SGSN-00413	TASQC/USAID TASQC/Chair/135	2	105.00
424	22	47	SGSN-00414	TASQC/USAID TASQC/Chair/465	2	190.00
425	22	47	SGSN-00415	TASQC/USAID TASQC/Chair/469	2	580.00
426	55	47	SGSN-00416	TASQC/USAID TASQC/Chair/96	2	105.00
427	55	47	SGSN-00417	TASQC/USAID TASQC/Chair/98	2	105.00
428	55	47	SGSN-00418	TASQC/USAID TASQC/Chair/127	2	105.00
429	55	47	SGSN-00419	TASQC/USAID TASQC/Chair/54	2	105.00
430	13	47	SGSN-00420	TASQC/USAID TASQC/Chair/352	2	110.00
431	55	47	SGSN-00421	TASQC/USAID TASQC/Chair/132	2	105.00
432	22	47	SGSN-00422	TASQC/USAID TASQC/Chair/470	2	580.00
433	22	47	SGSN-00423	TASQC/USAID TASQC/Chair/471	2	580.00
434	21	47	SGSN-00424	TASQC/USAID TASQC/Chair/472	2	180.00
435	21	47	SGSN-00425	TASQC/USAID TASQC/Chair/473	2	180.00
436	13	47	SGSN-00426	TASQC/USAID TASQC/Chair/329	2	110.00
437	55	47	SGSN-00427	TASQC/USAID TASQC/Chair/100	2	105.00
438	55	47	SGSN-00428	TASQC/USAID TASQC/Chair/101	2	105.00
439	55	47	SGSN-00429	TASQC/USAID TASQC/Chair/102	2	105.00
440	55	47	SGSN-00430	TASQC/USAID TASQC/Chair/104	2	105.00
441	55	47	SGSN-00431	TASQC/USAID TASQC/Chair/105	2	105.00
442	55	47	SGSN-00432	TASQC/USAID TASQC/Chair/106	2	105.00
443	55	47	SGSN-00433	TASQC/USAID TASQC/Chair/107	2	105.00
444	55	47	SGSN-00434	TASQC/USAID TASQC/Chair/108	2	105.00
445	55	47	SGSN-00435	TASQC/USAID TASQC/Chair/111	2	105.00
446	55	47	SGSN-00436	TASQC/USAID TASQC/Chair/112	2	105.00
447	55	47	SGSN-00437	TASQC/USAID TASQC/Chair/113	2	105.00
448	55	47	SGSN-00438	TASQC/USAID TASQC/Chair/114	2	105.00
449	56	47	SGSN-00439	TASQC/USAID TASQC/Chair/475	2	95.00
450	56	47	SGSN-00440	TASQC/USAID TASQC/Chair/476	8	95.00
451	56	47	SGSN-00441	TASQC/USAID TASQC/Chair/477	8	95.00
452	56	47	SGSN-00442	TASQC/USAID TASQC/Chair/479	8	95.00
453	56	47	SGSN-00443	TASQC/USAID TASQC/Chair/480	8	95.00
454	56	47	SGSN-00444	TASQC/USAID TASQC/Chair/482	8	95.00
455	55	47	SGSN-00445	TASQC/USAID TASQC/Chair/129	2	105.00
456	13	47	SGSN-00446	TASQC/USAID TASQC/Chair/389	2	110.00
457	13	47	SGSN-00447	TASQC/USAID TASQC/Chair/391	2	110.00
458	13	47	SGSN-00448	TASQC/USAID TASQC/Chair/415	2	110.00
459	13	47	SGSN-00449	TASQC/USAID TASQC/Chair/416	2	110.00
460	13	47	SGSN-00450	TASQC/USAID TASQC/Chair/418	2	110.00
461	13	47	SGSN-00451	TASQC/USAID TASQC/Chair/420	2	110.00
462	55	47	SGSN-00452	TASQC/USAID TASQC/Chair/67	2	105.00
463	13	47	SGSN-00453	TASQC/USAID TASQC/Chair/303	2	110.00
464	55	47	SGSN-00454	TASQC/USAID TASQC/Chair/85	2	105.00
465	55	47	SGSN-00455	TASQC/USAID TASQC/Chair/86	2	105.00
466	13	47	SGSN-00456	TASQC/USAID TASQC/Chair/317	2	110.00
467	55	47	SGSN-00457	TASQC/USAID TASQC/Chair/51	2	105.00
468	55	47	SGSN-00458	TASQC/USAID TASQC/Chair/52	2	105.00
469	55	47	SGSN-00459	TASQC/USAID TASQC/Chair/53	2	105.00
470	55	47	SGSN-00460	TASQC/USAID TASQC/Chair/55	2	105.00
471	55	47	SGSN-00461	TASQC/USAID TASQC/Chair/56	2	105.00
472	13	47	SGSN-00462	TASQC/USAID TASQC/Chair/395	2	110.00
473	13	47	SGSN-00463	TASQC/USAID TASQC/Chair/408	2	110.00
474	13	47	SGSN-00464	TASQC/USAID TASQC/Chair/409	2	110.00
475	13	47	SGSN-00465	TASQC/USAID TASQC/Chair/411	2	110.00
476	13	47	SGSN-00466	TASQC/USAID TASQC/Chair/412	2	110.00
477	13	47	SGSN-00467	TASQC/USAID TASQC/Chair/413	2	110.00
478	13	47	SGSN-00468	TASQC/USAID TASQC/Chair/354	2	110.00
479	13	47	SGSN-00469	TASQC/USAID TASQC/Chair/390	2	110.00
480	13	47	SGSN-00470	TASQC/USAID TASQC/Chair/419	2	110.00
481	55	47	SGSN-00471	TASQC/USAID TASQC/Chair/75	2	105.00
482	13	47	SGSN-00472	TASQC/USAID TASQC/Chair/299	2	110.00
483	13	47	SGSN-00473	TASQC/USAID TASQC/Chair/301	2	110.00
484	13	47	SGSN-00474	TASQC/USAID TASQC/Chair/302	2	110.00
485	13	47	SGSN-00475	TASQC/USAID TASQC/Chair/357	2	110.00
486	13	47	SGSN-00476	TASQC/USAID TASQC/Chair/358	2	110.00
487	13	47	SGSN-00477	TASQC/USAID TASQC/Chair/363	2	110.00
488	13	47	SGSN-00478	TASQC/USAID TASQC/Chair/345	2	110.00
489	13	47	SGSN-00479	TASQC/USAID TASQC/Chair/355	2	110.00
490	13	48	SGSN-00480	TASQC/USAID TASQC/Chair/459	2	110.00
491	13	48	SGSN-00481	TASQC/USAID TASQC/Chair/460	2	110.00
492	13	48	SGSN-00482	TASQC/USAID TASQC/Chair/341	2	110.00
493	13	48	SGSN-00483	TASQC/USAID TASQC/Chair/343	2	110.00
494	13	48	SGSN-00484	TASQC/USAID TASQC/Chair/353	2	110.00
495	22	48	SGSN-00485	TASQC/USAID TASQC/Chair/467	2	145.00
496	22	48	SGSN-00486	TASQC/USAID TASQC/Chair/468	2	145.00
497	13	48	SGSN-00487	TASQC/USAID TASQC/Chair/421	2	110.00
498	13	48	SGSN-00488	TASQC/USAID TASQC/Chair/486	2	110.00
499	13	48	SGSN-00489	TASQC/USAID TASQC/Chair/422	2	110.00
500	13	48	SGSN-00490	TASQC/USAID TASQC/Chair/342	2	110.00
501	13	48	SGSN-00491	TASQC/USAID TASQC/Chair/350	2	110.00
502	13	48	SGSN-00492	TASQC/USAID TASQC/Chair/346	2	110.00
503	13	48	SGSN-00493	TASQC/USAID TASQC/Chair/347	2	110.00
504	13	48	SGSN-00494	TASQC/USAID TASQC/Chair/348	2	110.00
505	13	48	SGSN-00495	TASQC/USAID TASQC/Chair/349	2	110.00
506	13	48	SGSN-00496	TASQC/USAID TASQC/Chair/340	2	110.00
507	13	49	SGSN-00497	TASQC/USAID TASQC/Chair/320	2	110.00
508	13	49	SGSN-00498	TASQC/USAID TASQC/Chair/306	2	110.00
509	22	49	SGSN-00499	TASQC/USAID TASQC/Chair/442	2	180.00
510	13	49	SGSN-00500	TASQC/USAID TASQC/Chair/308	2	110.00
511	13	49	SGSN-00501	TASQC/USAID TASQC/Chair/324	2	110.00
512	13	49	SGSN-00502	TASQC/USAID TASQC/Chair/313	2	110.00
513	13	49	SGSN-00503	TASQC/USAID TASQC/Chair/319	2	110.00
514	13	49	SGSN-00504	TASQC/USAID TASQC/Chair/322	2	110.00
515	13	49	SGSN-00505	TASQC/USAID TASQC/Chair/316	2	110.00
516	13	49	SGSN-00506	TASQC/USAID TASQC/Chair/304	2	110.00
517	13	49	SGSN-00507	TASQC/USAID TASQC/Chair/307	2	110.00
518	13	49	SGSN-00508	TASQC/USAID TASQC/Chair/309	2	110.00
519	13	49	SGSN-00509	TASQC/USAID TASQC/Chair/310	2	110.00
520	13	49	SGSN-00510	TASQC/USAID TASQC/Chair/314	2	110.00
521	13	49	SGSN-00511	TASQC/USAID TASQC/Chair/315	2	110.00
522	13	49	SGSN-00512	TASQC/USAID TASQC/Chair/318	2	110.00
523	13	49	SGSN-00513	TASQC/USAID TASQC/Chair/323	2	110.00
524	13	49	SGSN-00514	TASQC/USAID TASQC/Chair/321	2	110.00
525	57	50	ADR6580	TASQC/USAID TASQC/Vehicle/88	8	53333.43
526	58	51	AGE4456	OPHID/OPHID/Vehicle/61	2	43940.00
527	58	51	AGE6048	OPHID/OPHID/Vehicle/60	2	43940.00
528	13	52	358338560369672	TASQC/USAID TASQC/Cell-Phone/1072	2	235.00
529	13	52	R58N600Y33F	TASQC/USAID TASQC/Cell-Phone/581	2	235.00
530	13	52	353327111100988	TASQC/USAID TASQC/Cell-Phone/1006	2	235.00
531	59	53	353415706678011	EpiC/Epidemic Control/Cell-Phone/1121	2	205.00
532	59	53	353415706677823	EpiC/Epidemic Control/Cell-Phone/1120	2	205.00
533	59	53	353415705813155	EpiC/Epidemic Control/Cell-Phone/1122	2	205.00
534	59	53	353415705811381	EpiC/Epidemic Control/Cell-Phone/1123	2	205.00
535	59	53	353415705818469	EpiC/Epidemic Control/Cell-Phone/1127	2	205.00
536	59	53	353415706677278	EpiC/Epidemic Control/Cell-Phone/1128	2	205.00
537	59	53	353415705810631	EpiC/Epidemic Control/Cell-Phone/1119	2	205.00
538	59	53	353415705808403	EpiC/Epidemic Control/Cell-Phone/1125	2	205.00
539	59	53	353415706681296	EpiC/Epidemic Control/Cell-Phone/1124	2	205.00
540	60	54	354237928401231	OPHID/OPHID/Cell-Phone/1237	2	1275.00
541	61	55	357922860470032	TASQC/USAID TASQC/Cell-Phone/1381	1	228.85
542	61	55	357922860482540	TASQC/USAID TASQC/Cell-Phone/1269	1	228.85
543	61	55	357922860477169	TASQC/USAID TASQC/Cell-Phone/1264	1	228.85
544	61	55	357922860497951	TASQC/USAID TASQC/Cell-Phone/1280	1	228.85
545	61	55	357922860535735	TASQC/USAID TASQC/Cell-Phone/1319	1	228.85
546	61	55	357922860477078	TASQC/USAID TASQC/Cell-Phone/1371	1	228.85
547	61	55	357922860525009	TASQC/USAID TASQC/Cell-Phone/1332	1	228.85
548	61	55	357922860476955	TASQC/USAID TASQC/Cell-Phone/1261	1	228.85
549	61	55	357922860477276	TASQC/USAID TASQC/Cell-Phone/1316	1	228.85
550	61	55	357922860481054	TASQC/USAID TASQC/Cell-Phone/1336	1	228.85
551	61	55	357922860481070	TASQC/USAID TASQC/Cell-Phone/1328	1	228.85
552	61	55	357922860472558	TASQC/USAID TASQC/Cell-Phone/1330	1	228.85
553	61	55	357922860522527	TASQC/USAID TASQC/Cell-Phone/1355	1	228.85
554	61	55	357922860512064	TASQC/USAID TASQC/Cell-Phone/1247	1	228.85
555	61	55	357922860470255	TASQC/USAID TASQC/Cell-Phone/1310	1	228.85
556	61	55	357922860473275	TASQC/USAID TASQC/Cell-Phone/1295	1	228.85
557	61	55	357922860278336	TASQC/USAID TASQC/Cell-Phone/1286	1	228.85
558	61	55	357922860529308	TASQC/USAID TASQC/Cell-Phone/1307	1	228.85
559	61	55	357922860536139	TASQC/USAID TASQC/Cell-Phone/1387	1	228.85
560	61	55	357922860481336	TASQC/USAID TASQC/Cell-Phone/1325	1	228.85
561	61	55	357922860380710	TASQC/USAID TASQC/Cell-Phone/1255	1	228.85
562	61	55	357922860535180	TASQC/USAID TASQC/Cell-Phone/1272	1	228.85
563	61	55	357922860474166	TASQC/USAID TASQC/Cell-Phone/1362	1	228.85
564	61	55	357922860499700	TASQC/USAID TASQC/Cell-Phone/1249	1	228.85
565	61	55	357922860496706	TASQC/USAID TASQC/Cell-Phone/1297	1	228.85
566	61	55	357922860472566	TASQC/USAID TASQC/Cell-Phone/1293	1	228.85
567	61	55	357922860529340	TASQC/USAID TASQC/Cell-Phone/1344	1	228.85
723	13	60	SGSN-00713	TASQC/USAID TASQC/Heater/45	2	55.00
568	61	55	357922860540511	TASQC/USAID TASQC/Cell-Phone/1270	1	228.85
569	61	55	357922860522386	TASQC/USAID TASQC/Cell-Phone/1275	1	228.85
570	61	55	357922860472798	TASQC/USAID TASQC/Cell-Phone/1321	1	228.85
571	61	55	357922860496664	TASQC/USAID TASQC/Cell-Phone/1357	1	228.85
572	61	55	357922860472657	TASQC/USAID TASQC/Cell-Phone/1374	1	228.85
573	61	55	356356429784354	TASQC/USAID TASQC/Cell-Phone/1358	1	228.85
574	61	55	357922860523012	TASQC/USAID TASQC/Cell-Phone/1308	1	228.85
575	61	55	357922860522519	TASQC/USAID TASQC/Cell-Phone/1299	1	228.85
576	61	55	357922860279011	TASQC/USAID TASQC/Cell-Phone/1282	1	228.85
577	61	55	357922860480320	TASQC/USAID TASQC/Cell-Phone/1252	1	228.85
578	61	55	357922860380371	TASQC/USAID TASQC/Cell-Phone/1240	1	228.85
579	61	55	357922860497977	TASQC/USAID TASQC/Cell-Phone/1366	1	228.85
580	61	55	357922860496698	TASQC/USAID TASQC/Cell-Phone/1367	1	228.85
581	61	55	357922860525215	TASQC/USAID TASQC/Cell-Phone/1368	1	228.85
582	61	55	357922860522402	TASQC/USAID TASQC/Cell-Phone/1369	1	228.85
583	61	55	357922860379209	TASQC/USAID TASQC/Cell-Phone/1370	1	228.85
584	61	55	357922860525504	TASQC/USAID TASQC/Cell-Phone/1373	1	228.85
585	61	55	357922860514201	TASQC/USAID TASQC/Cell-Phone/1281	1	228.85
586	61	55	357922860529316	TASQC/USAID TASQC/Cell-Phone/1285	1	228.85
587	61	55	357922860528748	TASQC/USAID TASQC/Cell-Phone/1287	1	228.85
588	61	55	357922860475916	TASQC/USAID TASQC/Cell-Phone/1363	1	228.85
589	61	55	357922860497217	TASQC/USAID TASQC/Cell-Phone/1256	1	228.85
590	61	55	357922860522329	TASQC/USAID TASQC/Cell-Phone/1334	1	228.85
591	61	55	357922860477029	TASQC/USAID TASQC/Cell-Phone/1309	1	228.85
592	61	55	357922860528987	TASQC/USAID TASQC/Cell-Phone/1333	1	228.85
593	61	55	357922860476484	TASQC/USAID TASQC/Cell-Phone/1364	1	228.85
594	61	55	357922860482177	TASQC/USAID TASQC/Cell-Phone/1276	1	228.85
595	61	55	357922860474208	TASQC/USAID TASQC/Cell-Phone/1314	1	228.85
596	61	55	357922860482581	TASQC/USAID TASQC/Cell-Phone/1320	1	228.85
597	61	55	357922860476922	TASQC/USAID TASQC/Cell-Phone/1271	1	228.85
598	61	55	357922860522360	TASQC/USAID TASQC/Cell-Phone/1302	1	228.85
599	61	55	357922860521727	TASQC/USAID TASQC/Cell-Phone/1311	1	228.85
600	61	55	357922860278518	TASQC/USAID TASQC/Cell-Phone/1313	1	228.85
601	61	55	357922860481245	TASQC/USAID TASQC/Cell-Phone/1337	1	228.85
602	61	55	357922860541220	TASQC/USAID TASQC/Cell-Phone/1260	1	228.85
603	61	55	357922860475536	TASQC/USAID TASQC/Cell-Phone/1359	1	228.85
604	61	55	357922860278716	TASQC/USAID TASQC/Cell-Phone/1347	1	228.85
605	61	55	357922860535446	TASQC/USAID TASQC/Cell-Phone/1339	1	228.85
606	61	55	357922860540388	TASQC/USAID TASQC/Cell-Phone/1361	1	228.85
607	61	55	357922860475452	TASQC/USAID TASQC/Cell-Phone/1323	1	228.85
608	61	55	357922860535545	TASQC/USAID TASQC/Cell-Phone/1340	1	228.85
609	61	55	357922860283872	TASQC/USAID TASQC/Cell-Phone/1317	1	228.85
610	61	55	357922860521818	TASQC/USAID TASQC/Cell-Phone/1348	1	228.85
611	61	55	357922860529365	TASQC/USAID TASQC/Cell-Phone/1273	1	228.85
612	61	55	357922860529324	TASQC/USAID TASQC/Cell-Phone/1376	1	228.85
613	61	55	357922860540222	TASQC/USAID TASQC/Cell-Phone/1288	1	228.85
614	61	55	357922860380694	TASQC/USAID TASQC/Cell-Phone/1342	1	228.85
615	61	55	357922860541246	TASQC/USAID TASQC/Cell-Phone/1259	1	228.85
616	61	55	357922860473804	TASQC/USAID TASQC/Cell-Phone/1360	1	228.85
617	61	55	357922860535917	TASQC/USAID TASQC/Cell-Phone/1279	1	228.85
618	61	55	357922860475304	TASQC/USAID TASQC/Cell-Phone/1331	1	228.85
619	61	55	357922860477003	TASQC/USAID TASQC/Cell-Phone/1274	1	228.85
620	61	55	357922860472210	TASQC/USAID TASQC/Cell-Phone/1315	1	228.85
621	61	55	357922860541519	TASQC/USAID TASQC/Cell-Phone/1365	1	228.85
622	61	55	357922860535321	TASQC/USAID TASQC/Cell-Phone/1277	1	228.85
623	61	55	357922860497928	TASQC/USAID TASQC/Cell-Phone/1306	1	228.85
624	61	55	357922860476930	TASQC/USAID TASQC/Cell-Phone/1292	1	228.85
625	61	55	357922860471188	TASQC/USAID TASQC/Cell-Phone/1248	1	228.85
626	61	55	357922860279078	TASQC/USAID TASQC/Cell-Phone/1253	1	228.85
627	61	55	357922860522345	TASQC/USAID TASQC/Cell-Phone/1303	1	228.85
628	61	55	357922860530728	TASQC/USAID TASQC/Cell-Phone/1290	1	228.85
629	61	55	357922860475551	TASQC/USAID TASQC/Cell-Phone/1258	1	228.85
630	61	55	357922860380397	TASQC/USAID TASQC/Cell-Phone/1349	1	228.85
631	61	55	357922860528730	TASQC/USAID TASQC/Cell-Phone/1289	1	228.85
632	61	55	357922860535271	TASQC/USAID TASQC/Cell-Phone/1305	1	228.85
633	61	55	357922860521974	TASQC/USAID TASQC/Cell-Phone/1265	1	228.85
634	61	55	357922860536469	TASQC/USAID TASQC/Cell-Phone/1278	1	228.85
635	61	55	357922860539208	TASQC/USAID TASQC/Cell-Phone/1263	1	228.85
636	61	55	357922860540842	TASQC/USAID TASQC/Cell-Phone/1324	1	228.85
637	61	55	357922860477094	TASQC/USAID TASQC/Cell-Phone/1380	1	228.85
638	61	55	357922860530710	TASQC/USAID TASQC/Cell-Phone/1266	1	228.85
639	61	55	357922860470750	TASQC/USAID TASQC/Cell-Phone/1346	1	228.85
640	61	55	357922860484926	TASQC/USAID TASQC/Cell-Phone/1345	1	228.85
641	61	55	357922860497936	TASQC/USAID TASQC/Cell-Phone/1284	1	228.85
642	61	55	357922860380249	TASQC/USAID TASQC/Cell-Phone/1298	1	228.85
643	61	55	357922860539224	TASQC/USAID TASQC/Cell-Phone/1268	1	228.85
644	61	55	357922860497969	TASQC/USAID TASQC/Cell-Phone/1254	1	228.85
645	61	55	357922860522352	TASQC/USAID TASQC/Cell-Phone/1354	1	228.85
646	61	55	357922860533029	TASQC/USAID TASQC/Cell-Phone/1291	1	228.85
647	61	55	357922860481393	TASQC/USAID TASQC/Cell-Phone/1329	1	228.85
648	61	55	357922860499841	TASQC/USAID TASQC/Cell-Phone/1301	1	228.85
649	61	55	357922860496722	TASQC/USAID TASQC/Cell-Phone/1338	1	228.85
650	61	55	357922860472525	TASQC/USAID TASQC/Cell-Phone/1312	1	228.85
651	61	55	357922860535842	TASQC/USAID TASQC/Cell-Phone/1318	1	228.85
652	61	55	357922860521792	TASQC/USAID TASQC/Cell-Phone/1262	1	228.85
653	61	55	357922860525975	TASQC/USAID TASQC/Cell-Phone/1356	1	228.85
654	61	55	357922860522659	TASQC/USAID TASQC/Cell-Phone/1341	1	228.85
655	61	55	357922860473531	TASQC/USAID TASQC/Cell-Phone/1300	1	228.85
656	61	55	357922860524622	TASQC/USAID TASQC/Cell-Phone/1257	1	228.85
657	61	55	357922860511942	TASQC/USAID TASQC/Cell-Phone/1296	1	228.85
658	61	55	357922860522584	TASQC/USAID TASQC/Cell-Phone/1250	1	228.85
659	61	55	357922860477300	TASQC/USAID TASQC/Cell-Phone/1283	1	228.85
660	61	55	357922860539422	TASQC/USAID TASQC/Cell-Phone/1352	1	228.85
661	61	55	357922860477110	TASQC/USAID TASQC/Cell-Phone/1335	1	228.85
662	61	55	357922860529530	TASQC/USAID TASQC/Cell-Phone/1326	1	228.85
663	61	55	357922860380413	TASQC/USAID TASQC/Cell-Phone/1343	1	228.85
664	61	55	357922860512080	TASQC/USAID TASQC/Cell-Phone/1327	1	228.85
665	61	55	357922860528979	TASQC/USAID TASQC/Cell-Phone/1251	1	228.85
666	61	55	357922860543853	TASQC/USAID TASQC/Cell-Phone/1351	1	228.85
667	61	55	357922360481013	TASQC/USAID TASQC/Cell-Phone/1246	1	228.85
668	61	55	357922860529357	TASQC/USAID TASQC/Cell-Phone/1304	1	228.85
669	61	55	357922860477086	TASQC/USAID TASQC/Cell-Phone/1386	1	228.85
670	61	55	357922860528953	TASQC/USAID TASQC/Cell-Phone/1385	1	228.85
671	61	55	357922860278195	TASQC/USAID TASQC/Cell-Phone/1244	1	228.85
672	61	55	357922860379019	TASQC/USAID TASQC/Cell-Phone/1377	1	228.85
673	61	55	357922860529993	TASQC/USAID TASQC/Cell-Phone/1383	1	228.85
674	61	55	357922860473820	TASQC/USAID TASQC/Cell-Phone/1382	1	228.85
675	61	55	357922860380330	TASQC/USAID TASQC/Cell-Phone/1241	1	228.85
676	61	55	357922860539240	TASQC/USAID TASQC/Cell-Phone/1239	1	228.85
677	61	55	357922860482532	TASQC/USAID TASQC/Cell-Phone/1388	1	228.85
678	61	55	357922860471162	TASQC/USAID TASQC/Cell-Phone/1242	1	228.85
679	61	55	357922860470222	TASQC/USAID TASQC/Cell-Phone/1243	1	228.85
680	61	55	357922860470305	TASQC/USAID TASQC/Cell-Phone/1379	1	228.85
681	61	55	357922860472582	TASQC/USAID TASQC/Cell-Phone/1378	1	228.85
682	61	55	357922860477912	TASQC/USAID TASQC/Cell-Phone/1375	1	228.85
683	61	55	357922860524788	TASQC/USAID TASQC/Cell-Phone/1384	1	228.85
684	61	55	357922860539075	TASQC/USAID TASQC/Cell-Phone/1353	1	228.85
685	61	55	357922860525470	TASQC/USAID TASQC/Cell-Phone/1372	1	228.85
686	61	55	357922860380215	TASQC/USAID TASQC/Cell-Phone/1294	1	228.85
687	61	55	357922860539190	TASQC/USAID TASQC/Cell-Phone/1267	1	228.85
688	61	55	357922860480049	TASQC/USAID TASQC/Cell-Phone/1322	1	228.85
689	61	55	357922860470701	TASQC/USAID TASQC/Cell-Phone/1350	1	228.85
690	61	55	357922860280472	TASQC/USAID TASQC/Cell-Phone/1245	1	228.85
691	62	56	R9WNBOFHX7J	TASQC/USAID TASQC/Cell-Phone/214	8	232.50
692	63	57	SGSN-00682	TASQC/USAID TASQC/Stove/8	2	500.00
693	13	58	SGSN-00683	TASQC/USAID TASQC/Fan/71	2	35.00
694	13	58	SGSN-00684	TASQC/USAID TASQC/Fan/17	2	35.00
695	21	58	SGSN-00685	TASQC/USAID TASQC/Fan/28	2	60.00
696	13	58	SGSN-00686	TASQC/USAID TASQC/Fan/35	2	35.00
697	21	58	SGSN-00687	TASQC/USAID TASQC/Fan/27	2	60.00
698	13	58	SGSN-00688	TASQC/USAID TASQC/Fan/14	2	35.00
699	13	58	SGSN-00689	TASQC/USAID TASQC/Fan/18	2	35.00
700	13	58	SGSN-00690	TASQC/USAID TASQC/Fan/33	2	35.00
701	13	58	SGSN-00691	TASQC/USAID TASQC/Fan/24	2	100.00
702	13	58	SGSN-00692	TASQC/USAID TASQC/Fan/69	2	35.00
703	13	58	SGSN-00693	TASQC/USAID TASQC/Fan/70	2	35.00
704	13	58	SGSN-00694	TASQC/USAID TASQC/Fan/34	2	35.00
705	13	58	SGSN-00695	TASQC/USAID TASQC/Fan/36	2	35.00
706	13	58	SGSN-00696	TASQC/USAID TASQC/Fan/37	2	35.00
707	13	59	SGSN-00697	TASQC/USAID TASQC/Notice Board/1	2	300.00
708	13	144	SGSN-00698	TASQC/USAID TASQC/Wheelbarrow/1	2	59.00
709	64	60	SGSN-00699	TASQC/USAID TASQC/Heater/9	2	52.54
710	13	60	SGSN-00700	TASQC/USAID TASQC/Heater/76	2	50.00
711	64	60	SGSN-00701	TASQC/USAID TASQC/Heater/5	2	52.54
712	64	60	SGSN-00702	TASQC/USAID TASQC/Heater/17	2	52.54
713	13	60	SGSN-00703	TASQC/USAID TASQC/Heater/55	2	50.00
714	13	60	SGSN-00704	TASQC/USAID TASQC/Heater/92	8	45.00
715	13	60	SGSN-00705	TASQC/USAID TASQC/Heater/94	8	45.00
716	13	60	SGSN-00706	TASQC/USAID TASQC/Heater/97	2	100.00
717	13	60	SGSN-00707	TASQC/USAID TASQC/Heater/98	8	45.00
718	13	60	SGSN-00708	TASQC/USAID TASQC/Heater/99	8	210.00
719	13	60	SGSN-00709	TASQC/USAID TASQC/Heater/100	8	210.00
720	13	60	SGSN-00710	TASQC/USAID TASQC/Heater/101	8	210.00
721	13	60	SGSN-00711	TASQC/USAID TASQC/Heater/103	8	45.00
722	13	60	SGSN-00712	TASQC/USAID TASQC/Heater/64	2	50.00
724	13	60	SGSN-00714	TASQC/USAID TASQC/Heater/115	2	45.00
725	13	60	SGSN-00715	TASQC/USAID TASQC/Heater/116	2	45.00
726	13	60	SGSN-00716	TASQC/USAID TASQC/Heater/117	2	45.00
727	13	60	SGSN-00717	TASQC/USAID TASQC/Heater/118	2	45.00
728	13	60	SGSN-00718	TASQC/USAID TASQC/Heater/53	2	50.00
729	64	60	SGSN-00719	TASQC/USAID TASQC/Heater/18	2	52.54
730	13	60	SGSN-00720	TASQC/USAID TASQC/Heater/77	2	50.00
731	13	60	SGSN-00721	TASQC/USAID TASQC/Heater/88	2	50.00
732	64	60	SGSN-00722	TASQC/USAID TASQC/Heater/19	2	52.54
733	13	60	SGSN-00723	TASQC/USAID TASQC/Heater/78	2	50.00
734	64	60	SGSN-00724	TASQC/USAID TASQC/Heater/59	2	52.54
735	64	60	SGSN-00725	TASQC/USAID TASQC/Heater/13	8	52.54
736	13	60	SGSN-00726	TASQC/USAID TASQC/Heater/51	2	55.00
737	13	60	SGSN-00727	TASQC/USAID TASQC/Heater/52	2	55.00
738	64	60	SGSN-00728	TASQC/USAID TASQC/Heater/48	2	52.58
739	13	60	SGSN-00729	TASQC/USAID TASQC/Heater/75	2	50.00
740	13	60	SGSN-00730	TASQC/USAID TASQC/Heater/50	2	55.00
741	13	60	SGSN-00731	TASQC/USAID TASQC/Heater/49	2	55.00
742	13	60	SGSN-00732	TASQC/USAID TASQC/Heater/96	2	45.00
743	64	60	SGSN-00733	TASQC/USAID TASQC/Heater/16	2	52.54
744	64	60	SGSN-00734	TASQC/USAID TASQC/Heater/11	2	52.54
745	13	60	SGSN-00735	TASQC/USAID TASQC/Heater/57	2	40.00
746	13	60	SGSN-00736	TASQC/USAID TASQC/Heater/54	2	50.00
747	13	60	SGSN-00737	TASQC/USAID TASQC/Heater/68	2	45.00
748	13	60	SGSN-00738	TASQC/USAID TASQC/Heater/44	2	50.00
749	64	60	SGSN-00739	TASQC/USAID TASQC/Heater/15	2	52.54
750	64	60	SGSN-00740	TASQC/USAID TASQC/Heater/46	2	52.54
751	13	60	SGSN-00741	TASQC/USAID TASQC/Heater/63	2	50.00
752	13	60	SGSN-00742	TASQC/USAID TASQC/Heater/66	2	45.00
753	13	60	SGSN-00743	TASQC/USAID TASQC/Heater/69	2	45.00
754	13	60	SGSN-00744	TASQC/USAID TASQC/Heater/71	2	50.00
755	65	61	AGF0388	TASQC/USAID TASQC/Vehicle/4	2	35955.00
756	66	61	AEF7899	TASQC/USAID TASQC/Vehicle/83	8	36250.00
757	65	61	AFM7734	TASQC/USAID TASQC/Vehicle/2	2	35955.00
758	67	61	AFM7749	TASQC/USAID TASQC/Vehicle/16	2	35955.00
759	67	61	AFM7678	TASQC/USAID TASQC/Vehicle/17	2	35955.00
760	67	61	AFM7750	TASQC/USAID TASQC/Vehicle/18	2	35955.00
761	67	61	AFM7745	TASQC/USAID TASQC/Vehicle/19	2	35955.00
762	67	61	AFM7747	TASQC/USAID TASQC/Vehicle/20	2	35955.00
763	67	61	AFM7739	TASQC/USAID TASQC/Vehicle/21	2	35955.00
764	68	61	AFX4199	TASQC/USAID TASQC/Vehicle/28	2	37000.00
765	69	61	AGP1902	TASQC/USAID TASQC/Vehicle/76	2	41477.00
766	70	61	AFM7681	TASQC/USAID TASQC/Vehicle/46	2	34805.00
767	71	61	AGH6090	TASQC/USAID TASQC/Vehicle/73	2	40475.00
768	70	61	AFM7680	TASQC/USAID TASQC/Vehicle/45	2	34805.00
769	65	61	AFM7731	TASQC/USAID TASQC/Vehicle/5	2	35955.00
770	65	61	AFM7735	TASQC/USAID TASQC/Vehicle/3	2	35955.00
771	65	61	AFM7732	TASQC/USAID TASQC/Vehicle/1	2	35955.00
772	72	61	AES7430	TASQC/USAID TASQC/Vehicle/47	2	34100.00
773	72	61	AES7420	TASQC/USAID TASQC/Vehicle/48	2	34100.00
774	72	61	AES7421	TASQC/USAID TASQC/Vehicle/49	2	34100.00
775	73	61	AEF5494	TASQC/USAID TASQC/Vehicle/57	2	44000.00
776	71	61	AGH6247	TASQC/USAID TASQC/Vehicle/71	2	40475.00
777	71	61	AGH6091	TASQC/USAID TASQC/Vehicle/72	2	40475.00
778	74	61	AGH6089	OPHID/OPHID/Vehicle/74	2	40475.00
779	69	61	AGP1990	TASQC/USAID TASQC/Vehicle/75	2	41477.00
780	46	61	AGA3515	TASQC/USAID TASQC/Vehicle/77	2	29740.00
781	46	61	AGA3517	TASQC/USAID TASQC/Vehicle/78	2	29740.00
782	75	61	AFM7738	TASQC/USAID TASQC/Vehicle/22	2	35955.00
783	75	61	AFM7736	TASQC/USAID TASQC/Vehicle/23	2	35955.00
784	75	61	AFM7743	TASQC/USAID TASQC/Vehicle/24	2	35955.00
785	75	61	AFM7742	TASQC/USAID TASQC/Vehicle/25	2	35955.00
786	75	61	AFM7677	TASQC/USAID TASQC/Vehicle/26	2	35955.00
787	75	61	AFM7748	TASQC/USAID TASQC/Vehicle/27	2	35955.00
788	13	62	32KHS82593	TASQC/USAID TASQC/Refrigerator/7	2	270.00
789	22	62	32KHS72163	TASQC/USAID TASQC/Refrigerator/8	2	340.00
790	76	62	1B0100Z00045BG6FHE10709	TASQC/USAID TASQC/Refrigerator/14	3	400.00
791	76	62	1B0150Z000388GAGDE20488	TASQC/USAID TASQC/Refrigerator/15	2	400.00
792	63	62	SGSN-00782	TASQC/USAID TASQC/Refrigerator/6	2	500.00
793	13	62	SGSN-00783	TASQC/USAID TASQC/Refrigerator/11	2	500.00
794	77	63	CND03680YB	TASQC/USAID TASQC/Laptop/121	2	1430.00
795	77	63	CND036810Y	TASQC/USAID TASQC/Laptop/130	2	1430.00
796	78	64	CNBRRC57DT	TASQC/USAID TASQC/Printer/46	2	750.00
797	79	64	CNBRSCQ668	TASQC/USAID TASQC/Printer/48	2	645.00
798	80	65	CNDRQ6B8FB	TASQC/USAID TASQC/Printer/40	2	720.00
799	80	65	CNDRP8F4NF	TASQC/USAID TASQC/Printer/39	2	720.00
800	80	65	CNDRQ6B8DH	TASQC/USAID TASQC/Printer/41	2	720.00
801	13	66	PHBLM4DCZV 	TASQC/USAID TASQC/Printer/33	2	500.00
802	81	67	3292Z420613	TASQC/USAID TASQC/Printer/30	2	3339.16
803	13	68	353885287545526	TASQC/USAID TASQC/Cell-Phone/1169	8	90.00
804	13	69	SGSN-00794	TASQC/USAID TASQC/Generator/10	2	1000.00
805	13	70	SGSN-00795	TASQC/USAID TASQC/Chair/428	2	30.00
806	13	70	SGSN-00796	TASQC/USAID TASQC/Chair/429	2	30.00
807	13	70	SGSN-00797	TASQC/USAID TASQC/Chair/430	2	30.00
808	13	70	SGSN-00798	TASQC/USAID TASQC/Chair/431	2	30.00
809	13	71	SGSN-00799	TASQC/USAID TASQC/Table/23	2	100.00
810	13	72	SGSN-00800	TASQC/USAID TASQC/Cabinet/93	2	210.00
811	13	72	SGSN-00801	TASQC/USAID TASQC/Cabinet/153	2	190.00
812	68	73	AFY3237	TASQC/USAID TASQC/Vehicle/31	2	38800.00
813	82	73	AGN4103	TASQC/USAID TASQC/Vehicle/65	2	36825.00
814	83	73	AEX9992	TASQC/USAID TASQC/Vehicle/42	2	34850.00
815	84	73	AFK6851	TASQC/USAID TASQC/Vehicle/84	2	34900.00
816	85	73	AEX9629	TASQC/USAID TASQC/Vehicle/37	2	34850.00
817	86	73	AFA9893	TASQC/USAID TASQC/Vehicle/43	2	34500.00
818	82	73	AGN4068	TASQC/USAID TASQC/Vehicle/68	2	35066.66
819	68	73	AFY3238	TASQC/USAID TASQC/Vehicle/33	2	38800.00
820	87	73	AGO3222	TASQC/USAID TASQC/Vehicle/80	2	34900.00
821	87	73	AGE5839	TASQC/USAID TASQC/Vehicle/81	2	40950.00
822	87	73	AGO3236	TASQC/USAID TASQC/Vehicle/82	2	34900.00
823	68	73	AFY3168	TASQC/USAID TASQC/Vehicle/29	2	38800.00
824	85	73	AEX9651	TASQC/USAID TASQC/Vehicle/41	2	34850.00
825	86	73	AFA9688	TASQC/USAID TASQC/Vehicle/44	2	34500.00
826	65	73	AFM7740	TASQC/USAID TASQC/Vehicle/6	2	37320.00
827	85	73	AEX9650	TASQC/USAID TASQC/Vehicle/40	2	34850.00
828	85	73	AEX9643	TASQC/USAID TASQC/Vehicle/38	2	34850.00
829	85	73	AEX9644	TASQC/USAID TASQC/Vehicle/39	2	34850.00
830	88	73	AEL3910	TASQC/USAID TASQC/Vehicle/53	2	50542.00
831	88	73	AEL3909	TASQC/USAID TASQC/Vehicle/54	2	50542.00
832	88	73	AEL3895	TASQC/USAID TASQC/Vehicle/55	2	50542.00
833	88	73	AEL3822	TASQC/USAID TASQC/Vehicle/56	2	50542.00
834	82	73	AGH7959	TASQC/USAID TASQC/Vehicle/69	2	35066.66
835	82	73	AGN4102	TASQC/USAID TASQC/Vehicle/67	2	35066.66
836	65	73	AFM7741	TASQC/USAID TASQC/Vehicle/7	2	37320.00
837	89	73	AFY7363	OPHID/OPHID/Vehicle/34	2	42191.95
838	82	73	AGH7958	TASQC/USAID TASQC/Vehicle/66	2	36825.00
839	68	73	AFX5174	TASQC/USAID TASQC/Vehicle/30	2	38800.00
840	68	73	AFY3235	TASQC/USAID TASQC/Vehicle/32	2	38800.00
841	89	73	AFY7365	OPHID/OPHID/Vehicle/36	2	42191.95
842	89	73	AFY7387	OPHID/OPHID/Vehicle/35	2	42191.95
843	90	74	CNCRQB79FF	TASQC/USAID TASQC/Printer/32	2	879.00
844	91	74	CNCRQ8N015	TASQC/USAID TASQC/Printer/45	2	742.00
845	13	75	CNB9H9J3CM	TASQC/USAID TASQC/Printer/21	2	400.00
846	13	76	102TPVH3B655LG	TASQC/USAID TASQC/Monitor/32	2	2550.00
847	13	76	102TPPB3B656	TASQC/USAID TASQC/Monitor/40	2	255.00
848	13	77	SGSN-00838	TASQC/USAID TASQC/Money-counter/9	2	300.00
849	92	77	ZA1220007696	TASQC/USAID TASQC/Money-counter/2	2	2200.00
850	92	77	ZA1220007697	TASQC/USAID TASQC/Money-counter/1	2	2200.00
851	92	77	ZA0201007507	TASQC/USAID TASQC/Money-counter/3	2	2200.00
852	93	78	3CM2301S2W	TASQC/USAID TASQC/Monitor/36	2	405.95
853	93	78	3CM2301S41	TASQC/USAID TASQC/Monitor/38	2	405.95
854	93	78	3CM2301S3X	TASQC/USAID TASQC/Monitor/37	2	405.95
855	13	79	0890BJEJ60000AA 	TASQC/USAID TASQC/Printer/35	2	1000.00
856	13	80	SGSN-00846	TASQC/USAID TASQC/Cabinet/82	2	270.00
857	13	80	SGSN-00847	TASQC/USAID TASQC/Cabinet/100	2	235.00
858	13	80	SGSN-00848	TASQC/USAID TASQC/Cabinet/121	2	120.00
859	13	80	SGSN-00849	TASQC/USAID TASQC/Cabinet/168	2	210.00
860	94	80	SGSN-00850	TASQC/USAID TASQC/Cabinet/83	2	200.00
861	94	80	SGSN-00851	TASQC/USAID TASQC/Cabinet/84	2	200.00
862	20	80	SGSN-00852	TASQC/USAID TASQC/Cabinet/89	2	300.00
863	13	80	SGSN-00853	TASQC/USAID TASQC/Cabinet/163	2	210.00
864	15	80	SGSN-00854	TASQC/USAID TASQC/Cabinet/65	2	110.00
865	13	80	SGSN-00855	TASQC/USAID TASQC/Cabinet/162	2	210.00
866	13	80	SGSN-00856	TASQC/USAID TASQC/Cabinet/130	2	220.00
867	13	80	SGSN-00857	TASQC/USAID TASQC/Cabinet/131	2	220.00
868	13	80	SGSN-00858	TASQC/USAID TASQC/Cabinet/132	2	220.00
869	13	80	SGSN-00859	TASQC/USAID TASQC/Cabinet/79	2	270.00
870	13	80	SGSN-00860	TASQC/USAID TASQC/Cabinet/80	2	270.00
871	13	80	SGSN-00861	TASQC/USAID TASQC/Cabinet/81	2	270.00
872	95	80	SGSN-00862	TASQC/USAID TASQC/Cabinet/44	2	346.00
873	96	80	SGSN-00863	TASQC/USAID TASQC/Cabinet/105	2	350.00
874	96	80	SGSN-00864	TASQC/USAID TASQC/Cabinet/106	2	350.00
875	13	80	SGSN-00865	TASQC/USAID TASQC/Cabinet/160	2	220.00
876	13	80	SGSN-00866	TASQC/USAID TASQC/Cabinet/161	2	220.00
877	97	80	SGSN-00867	TASQC/USAID TASQC/Cabinet/78	2	110.00
878	13	80	SGSN-00868	TASQC/USAID TASQC/Cabinet/157	2	220.00
879	13	80	SGSN-00869	TASQC/USAID TASQC/Cabinet/158	2	220.00
880	15	80	SGSN-00870	TASQC/USAID TASQC/Cabinet/67	2	110.00
881	13	80	SGSN-00871	TASQC/USAID TASQC/Cabinet/111	2	150.00
882	13	80	SGSN-00872	TASQC/USAID TASQC/Cabinet/159	2	320.00
883	13	80	SGSN-00873	TASQC/USAID TASQC/Cabinet/165	2	140.00
884	13	80	SGSN-00874	TASQC/USAID TASQC/Cabinet/166	2	140.00
885	13	80	SGSN-00875	TASQC/USAID TASQC/Cabinet/99	2	235.00
886	98	81	SGSN-00876	TASQC/USAID TASQC/Pedastal/83	2	135.90
887	99	80	SGSN-00877	TASQC/USAID TASQC/Cabinet/45	2	429.00
888	13	80	SGSN-00878	TASQC/USAID TASQC/Cabinet/133	2	220.00
889	13	80	SGSN-00879	TASQC/USAID TASQC/Cabinet/134	2	220.00
890	100	80	SGSN-00880	TASQC/USAID TASQC/Cabinet/39	2	320.00
891	13	80	SGSN-00881	TASQC/USAID TASQC/Cabinet/143	2	220.00
892	13	80	SGSN-00882	TASQC/USAID TASQC/Cabinet/146	2	220.00
893	100	80	SGSN-00883	TASQC/USAID TASQC/Cabinet/40	2	320.00
894	100	80	SGSN-00884	TASQC/USAID TASQC/Cabinet/41	2	320.00
895	101	80	SGSN-00885	TASQC/USAID TASQC/Cabinet/42	2	346.00
896	101	80	SGSN-00886	TASQC/USAID TASQC/Cabinet/43	2	346.00
897	15	80	SGSN-00887	TASQC/USAID TASQC/Cabinet/66	2	110.00
898	102	80	SGSN-00888	TASQC/USAID TASQC/Cabinet/71	2	360.00
899	13	80	SGSN-00889	TASQC/USAID TASQC/Cabinet/124	2	230.00
900	13	80	SGSN-00890	TASQC/USAID TASQC/Cabinet/125	2	220.00
901	13	80	SGSN-00891	TASQC/USAID TASQC/Cabinet/139	2	220.00
902	13	80	SGSN-00892	TASQC/USAID TASQC/Cabinet/141	2	220.00
903	13	80	SGSN-00893	TASQC/USAID TASQC/Cabinet/142	2	220.00
904	13	80	SGSN-00894	TASQC/USAID TASQC/Cabinet/145	2	220.00
905	13	80	SGSN-00895	TASQC/USAID TASQC/Cabinet/179	2	125.00
906	13	80	SGSN-00896	TASQC/USAID TASQC/Cabinet/180	2	125.00
907	55	82	SGSN-00897	TASQC/USAID TASQC/Cabinet/34	3	250.00
908	55	82	SGSN-00898	TASQC/USAID TASQC/Cabinet/36	2	250.00
909	13	82	SGSN-00899	TASQC/USAID TASQC/Cabinet/87	2	150.00
910	55	82	SGSN-00900	TASQC/USAID TASQC/Cabinet/20	2	250.00
911	55	82	SGSN-00901	TASQC/USAID TASQC/Cabinet/4	2	250.00
912	55	82	SGSN-00902	TASQC/USAID TASQC/Cabinet/5	2	250.00
913	55	82	SGSN-00903	TASQC/USAID TASQC/Cabinet/6	2	250.00
914	55	82	SGSN-00904	TASQC/USAID TASQC/Cabinet/7	2	250.00
915	55	82	SGSN-00905	TASQC/USAID TASQC/Cabinet/11	2	250.00
916	55	82	SGSN-00906	TASQC/USAID TASQC/Cabinet/12	2	250.00
917	13	82	SGSN-00907	TASQC/USAID TASQC/Cabinet/164	2	140.00
918	55	82	SGSN-00908	TASQC/USAID TASQC/Cabinet/28	3	250.00
919	55	82	SGSN-00909	TASQC/USAID TASQC/Cabinet/2	2	250.00
920	55	82	SGSN-00910	TASQC/USAID TASQC/Cabinet/10	2	250.00
921	55	82	SGSN-00911	TASQC/USAID TASQC/Cabinet/21	2	250.00
922	22	82	SGSN-00912	TASQC/USAID TASQC/Cabinet/102	2	410.00
923	22	82	SGSN-00913	TASQC/USAID TASQC/Cabinet/103	2	410.00
924	55	82	SGSN-00914	TASQC/USAID TASQC/Cabinet/19	2	250.00
925	55	82	SGSN-00915	TASQC/USAID TASQC/Cabinet/13	2	250.00
926	55	82	SGSN-00916	TASQC/USAID TASQC/Cabinet/17	2	250.00
927	55	82	SGSN-00917	TASQC/USAID TASQC/Cabinet/18	2	250.00
928	55	82	SGSN-00918	TASQC/USAID TASQC/Cabinet/22	2	250.00
929	55	82	SGSN-00919	TASQC/USAID TASQC/Cabinet/23	2	250.00
930	25	82	SGSN-00920	TASQC/USAID TASQC/Cabinet/107	3	250.00
931	25	82	SGSN-00921	TASQC/USAID TASQC/Cabinet/108	2	340.00
932	103	82	SGSN-00922	TASQC/USAID TASQC/Cabinet/63	2	110.00
933	55	82	SGSN-00923	TASQC/USAID TASQC/Cabinet/24	2	250.00
934	55	82	SGSN-00924	TASQC/USAID TASQC/Cabinet/25	2	250.00
935	55	82	SGSN-00925	TASQC/USAID TASQC/Cabinet/26	2	250.00
936	55	82	SGSN-00926	TASQC/USAID TASQC/Cabinet/1	2	250.00
937	55	82	SGSN-00927	TASQC/USAID TASQC/Cabinet/3	2	250.00
938	55	82	SGSN-00928	TASQC/USAID TASQC/Cabinet/14	2	250.00
939	55	82	SGSN-00929	TASQC/USAID TASQC/Cabinet/15	2	250.00
940	55	82	SGSN-00930	TASQC/USAID TASQC/Cabinet/16	2	250.00
941	13	82	SGSN-00931	TASQC/USAID TASQC/Cabinet/115	2	150.00
942	13	82	SGSN-00932	TASQC/USAID TASQC/Cabinet/116	2	150.00
943	24	82	SGSN-00933	TASQC/USAID TASQC/Cabinet/58	2	351.00
944	24	82	SGSN-00934	TASQC/USAID TASQC/Cabinet/60	2	351.00
945	13	82	SGSN-00935	TASQC/USAID TASQC/Cabinet/123	2	210.00
946	13	82	SGSN-00936	TASQC/USAID TASQC/Cabinet/147	2	230.00
947	13	82	SGSN-00937	TASQC/USAID TASQC/Cabinet/148	2	230.00
948	13	82	SGSN-00938	TASQC/USAID TASQC/Cabinet/149	2	230.00
949	13	82	SGSN-00939	TASQC/USAID TASQC/Cabinet/150	2	230.00
950	13	82	SGSN-00940	TASQC/USAID TASQC/Cabinet/151	2	230.00
951	13	82	SGSN-00941	TASQC/USAID TASQC/Cabinet/152	2	230.00
952	13	82	SGSN-00942	TASQC/USAID TASQC/Cabinet/178	2	135.00
953	104	83	CN85NHY09J	TASQC/USAID TASQC/Printer/8	2	565.22
954	13	84	VNCNF00069	TASQC/USAID TASQC/Printer/34	2	300.00
955	105	85	CNDRP7X2NW	TASQC/USAID TASQC/Printer/4	2	600.00
956	106	86	CNDVN5T134	TASQC/USAID TASQC/Printer/2	2	9750.00
957	107	86	CNDBR76016	TASQC/USAID TASQC/Printer/43	2	4858.00
958	108	86	CNDBRD00K9	TASQC/USAID TASQC/Printer/47	2	4405.00
959	106	86	CNDVN5T13K	TASQC/USAID TASQC/Printer/3	2	9750.00
960	106	86	CNDVN5T134-1	TASQC/USAID TASQC/Printer/1	2	9750.00
961	109	86	CNDBQ651BQ	TASQC/USAID TASQC/Printer/42	2	4858.00
962	13	87	SGSN-00952	TASQC/USAID TASQC/Microwave /11	2	250.00
963	13	87	SGSN-00953	TASQC/USAID TASQC/Microwave /6	2	250.00
964	110	87	540K290610437211100121	TASQC/USAID TASQC/Microwave /14	2	289.00
965	13	87	J6GT7WFR700193F	TASQC/USAID TASQC/Microwave /5	2	250.00
966	13	87	SGSN-00956	TASQC/USAID TASQC/Microwave /8	2	250.00
967	13	87	SGSN-00957	TASQC/USAID TASQC/Microwave /7	2	250.00
968	13	87	SWSMO2000AC2907201602262	TASQC/USAID TASQC/Microwave /13	2	220.00
969	13	87	SGSN-00959	TASQC/USAID TASQC/Microwave /3	2	250.00
970	13	87	DMO367	TASQC/USAID TASQC/Microwave /4	2	250.00
971	13	87	EB03988420317712110057	TASQC/USAID TASQC/Microwave /12	2	260.00
972	111	87	N222W310657G	TASQC/USAID TASQC/Microwave /15	2	104.60
973	112	88	SGSN-00963	TASQC/USAID TASQC/Pedastal/6	2	135.90
974	112	88	SGSN-00964	TASQC/USAID TASQC/Pedastal/5	2	135.90
975	112	88	SGSN-00965	TASQC/USAID TASQC/Pedastal/1	2	135.90
976	112	88	SGSN-00966	TASQC/USAID TASQC/Pedastal/4	2	135.90
977	112	88	SGSN-00967	TASQC/USAID TASQC/Pedastal/3	2	135.90
978	34	88	SGSN-00968	TASQC/USAID TASQC/Pedastal/23	2	135.90
979	13	88	SGSN-00969	TASQC/USAID TASQC/Pedastal/68	2	60.00
980	13	88	SGSN-00970	TASQC/USAID TASQC/Pedastal/73	2	60.00
981	13	88	SGSN-00971	TASQC/USAID TASQC/Pedastal/76	2	60.00
982	34	88	SGSN-00972	TASQC/USAID TASQC/Pedastal/30	2	135.90
983	13	88	SGSN-00973	TASQC/USAID TASQC/Pedastal/72	2	60.00
984	113	88	SGSN-00974	TASQC/USAID TASQC/Pedastal/8	2	135.90
985	113	88	SGSN-00975	TASQC/USAID TASQC/Pedastal/9	2	135.90
986	113	88	SGSN-00976	TASQC/USAID TASQC/Pedastal/10	2	135.90
987	34	88	SGSN-00977	TASQC/USAID TASQC/Pedastal/26	2	135.90
988	34	88	SGSN-00978	TASQC/USAID TASQC/Pedastal/42	2	135.90
989	13	88	SGSN-00979	TASQC/USAID TASQC/Pedastal/66	2	60.00
990	13	88	SGSN-00980	TASQC/USAID TASQC/Pedastal/67	2	60.00
991	34	88	SGSN-00981	TASQC/USAID TASQC/Pedastal/36	2	135.90
992	13	88	SGSN-00982	TASQC/USAID TASQC/Pedastal/78	2	60.00
993	34	88	SGSN-00983	TASQC/USAID TASQC/Pedastal/27	2	135.90
994	112	88	SGSN-00984	TASQC/USAID TASQC/Pedastal/2	2	135.90
995	13	88	SGSN-00985	TASQC/USAID TASQC/Pedastal/52	8	60.00
996	34	88	SGSN-00986	TASQC/USAID TASQC/Pedastal/32	2	135.90
997	13	88	SGSN-00987	TASQC/USAID TASQC/Pedastal/65	2	60.00
998	13	88	SGSN-00988	TASQC/USAID TASQC/Pedastal/74	2	60.00
999	113	88	SGSN-00989	TASQC/USAID TASQC/Pedastal/16	2	135.90
1000	113	88	SGSN-00990	TASQC/USAID TASQC/Pedastal/17	2	135.90
1001	113	88	SGSN-00991	TASQC/USAID TASQC/Pedastal/18	2	135.90
1002	113	88	SGSN-00992	TASQC/USAID TASQC/Pedastal/20	2	135.90
1003	113	88	SGSN-00993	TASQC/USAID TASQC/Pedastal/21	2	135.90
1004	113	88	SGSN-00994	TASQC/USAID TASQC/Pedastal/22	2	135.90
1005	34	88	SGSN-00995	TASQC/USAID TASQC/Pedastal/24	2	135.90
1006	13	88	SGSN-00996	TASQC/USAID TASQC/Pedastal/51	2	65.00
1007	13	88	SGSN-00997	TASQC/USAID TASQC/Pedastal/75	2	60.00
1008	34	88	SGSN-00998	TASQC/USAID TASQC/Pedastal/33	2	135.90
1009	34	88	SGSN-00999	TASQC/USAID TASQC/Pedastal/37	2	135.90
1010	13	88	SGSN-01000	TASQC/USAID TASQC/Pedastal/49	2	60.00
1011	13	88	SGSN-01001	TASQC/USAID TASQC/Pedastal/50	2	60.00
1012	34	88	SGSN-01002	TASQC/USAID TASQC/Pedastal/31	2	135.90
1013	13	88	SGSN-01003	TASQC/USAID TASQC/Pedastal/77	2	60.00
1014	13	88	SGSN-01004	TASQC/USAID TASQC/Pedastal/62	2	80.00
1015	13	88	SGSN-01005	TASQC/USAID TASQC/Pedastal/61	2	80.00
1016	13	88	SGSN-01006	TASQC/USAID TASQC/Pedastal/64	2	60.00
1017	13	88	SGSN-01007	TASQC/USAID TASQC/Pedastal/59	2	40.00
1018	13	88	SGSN-01008	TASQC/USAID TASQC/Pedastal/63	2	60.00
1019	113	88	SGSN-01009	TASQC/USAID TASQC/Pedastal/15	2	135.90
1020	13	88	SGSN-01010	TASQC/USAID TASQC/Pedastal/47	2	80.00
1021	13	88	SGSN-01011	TASQC/USAID TASQC/Pedastal/55	2	40.00
1022	34	88	SGSN-01012	TASQC/USAID TASQC/Pedastal/29	2	135.90
1023	98	88	SGSN-01013	TASQC/USAID TASQC/Pedastal/82	2	135.90
1024	13	88	SGSN-01014	TASQC/USAID TASQC/Pedastal/53	2	60.00
1025	13	88	SGSN-01015	TASQC/USAID TASQC/Pedastal/70	2	60.00
1026	34	88	SGSN-01016	TASQC/USAID TASQC/Pedastal/28	2	135.90
1027	13	88	SGSN-01017	TASQC/USAID TASQC/Pedastal/71	2	60.00
1028	13	88	SGSN-01018	TASQC/USAID TASQC/Pedastal/60	2	80.00
1029	13	88	SGSN-01019	TASQC/USAID TASQC/Pedastal/48	2	70.00
1030	13	88	SGSN-01020	TASQC/USAID TASQC/Pedastal/57	2	40.00
1031	13	88	SGSN-01021	TASQC/USAID TASQC/Pedastal/58	2	40.00
1032	13	88	SGSN-01022	TASQC/USAID TASQC/Pedastal/69	2	60.00
1033	114	89	168UV/MG	TASQC/USAID TASQC/Money-counter/6	2	300.00
1034	115	89	SGSN-01024	TASQC/USAID TASQC/Money-counter/4	2	400.00
1035	13	89	SGSN-01025	TASQC/USAID TASQC/Money-counter/10	2	300.00
1036	13	89	AC220V/MG	TASQC/USAID TASQC/Money-counter/11	2	300.00
1037	116	90	ACT1888	TASQC/USAID TASQC/Motor-trailer/1	8	4000.00
1038	116	90	ACT1890	TASQC/USAID TASQC/Motor-trailer/2	8	4000.00
1039	117	91	G668CB70064	TASQC/USAID TASQC/Printer/9	2	18302.00
1040	118	92	44631	TASQC/USAID TASQC/X-Ray Machine/1	2	84572.35
1041	119	93	NX20171200583	TASQC/USAID TASQC/Grass-Cutter/1	2	535.00
1042	120	94	SGSN-01032	TASQC/USAID TASQC/Trunk/6	2	471.40
1043	120	94	SGSN-01033	TASQC/USAID TASQC/Trunk/8	2	471.40
1044	120	94	SGSN-01034	TASQC/USAID TASQC/Trunk/10	2	471.40
1045	121	94	SGSN-01035	TASQC/USAID TASQC/Trunk/18	2	471.40
1046	121	94	SGSN-01036	TASQC/USAID TASQC/Trunk/24	2	471.40
1047	121	94	SGSN-01037	TASQC/USAID TASQC/Trunk/16	2	471.40
1048	121	94	SGSN-01038	TASQC/USAID TASQC/Trunk/29	2	471.40
1049	121	94	SGSN-01039	TASQC/USAID TASQC/Trunk/15	2	471.40
1050	122	94	SGSN-01040	TASQC/USAID TASQC/Trunk/37	2	471.40
1051	122	94	SGSN-01041	TASQC/USAID TASQC/Trunk/38	2	471.40
1052	122	94	SGSN-01042	TASQC/USAID TASQC/Trunk/39	2	471.40
1053	122	94	SGSN-01043	TASQC/USAID TASQC/Trunk/40	2	471.40
1054	122	94	SGSN-01044	TASQC/USAID TASQC/Trunk/41	2	471.40
1055	122	94	SGSN-01045	TASQC/USAID TASQC/Trunk/42	2	471.40
1056	122	94	SGSN-01046	TASQC/USAID TASQC/Trunk/45	2	471.40
1057	120	94	SGSN-01047	TASQC/USAID TASQC/Trunk/13	2	471.40
1058	122	94	SGSN-01048	TASQC/USAID TASQC/Trunk/49	2	471.40
1059	121	94	SGSN-01049	TASQC/USAID TASQC/Trunk/27	2	471.40
1060	120	94	SGSN-01050	TASQC/USAID TASQC/Trunk/7	2	471.40
1061	120	94	SGSN-01051	TASQC/USAID TASQC/Trunk/9	2	471.40
1062	120	94	SGSN-01052	TASQC/USAID TASQC/Trunk/11	2	471.40
1063	122	94	SGSN-01053	TASQC/USAID TASQC/Trunk/47	2	471.40
1064	121	94	SGSN-01054	TASQC/USAID TASQC/Trunk/17	2	471.40
1065	121	94	SGSN-01055	TASQC/USAID TASQC/Trunk/19	2	471.40
1066	121	94	SGSN-01056	TASQC/USAID TASQC/Trunk/23	2	471.40
1067	122	94	SGSN-01057	TASQC/USAID TASQC/Trunk/48	2	471.40
1068	122	94	SGSN-01058	TASQC/USAID TASQC/Trunk/44	2	471.40
1069	122	94	SGSN-01059	TASQC/USAID TASQC/Trunk/46	2	471.40
1070	121	94	SGSN-01060	TASQC/USAID TASQC/Trunk/26	2	471.40
1071	120	94	SGSN-01061	TASQC/USAID TASQC/Trunk/1	2	471.40
1072	120	94	SGSN-01062	TASQC/USAID TASQC/Trunk/2	2	471.40
1073	120	94	SGSN-01063	TASQC/USAID TASQC/Trunk/3	2	471.40
1074	120	94	SGSN-01064	TASQC/USAID TASQC/Trunk/4	2	471.40
1075	120	94	SGSN-01065	TASQC/USAID TASQC/Trunk/5	2	471.40
1076	121	94	SGSN-01066	TASQC/USAID TASQC/Trunk/14	2	471.40
1077	120	94	SGSN-01067	TASQC/USAID TASQC/Trunk/12	2	471.40
1078	121	94	SGSN-01068	TASQC/USAID TASQC/Trunk/21	2	471.40
1079	121	94	SGSN-01069	TASQC/USAID TASQC/Trunk/22	2	471.40
1080	122	94	SGSN-01070	TASQC/USAID TASQC/Trunk/34	2	471.40
1081	122	94	SGSN-01071	TASQC/USAID TASQC/Trunk/35	2	471.40
1082	122	94	SGSN-01072	TASQC/USAID TASQC/Trunk/36	2	471.40
1083	121	94	SGSN-01073	TASQC/USAID TASQC/Trunk/25	2	471.40
1084	121	94	SGSN-01074	TASQC/USAID TASQC/Trunk/20	2	471.40
1085	121	94	SGSN-01075	TASQC/USAID TASQC/Trunk/28	2	471.40
1086	121	94	SGSN-01076	TASQC/USAID TASQC/Trunk/50	2	471.40
1087	121	94	SGSN-01077	TASQC/USAID TASQC/Trunk/51	2	471.40
1088	122	94	SGSN-01078	TASQC/USAID TASQC/Trunk/43	2	471.40
1089	13	95	HO8000859X	TASQC/USAID TASQC/Generator/7	2	350.00
1090	13	95	H08000940X	TASQC/USAID TASQC/Generator/6	2	350.00
1091	123	95	SGSN-01081	TASQC/USAID TASQC/Generator/5	2	1640.00
1092	13	95	G05000232X	TASQC/USAID TASQC/Generator/8	2	350.00
1093	124	95	KDE6500T	TASQC/USAID TASQC/Generator/3	2	1640.00
1094	125	95	H080-00843X E1751D60508	TASQC/USAID TASQC/Generator/2	2	1640.00
1095	13	95	E175HD60457	TASQC/USAID TASQC/Generator/4	2	1640.00
1096	13	95	SGSN-01086	TASQC/USAID TASQC/Generator/9	8	500.00
1097	13	96	SGSN-01087	TASQC/USAID TASQC/Heater/110	8	65.00
1098	126	97	VNX5340K8H	TASQC/USAID TASQC/Laptop/503	1	1069.50
1099	126	97	VNX53405W1	TASQC/USAID TASQC/Laptop/500	1	1069.50
1100	126	97	VNX5340FCN	TASQC/USAID TASQC/Laptop/499	1	1069.50
1101	126	97	VNX5340114	TASQC/USAID TASQC/Laptop/502	1	1069.50
1102	126	97	VNX53402VB	TASQC/USAID TASQC/Laptop/496	1	1069.50
1103	126	97	VNX5340151	TASQC/USAID TASQC/Laptop/498	1	1069.50
1104	126	97	VNX5360DBT	TASQC/USAID TASQC/Laptop/505	1	1069.50
1105	126	97	VNX5360D66	TASQC/USAID TASQC/Laptop/504	1	1069.50
1106	126	97	VNX534095P	TASQC/USAID TASQC/Laptop/489	1	1069.50
1107	126	97	VNX53609KH	TASQC/USAID TASQC/Laptop/494	1	1069.50
1108	126	97	VNX5340BX4	TASQC/USAID TASQC/Laptop/491	1	1069.50
1109	126	97	VNX53607C3	TASQC/USAID TASQC/Laptop/493	1	1069.50
1110	126	97	VNX5340H4J	TASQC/USAID TASQC/Laptop/492	1	1069.50
1111	126	97	VNX5360593	TASQC/USAID TASQC/Laptop/490	1	1069.50
1112	126	97	VNX5340GXR	TASQC/USAID TASQC/Laptop/506	1	1069.50
1113	126	97	VNX534071C	TASQC/USAID TASQC/Laptop/497	1	1069.50
1114	126	97	VNX5340DNN	TASQC/USAID TASQC/Laptop/501	1	1069.50
1115	126	97	VNX5340KKD	TASQC/USAID TASQC/Laptop/495	1	1069.50
1116	127	98	SGSN-01106	TASQC/USAID TASQC/Chair/895	2	43.00
1117	127	98	SGSN-01107	TASQC/USAID TASQC/Chair/896	2	43.00
1118	127	98	SGSN-01108	TASQC/USAID TASQC/Chair/898	2	43.00
1119	127	98	SGSN-01109	TASQC/USAID TASQC/Chair/899	2	43.00
1120	127	98	SGSN-01110	TASQC/USAID TASQC/Chair/900	2	43.00
1121	127	98	SGSN-01111	TASQC/USAID TASQC/Chair/629	2	43.00
1122	127	98	SGSN-01112	TASQC/USAID TASQC/Chair/630	2	43.00
1123	127	98	SGSN-01113	TASQC/USAID TASQC/Chair/642	2	43.00
1124	127	98	SGSN-01114	TASQC/USAID TASQC/Chair/646	2	43.00
1125	127	98	SGSN-01115	TASQC/USAID TASQC/Chair/846	2	43.00
1126	127	98	SGSN-01116	TASQC/USAID TASQC/Chair/833	2	43.00
1127	127	98	SGSN-01117	TASQC/USAID TASQC/Chair/790	2	43.00
1128	127	98	SGSN-01118	TASQC/USAID TASQC/Chair/791	2	43.00
1129	127	98	SGSN-01119	TASQC/USAID TASQC/Chair/784	2	43.00
1130	127	98	SGSN-01120	TASQC/USAID TASQC/Chair/785	2	43.00
1131	127	98	SGSN-01121	TASQC/USAID TASQC/Chair/832	2	43.00
1132	127	98	SGSN-01122	TASQC/USAID TASQC/Chair/844	2	43.00
1133	127	98	SGSN-01123	TASQC/USAID TASQC/Chair/680	2	43.00
1134	127	98	SGSN-01124	TASQC/USAID TASQC/Chair/681	2	43.00
1135	127	98	SGSN-01125	TASQC/USAID TASQC/Chair/682	2	43.00
1136	127	98	SGSN-01126	TASQC/USAID TASQC/Chair/683	2	43.00
1137	127	98	SGSN-01127	TASQC/USAID TASQC/Chair/685	2	43.00
1138	127	98	SGSN-01128	TASQC/USAID TASQC/Chair/686	2	43.00
1139	127	98	SGSN-01129	TASQC/USAID TASQC/Chair/687	2	43.00
1140	127	98	SGSN-01130	TASQC/USAID TASQC/Chair/688	2	43.00
1141	127	98	SGSN-01131	TASQC/USAID TASQC/Chair/689	2	43.00
1142	127	98	SGSN-01132	TASQC/USAID TASQC/Chair/690	2	43.00
1143	127	98	SGSN-01133	TASQC/USAID TASQC/Chair/691	2	43.00
1144	127	98	SGSN-01134	TASQC/USAID TASQC/Chair/692	2	43.00
1145	127	98	SGSN-01135	TASQC/USAID TASQC/Chair/693	2	43.00
1146	127	98	SGSN-01136	TASQC/USAID TASQC/Chair/694	2	43.00
1147	127	98	SGSN-01137	TASQC/USAID TASQC/Chair/695	2	43.00
1148	127	98	SGSN-01138	TASQC/USAID TASQC/Chair/696	2	43.00
1149	127	98	SGSN-01139	TASQC/USAID TASQC/Chair/697	2	43.00
1150	127	98	SGSN-01140	TASQC/USAID TASQC/Chair/698	2	43.00
1151	127	98	SGSN-01141	TASQC/USAID TASQC/Chair/699	2	43.00
1152	127	98	SGSN-01142	TASQC/USAID TASQC/Chair/700	2	43.00
1153	127	98	SGSN-01143	TASQC/USAID TASQC/Chair/701	2	43.00
1154	127	98	SGSN-01144	TASQC/USAID TASQC/Chair/702	2	43.00
1155	127	98	SGSN-01145	TASQC/USAID TASQC/Chair/703	2	43.00
1156	127	98	SGSN-01146	TASQC/USAID TASQC/Chair/704	2	43.00
1157	127	98	SGSN-01147	TASQC/USAID TASQC/Chair/705	2	43.00
1158	127	98	SGSN-01148	TASQC/USAID TASQC/Chair/706	2	43.00
1159	127	98	SGSN-01149	TASQC/USAID TASQC/Chair/707	2	43.00
1160	127	98	SGSN-01150	TASQC/USAID TASQC/Chair/708	2	43.00
1161	127	98	SGSN-01151	TASQC/USAID TASQC/Chair/709	2	43.00
1162	127	98	SGSN-01152	TASQC/USAID TASQC/Chair/710	2	43.00
1163	127	98	SGSN-01153	TASQC/USAID TASQC/Chair/711	2	43.00
1164	127	98	SGSN-01154	TASQC/USAID TASQC/Chair/712	2	43.00
1165	127	98	SGSN-01155	TASQC/USAID TASQC/Chair/713	2	43.00
1166	127	98	SGSN-01156	TASQC/USAID TASQC/Chair/714	2	43.00
1167	127	98	SGSN-01157	TASQC/USAID TASQC/Chair/715	2	43.00
1168	127	98	SGSN-01158	TASQC/USAID TASQC/Chair/716	2	43.00
1169	127	98	SGSN-01159	TASQC/USAID TASQC/Chair/717	2	43.00
1170	127	98	SGSN-01160	TASQC/USAID TASQC/Chair/718	2	43.00
1171	127	98	SGSN-01161	TASQC/USAID TASQC/Chair/719	2	43.00
1172	127	98	SGSN-01162	TASQC/USAID TASQC/Chair/720	2	43.00
1173	127	98	SGSN-01163	TASQC/USAID TASQC/Chair/721	2	43.00
1174	127	98	SGSN-01164	TASQC/USAID TASQC/Chair/722	2	43.00
1175	127	98	SGSN-01165	TASQC/USAID TASQC/Chair/723	2	43.00
1176	127	98	SGSN-01166	TASQC/USAID TASQC/Chair/724	2	43.00
1177	127	98	SGSN-01167	TASQC/USAID TASQC/Chair/725	2	43.00
1178	127	98	SGSN-01168	TASQC/USAID TASQC/Chair/726	2	43.00
1179	127	98	SGSN-01169	TASQC/USAID TASQC/Chair/727	2	43.00
1180	127	98	SGSN-01170	TASQC/USAID TASQC/Chair/728	2	43.00
1181	127	98	SGSN-01171	TASQC/USAID TASQC/Chair/729	2	43.00
1182	127	98	SGSN-01172	TASQC/USAID TASQC/Chair/730	2	43.00
1183	127	98	SGSN-01173	TASQC/USAID TASQC/Chair/732	2	43.00
1184	127	98	SGSN-01174	TASQC/USAID TASQC/Chair/733	2	43.00
1185	127	98	SGSN-01175	TASQC/USAID TASQC/Chair/734	2	43.00
1186	127	98	SGSN-01176	TASQC/USAID TASQC/Chair/735	2	43.00
1187	127	98	SGSN-01177	TASQC/USAID TASQC/Chair/736	2	43.00
1188	127	98	SGSN-01178	TASQC/USAID TASQC/Chair/737	2	43.00
1189	127	98	SGSN-01179	TASQC/USAID TASQC/Chair/633	2	43.00
1190	127	98	SGSN-01180	TASQC/USAID TASQC/Chair/634	2	43.00
1191	127	98	SGSN-01181	TASQC/USAID TASQC/Chair/786	2	43.00
1192	127	98	SGSN-01182	TASQC/USAID TASQC/Chair/787	2	43.00
1193	127	98	SGSN-01183	TASQC/USAID TASQC/Chair/636	2	43.00
1194	127	98	SGSN-01184	TASQC/USAID TASQC/Chair/637	2	43.00
1195	127	98	SGSN-01185	TASQC/USAID TASQC/Chair/631	2	43.00
1196	127	98	SGSN-01186	TASQC/USAID TASQC/Chair/632	2	43.00
1197	127	98	SGSN-01187	TASQC/USAID TASQC/Chair/962	2	43.00
1198	127	98	SGSN-01188	TASQC/USAID TASQC/Chair/963	2	43.00
1199	127	98	SGSN-01189	TASQC/USAID TASQC/Chair/967	2	43.00
1200	127	98	SGSN-01190	TASQC/USAID TASQC/Chair/968	2	43.00
1201	127	98	SGSN-01191	TASQC/USAID TASQC/Chair/969	2	43.00
1202	127	98	SGSN-01192	TASQC/USAID TASQC/Chair/627	2	43.00
1203	127	98	SGSN-01193	TASQC/USAID TASQC/Chair/628	2	43.00
1204	127	98	SGSN-01194	TASQC/USAID TASQC/Chair/851	2	43.00
1205	127	98	SGSN-01195	TASQC/USAID TASQC/Chair/852	2	43.00
1206	127	98	SGSN-01196	TASQC/USAID TASQC/Chair/641	2	43.00
1207	127	98	SGSN-01197	TASQC/USAID TASQC/Chair/645	2	43.00
1208	127	98	SGSN-01198	TASQC/USAID TASQC/Chair/831	2	43.00
1209	127	98	SGSN-01199	TASQC/USAID TASQC/Chair/648	2	43.00
1210	127	98	SGSN-01200	TASQC/USAID TASQC/Chair/650	2	43.00
1211	127	98	SGSN-01201	TASQC/USAID TASQC/Chair/652	2	43.00
1212	127	98	SGSN-01202	TASQC/USAID TASQC/Chair/653	2	43.00
1213	127	98	SGSN-01203	TASQC/USAID TASQC/Chair/657	2	43.00
1214	127	98	SGSN-01204	TASQC/USAID TASQC/Chair/659	2	43.00
1215	127	98	SGSN-01205	TASQC/USAID TASQC/Chair/834	2	43.00
1216	127	98	SGSN-01206	TASQC/USAID TASQC/Chair/662	2	43.00
1217	127	98	SGSN-01207	TASQC/USAID TASQC/Chair/663	2	43.00
1218	127	98	SGSN-01208	TASQC/USAID TASQC/Chair/664	2	43.00
1219	127	98	SGSN-01209	TASQC/USAID TASQC/Chair/665	2	43.00
1220	127	98	SGSN-01210	TASQC/USAID TASQC/Chair/666	2	43.00
1221	127	98	SGSN-01211	TASQC/USAID TASQC/Chair/667	2	43.00
1222	127	98	SGSN-01212	TASQC/USAID TASQC/Chair/668	2	43.00
1223	127	98	SGSN-01213	TASQC/USAID TASQC/Chair/669	2	43.00
1224	127	98	SGSN-01214	TASQC/USAID TASQC/Chair/670	2	43.00
1225	127	98	SGSN-01215	TASQC/USAID TASQC/Chair/671	2	43.00
1226	127	98	SGSN-01216	TASQC/USAID TASQC/Chair/672	2	43.00
1227	127	98	SGSN-01217	TASQC/USAID TASQC/Chair/673	2	43.00
1228	127	98	SGSN-01218	TASQC/USAID TASQC/Chair/674	2	43.00
1229	127	98	SGSN-01219	TASQC/USAID TASQC/Chair/675	2	43.00
1230	127	98	SGSN-01220	TASQC/USAID TASQC/Chair/676	2	43.00
1231	127	98	SGSN-01221	TASQC/USAID TASQC/Chair/677	2	43.00
1232	127	98	SGSN-01222	TASQC/USAID TASQC/Chair/678	2	43.00
1233	127	98	SGSN-01223	TASQC/USAID TASQC/Chair/679	2	43.00
1234	127	98	SGSN-01224	TASQC/USAID TASQC/Chair/866	2	43.00
1235	127	98	SGSN-01225	TASQC/USAID TASQC/Chair/879	2	43.00
1236	127	98	SGSN-01226	TASQC/USAID TASQC/Chair/880	2	43.00
1237	127	98	SGSN-01227	TASQC/USAID TASQC/Chair/881	2	43.00
1238	127	98	SGSN-01228	TASQC/USAID TASQC/Chair/882	2	43.00
1239	127	98	SGSN-01229	TASQC/USAID TASQC/Chair/883	2	43.00
1240	127	98	SGSN-01230	TASQC/USAID TASQC/Chair/885	2	43.00
1241	127	98	SGSN-01231	TASQC/USAID TASQC/Chair/886	2	43.00
1242	127	98	SGSN-01232	TASQC/USAID TASQC/Chair/887	2	43.00
1243	127	98	SGSN-01233	TASQC/USAID TASQC/Chair/888	2	43.00
1244	127	98	SGSN-01234	TASQC/USAID TASQC/Chair/889	2	43.00
1245	127	98	SGSN-01235	TASQC/USAID TASQC/Chair/891	2	43.00
1246	128	98	SGSN-01236	TASQC/USAID TASQC/Chair/973	2	45.00
1247	128	98	SGSN-01237	TASQC/USAID TASQC/Chair/974	2	45.00
1248	128	98	SGSN-01238	TASQC/USAID TASQC/Chair/975	2	45.00
1249	128	98	SGSN-01239	TASQC/USAID TASQC/Chair/980	2	45.00
1250	127	98	SGSN-01240	TASQC/USAID TASQC/Chair/821	2	43.00
1251	127	98	SGSN-01241	TASQC/USAID TASQC/Chair/823	2	43.00
1252	127	98	SGSN-01242	TASQC/USAID TASQC/Chair/824	2	43.00
1253	127	98	SGSN-01243	TASQC/USAID TASQC/Chair/660	2	43.00
1254	127	98	SGSN-01244	TASQC/USAID TASQC/Chair/661	2	43.00
1255	127	98	SGSN-01245	TASQC/USAID TASQC/Chair/830	2	43.00
1256	127	98	SGSN-01246	TASQC/USAID TASQC/Chair/792	2	43.00
1257	127	98	SGSN-01247	TASQC/USAID TASQC/Chair/793	2	43.00
1258	127	98	SGSN-01248	TASQC/USAID TASQC/Chair/951	8	43.00
1259	127	98	SGSN-01249	TASQC/USAID TASQC/Chair/952	8	43.00
1260	127	98	SGSN-01250	TASQC/USAID TASQC/Chair/953	8	43.00
1261	127	98	SGSN-01251	TASQC/USAID TASQC/Chair/954	8	43.00
1262	127	98	SGSN-01252	TASQC/USAID TASQC/Chair/957	8	43.00
1263	127	98	SGSN-01253	TASQC/USAID TASQC/Chair/958	8	43.00
1264	127	98	SGSN-01254	TASQC/USAID TASQC/Chair/959	8	43.00
1265	127	98	SGSN-01255	TASQC/USAID TASQC/Chair/914	2	43.00
1266	127	98	SGSN-01256	TASQC/USAID TASQC/Chair/915	2	43.00
1267	127	98	SGSN-01257	TASQC/USAID TASQC/Chair/916	2	43.00
1268	127	98	SGSN-01258	TASQC/USAID TASQC/Chair/917	2	43.00
1269	127	98	SGSN-01259	TASQC/USAID TASQC/Chair/918	2	43.00
1270	127	98	SGSN-01260	TASQC/USAID TASQC/Chair/919	2	43.00
1271	127	98	SGSN-01261	TASQC/USAID TASQC/Chair/920	2	43.00
1272	127	98	SGSN-01262	TASQC/USAID TASQC/Chair/921	2	43.00
1273	127	98	SGSN-01263	TASQC/USAID TASQC/Chair/922	2	43.00
1274	127	98	SGSN-01264	TASQC/USAID TASQC/Chair/923	2	43.00
1275	127	98	SGSN-01265	TASQC/USAID TASQC/Chair/924	2	43.00
1276	127	98	SGSN-01266	TASQC/USAID TASQC/Chair/925	2	43.00
1277	127	98	SGSN-01267	TASQC/USAID TASQC/Chair/926	2	43.00
1278	127	98	SGSN-01268	TASQC/USAID TASQC/Chair/927	2	43.00
1279	127	98	SGSN-01269	TASQC/USAID TASQC/Chair/928	2	43.00
1280	127	98	SGSN-01270	TASQC/USAID TASQC/Chair/929	2	43.00
1281	127	98	SGSN-01271	TASQC/USAID TASQC/Chair/930	2	43.00
1282	127	98	SGSN-01272	TASQC/USAID TASQC/Chair/931	2	43.00
1283	127	98	SGSN-01273	TASQC/USAID TASQC/Chair/932	2	43.00
1284	127	98	SGSN-01274	TASQC/USAID TASQC/Chair/933	2	43.00
1285	127	98	SGSN-01275	TASQC/USAID TASQC/Chair/934	2	43.00
1286	127	98	SGSN-01276	TASQC/USAID TASQC/Chair/935	2	43.00
1287	127	98	SGSN-01277	TASQC/USAID TASQC/Chair/936	2	43.00
1288	127	98	SGSN-01278	TASQC/USAID TASQC/Chair/937	2	43.00
1289	127	98	SGSN-01279	TASQC/USAID TASQC/Chair/938	2	43.00
1290	127	98	SGSN-01280	TASQC/USAID TASQC/Chair/939	2	43.00
1291	127	98	SGSN-01281	TASQC/USAID TASQC/Chair/940	2	43.00
1292	127	98	SGSN-01282	TASQC/USAID TASQC/Chair/941	2	43.00
1293	127	98	SGSN-01283	TASQC/USAID TASQC/Chair/942	2	43.00
1294	127	98	SGSN-01284	TASQC/USAID TASQC/Chair/943	2	43.00
1295	127	98	SGSN-01285	TASQC/USAID TASQC/Chair/944	2	43.00
1296	127	98	SGSN-01286	TASQC/USAID TASQC/Chair/945	2	43.00
1297	127	98	SGSN-01287	TASQC/USAID TASQC/Chair/946	2	43.00
1298	127	98	SGSN-01288	TASQC/USAID TASQC/Chair/947	2	43.00
1299	127	98	SGSN-01289	TASQC/USAID TASQC/Chair/948	2	43.00
1300	127	98	SGSN-01290	TASQC/USAID TASQC/Chair/949	2	43.00
1301	127	98	SGSN-01291	TASQC/USAID TASQC/Chair/955	8	43.00
1302	127	98	SGSN-01292	TASQC/USAID TASQC/Chair/956	8	43.00
1303	127	98	SGSN-01293	TASQC/USAID TASQC/Chair/961	8	43.00
1304	127	98	SGSN-01294	TASQC/USAID TASQC/Chair/965	8	43.00
1305	127	98	SGSN-01295	TASQC/USAID TASQC/Chair/966	8	43.00
1306	127	98	SGSN-01296	TASQC/USAID TASQC/Chair/1026	2	43.00
1307	127	98	SGSN-01297	TASQC/USAID TASQC/Chair/1027	2	43.00
1308	127	98	SGSN-01298	TASQC/USAID TASQC/Chair/1028	2	43.00
1309	127	98	SGSN-01299	TASQC/USAID TASQC/Chair/1029	2	43.00
1310	127	98	SGSN-01300	TASQC/USAID TASQC/Chair/1041	2	43.00
1311	127	98	SGSN-01301	TASQC/USAID TASQC/Chair/907	2	43.00
1312	127	98	SGSN-01302	TASQC/USAID TASQC/Chair/908	2	43.00
1313	127	98	SGSN-01303	TASQC/USAID TASQC/Chair/909	2	43.00
1314	127	98	SGSN-01304	TASQC/USAID TASQC/Chair/910	2	43.00
1315	127	98	SGSN-01305	TASQC/USAID TASQC/Chair/911	2	43.00
1316	127	98	SGSN-01306	TASQC/USAID TASQC/Chair/510	2	43.00
1317	127	98	SGSN-01307	TASQC/USAID TASQC/Chair/511	2	43.00
1318	127	98	SGSN-01308	TASQC/USAID TASQC/Chair/512	2	43.00
1319	127	98	SGSN-01309	TASQC/USAID TASQC/Chair/513	2	43.00
1320	127	98	SGSN-01310	TASQC/USAID TASQC/Chair/514	2	43.00
1321	127	98	SGSN-01311	TASQC/USAID TASQC/Chair/515	2	43.00
1322	127	98	SGSN-01312	TASQC/USAID TASQC/Chair/516	2	43.00
1323	127	98	SGSN-01313	TASQC/USAID TASQC/Chair/517	2	43.00
1324	127	98	SGSN-01314	TASQC/USAID TASQC/Chair/518	2	43.00
1325	127	98	SGSN-01315	TASQC/USAID TASQC/Chair/519	2	43.00
1326	127	98	SGSN-01316	TASQC/USAID TASQC/Chair/520	2	43.00
1327	127	98	SGSN-01317	TASQC/USAID TASQC/Chair/521	2	43.00
1328	127	98	SGSN-01318	TASQC/USAID TASQC/Chair/522	2	43.00
1329	127	98	SGSN-01319	TASQC/USAID TASQC/Chair/523	2	43.00
1330	127	98	SGSN-01320	TASQC/USAID TASQC/Chair/524	2	43.00
1331	127	98	SGSN-01321	TASQC/USAID TASQC/Chair/525	2	43.00
1332	127	98	SGSN-01322	TASQC/USAID TASQC/Chair/526	2	43.00
1333	127	98	SGSN-01323	TASQC/USAID TASQC/Chair/527	2	43.00
1334	127	98	SGSN-01324	TASQC/USAID TASQC/Chair/528	2	43.00
1335	127	98	SGSN-01325	TASQC/USAID TASQC/Chair/529	2	43.00
1336	127	98	SGSN-01326	TASQC/USAID TASQC/Chair/530	2	43.00
1337	127	98	SGSN-01327	TASQC/USAID TASQC/Chair/531	2	43.00
1338	127	98	SGSN-01328	TASQC/USAID TASQC/Chair/532	2	43.00
1339	127	98	SGSN-01329	TASQC/USAID TASQC/Chair/533	2	43.00
1340	127	98	SGSN-01330	TASQC/USAID TASQC/Chair/534	2	43.00
1341	127	98	SGSN-01331	TASQC/USAID TASQC/Chair/535	2	43.00
1342	127	98	SGSN-01332	TASQC/USAID TASQC/Chair/536	2	43.00
1343	127	98	SGSN-01333	TASQC/USAID TASQC/Chair/537	2	43.00
1344	127	98	SGSN-01334	TASQC/USAID TASQC/Chair/538	2	43.00
1345	127	98	SGSN-01335	TASQC/USAID TASQC/Chair/539	2	43.00
1346	127	98	SGSN-01336	TASQC/USAID TASQC/Chair/540	2	43.00
1347	127	98	SGSN-01337	TASQC/USAID TASQC/Chair/541	2	43.00
1348	127	98	SGSN-01338	TASQC/USAID TASQC/Chair/542	2	43.00
1349	127	98	SGSN-01339	TASQC/USAID TASQC/Chair/543	2	43.00
1350	127	98	SGSN-01340	TASQC/USAID TASQC/Chair/544	2	43.00
1351	127	98	SGSN-01341	TASQC/USAID TASQC/Chair/545	2	43.00
1352	127	98	SGSN-01342	TASQC/USAID TASQC/Chair/546	2	43.00
1353	127	98	SGSN-01343	TASQC/USAID TASQC/Chair/547	2	43.00
1354	127	98	SGSN-01344	TASQC/USAID TASQC/Chair/548	2	43.00
1355	127	98	SGSN-01345	TASQC/USAID TASQC/Chair/549	2	43.00
1356	127	98	SGSN-01346	TASQC/USAID TASQC/Chair/550	2	43.00
1357	127	98	SGSN-01347	TASQC/USAID TASQC/Chair/551	2	43.00
1358	127	98	SGSN-01348	TASQC/USAID TASQC/Chair/552	2	43.00
1359	127	98	SGSN-01349	TASQC/USAID TASQC/Chair/553	2	43.00
1360	127	98	SGSN-01350	TASQC/USAID TASQC/Chair/554	2	43.00
1361	127	98	SGSN-01351	TASQC/USAID TASQC/Chair/555	2	43.00
1362	127	98	SGSN-01352	TASQC/USAID TASQC/Chair/556	2	43.00
1363	127	98	SGSN-01353	TASQC/USAID TASQC/Chair/798	2	43.00
1364	127	98	SGSN-01354	TASQC/USAID TASQC/Chair/799	2	43.00
1365	127	98	SGSN-01355	TASQC/USAID TASQC/Chair/800	2	43.00
1366	127	98	SGSN-01356	TASQC/USAID TASQC/Chair/801	2	43.00
1367	127	98	SGSN-01357	TASQC/USAID TASQC/Chair/803	2	43.00
1368	127	98	SGSN-01358	TASQC/USAID TASQC/Chair/808	2	43.00
1369	127	98	SGSN-01359	TASQC/USAID TASQC/Chair/837	2	43.00
1370	127	98	SGSN-01360	TASQC/USAID TASQC/Chair/838	2	43.00
1371	127	98	SGSN-01361	TASQC/USAID TASQC/Chair/839	2	43.00
1372	127	98	SGSN-01362	TASQC/USAID TASQC/Chair/841	2	43.00
1373	127	98	SGSN-01363	TASQC/USAID TASQC/Chair/842	2	43.00
1374	127	98	SGSN-01364	TASQC/USAID TASQC/Chair/843	2	43.00
1375	127	98	SGSN-01365	TASQC/USAID TASQC/Chair/635	2	43.00
1376	127	98	SGSN-01366	TASQC/USAID TASQC/Chair/638	2	43.00
1377	127	98	SGSN-01367	TASQC/USAID TASQC/Chair/639	2	43.00
1378	127	98	SGSN-01368	TASQC/USAID TASQC/Chair/640	2	43.00
1379	127	98	SGSN-01369	TASQC/USAID TASQC/Chair/643	2	43.00
1380	127	98	SGSN-01370	TASQC/USAID TASQC/Chair/644	2	43.00
1381	127	98	SGSN-01371	TASQC/USAID TASQC/Chair/647	2	43.00
1382	127	98	SGSN-01372	TASQC/USAID TASQC/Chair/649	2	43.00
1383	127	98	SGSN-01373	TASQC/USAID TASQC/Chair/651	2	43.00
1384	127	98	SGSN-01374	TASQC/USAID TASQC/Chair/654	2	43.00
1385	127	98	SGSN-01375	TASQC/USAID TASQC/Chair/655	2	43.00
1386	127	98	SGSN-01376	TASQC/USAID TASQC/Chair/658	2	43.00
1387	127	98	SGSN-01377	TASQC/USAID TASQC/Chair/746	2	43.00
1388	127	98	SGSN-01378	TASQC/USAID TASQC/Chair/748	2	43.00
1389	127	98	SGSN-01379	TASQC/USAID TASQC/Chair/753	2	43.00
1390	127	98	SGSN-01380	TASQC/USAID TASQC/Chair/754	2	43.00
1391	127	98	SGSN-01381	TASQC/USAID TASQC/Chair/756	2	43.00
1392	127	98	SGSN-01382	TASQC/USAID TASQC/Chair/758	2	43.00
1393	127	98	SGSN-01383	TASQC/USAID TASQC/Chair/759	2	43.00
1394	127	98	SGSN-01384	TASQC/USAID TASQC/Chair/760	2	43.00
1395	127	98	SGSN-01385	TASQC/USAID TASQC/Chair/762	2	43.00
1396	127	98	SGSN-01386	TASQC/USAID TASQC/Chair/763	2	43.00
1397	127	98	SGSN-01387	TASQC/USAID TASQC/Chair/766	2	43.00
1398	127	98	SGSN-01388	TASQC/USAID TASQC/Chair/768	2	43.00
1399	127	98	SGSN-01389	TASQC/USAID TASQC/Chair/769	2	43.00
1400	127	98	SGSN-01390	TASQC/USAID TASQC/Chair/772	2	43.00
1401	127	98	SGSN-01391	TASQC/USAID TASQC/Chair/773	2	43.00
1402	127	98	SGSN-01392	TASQC/USAID TASQC/Chair/774	2	43.00
1403	127	98	SGSN-01393	TASQC/USAID TASQC/Chair/775	2	43.00
1404	127	98	SGSN-01394	TASQC/USAID TASQC/Chair/776	2	43.00
1405	127	98	SGSN-01395	TASQC/USAID TASQC/Chair/778	2	43.00
1406	127	98	SGSN-01396	TASQC/USAID TASQC/Chair/779	2	43.00
1407	127	98	SGSN-01397	TASQC/USAID TASQC/Chair/780	2	43.00
1408	127	98	SGSN-01398	TASQC/USAID TASQC/Chair/781	2	43.00
1409	127	98	SGSN-01399	TASQC/USAID TASQC/Chair/782	2	43.00
1410	127	98	SGSN-01400	TASQC/USAID TASQC/Chair/783	2	43.00
1411	127	98	SGSN-01401	TASQC/USAID TASQC/Chair/788	2	43.00
1412	127	98	SGSN-01402	TASQC/USAID TASQC/Chair/794	2	43.00
1413	127	98	SGSN-01403	TASQC/USAID TASQC/Chair/795	2	43.00
1414	127	98	SGSN-01404	TASQC/USAID TASQC/Chair/797	2	43.00
1415	127	98	SGSN-01405	TASQC/USAID TASQC/Chair/1083	2	43.00
1416	127	98	SGSN-01406	TASQC/USAID TASQC/Chair/1084	2	43.00
1417	127	98	SGSN-01407	TASQC/USAID TASQC/Chair/1085	2	43.00
1418	127	98	SGSN-01408	TASQC/USAID TASQC/Chair/1086	2	43.00
1419	127	98	SGSN-01409	TASQC/USAID TASQC/Chair/1087	2	43.00
1420	127	98	SGSN-01410	TASQC/USAID TASQC/Chair/849	2	43.00
1421	127	98	SGSN-01411	TASQC/USAID TASQC/Chair/868	2	43.00
1422	127	98	SGSN-01412	TASQC/USAID TASQC/Chair/869	2	43.00
1423	127	98	SGSN-01413	TASQC/USAID TASQC/Chair/870	2	43.00
1424	127	98	SGSN-01414	TASQC/USAID TASQC/Chair/871	2	43.00
1425	127	98	SGSN-01415	TASQC/USAID TASQC/Chair/872	2	43.00
1426	127	98	SGSN-01416	TASQC/USAID TASQC/Chair/873	2	43.00
1427	127	98	SGSN-01417	TASQC/USAID TASQC/Chair/874	2	43.00
1428	127	98	SGSN-01418	TASQC/USAID TASQC/Chair/875	2	43.00
1429	127	98	SGSN-01419	TASQC/USAID TASQC/Chair/893	2	43.00
1430	127	98	SGSN-01420	TASQC/USAID TASQC/Chair/854	2	43.00
1431	127	98	SGSN-01421	TASQC/USAID TASQC/Chair/855	2	43.00
1432	127	98	SGSN-01422	TASQC/USAID TASQC/Chair/857	2	43.00
1433	127	98	SGSN-01423	TASQC/USAID TASQC/Chair/858	2	43.00
1434	127	98	SGSN-01424	TASQC/USAID TASQC/Chair/859	2	43.00
1435	127	98	SGSN-01425	TASQC/USAID TASQC/Chair/860	2	43.00
1436	127	98	SGSN-01426	TASQC/USAID TASQC/Chair/861	2	43.00
1437	127	98	SGSN-01427	TASQC/USAID TASQC/Chair/863	2	43.00
1438	127	98	SGSN-01428	TASQC/USAID TASQC/Chair/864	2	43.00
1439	127	98	SGSN-01429	TASQC/USAID TASQC/Chair/865	2	43.00
1440	127	98	SGSN-01430	TASQC/USAID TASQC/Chair/906	2	43.00
1441	127	98	SGSN-01431	TASQC/USAID TASQC/Chair/738	2	43.00
1442	127	98	SGSN-01432	TASQC/USAID TASQC/Chair/739	2	43.00
1443	127	98	SGSN-01433	TASQC/USAID TASQC/Chair/740	2	43.00
1444	127	98	SGSN-01434	TASQC/USAID TASQC/Chair/741	2	43.00
1445	127	98	SGSN-01435	TASQC/USAID TASQC/Chair/742	2	43.00
1446	127	98	SGSN-01436	TASQC/USAID TASQC/Chair/743	2	43.00
1447	127	98	SGSN-01437	TASQC/USAID TASQC/Chair/744	2	43.00
1448	127	98	SGSN-01438	TASQC/USAID TASQC/Chair/745	2	43.00
1449	127	98	SGSN-01439	TASQC/USAID TASQC/Chair/747	2	43.00
1450	127	98	SGSN-01440	TASQC/USAID TASQC/Chair/749	2	43.00
1451	127	98	SGSN-01441	TASQC/USAID TASQC/Chair/750	2	43.00
1452	127	98	SGSN-01442	TASQC/USAID TASQC/Chair/751	2	43.00
1453	127	98	SGSN-01443	TASQC/USAID TASQC/Chair/764	2	43.00
1454	127	98	SGSN-01444	TASQC/USAID TASQC/Chair/765	2	43.00
1455	127	98	SGSN-01445	TASQC/USAID TASQC/Chair/767	2	43.00
1456	127	98	SGSN-01446	TASQC/USAID TASQC/Chair/770	2	43.00
1457	127	98	SGSN-01447	TASQC/USAID TASQC/Chair/771	2	43.00
1458	127	98	SGSN-01448	TASQC/USAID TASQC/Chair/777	2	43.00
1459	127	98	SGSN-01449	TASQC/USAID TASQC/Chair/806	2	43.00
1460	127	98	SGSN-01450	TASQC/USAID TASQC/Chair/807	2	43.00
1461	127	98	SGSN-01451	TASQC/USAID TASQC/Chair/809	2	43.00
1462	127	98	SGSN-01452	TASQC/USAID TASQC/Chair/810	2	43.00
1463	127	98	SGSN-01453	TASQC/USAID TASQC/Chair/812	2	43.00
1464	127	98	SGSN-01454	TASQC/USAID TASQC/Chair/813	2	43.00
1465	127	98	SGSN-01455	TASQC/USAID TASQC/Chair/816	2	43.00
1466	127	98	SGSN-01456	TASQC/USAID TASQC/Chair/817	2	43.00
1467	127	98	SGSN-01457	TASQC/USAID TASQC/Chair/818	2	43.00
1468	127	98	SGSN-01458	TASQC/USAID TASQC/Chair/819	2	43.00
1469	127	98	SGSN-01459	TASQC/USAID TASQC/Chair/827	2	43.00
1470	127	98	SGSN-01460	TASQC/USAID TASQC/Chair/828	2	43.00
1471	127	98	SGSN-01461	TASQC/USAID TASQC/Chair/829	2	43.00
1472	127	98	SGSN-01462	TASQC/USAID TASQC/Chair/835	2	43.00
1473	127	98	SGSN-01463	TASQC/USAID TASQC/Chair/836	2	43.00
1474	127	98	SGSN-01464	TASQC/USAID TASQC/Chair/845	2	43.00
1475	127	98	SGSN-01465	TASQC/USAID TASQC/Chair/847	2	43.00
1476	127	98	SGSN-01466	TASQC/USAID TASQC/Chair/848	2	43.00
1477	127	98	SGSN-01467	TASQC/USAID TASQC/Chair/850	2	43.00
1478	127	98	SGSN-01468	TASQC/USAID TASQC/Chair/853	2	43.00
1479	127	98	SGSN-01469	TASQC/USAID TASQC/Chair/1088	2	43.00
1480	127	98	SGSN-01470	TASQC/USAID TASQC/Chair/1089	2	43.00
1481	127	98	SGSN-01471	TASQC/USAID TASQC/Chair/1090	2	43.00
1482	127	98	SGSN-01472	TASQC/USAID TASQC/Chair/1091	2	43.00
1483	127	98	SGSN-01473	TASQC/USAID TASQC/Chair/1092	2	43.00
1484	127	98	SGSN-01474	TASQC/USAID TASQC/Chair/1093	2	43.00
1485	127	98	SGSN-01475	TASQC/USAID TASQC/Chair/1095	2	43.00
1486	127	98	SGSN-01476	TASQC/USAID TASQC/Chair/1096	2	43.00
1487	127	98	SGSN-01477	TASQC/USAID TASQC/Chair/1097	2	43.00
1488	127	98	SGSN-01478	TASQC/USAID TASQC/Chair/1098	2	43.00
1489	127	98	SGSN-01479	TASQC/USAID TASQC/Chair/1099	2	43.00
1490	127	98	SGSN-01480	TASQC/USAID TASQC/Chair/1100	2	43.00
1491	127	98	SGSN-01481	TASQC/USAID TASQC/Chair/1101	2	43.00
1492	127	98	SGSN-01482	TASQC/USAID TASQC/Chair/1102	2	43.00
1493	127	98	SGSN-01483	TASQC/USAID TASQC/Chair/1103	2	43.00
1494	129	99	SGSN-01484	TASQC/USAID TASQC/Table/67	2	90.57
1495	129	99	SGSN-01485	TASQC/USAID TASQC/Table/66	2	90.57
1496	129	99	SGSN-01486	TASQC/USAID TASQC/Table/108	2	90.57
1497	129	99	SGSN-01487	TASQC/USAID TASQC/Table/101	2	90.57
1498	129	99	SGSN-01488	TASQC/USAID TASQC/Table/98	2	90.57
1499	129	99	SGSN-01489	TASQC/USAID TASQC/Table/59	2	90.57
1500	129	99	SGSN-01490	TASQC/USAID TASQC/Table/99	2	90.57
1501	129	99	SGSN-01491	TASQC/USAID TASQC/Table/105	2	90.57
1502	129	99	SGSN-01492	TASQC/USAID TASQC/Table/107	2	90.57
1503	129	99	SGSN-01493	TASQC/USAID TASQC/Table/54	2	90.57
1504	129	99	SGSN-01494	TASQC/USAID TASQC/Table/130	2	90.57
1505	129	99	SGSN-01495	TASQC/USAID TASQC/Table/176	2	90.57
1506	129	99	SGSN-01496	TASQC/USAID TASQC/Table/118	2	90.57
1507	129	99	SGSN-01497	TASQC/USAID TASQC/Table/111	2	90.57
1508	129	99	SGSN-01498	TASQC/USAID TASQC/Table/102	2	90.57
1509	129	99	SGSN-01499	TASQC/USAID TASQC/Table/155	8	90.57
1510	129	99	SGSN-01500	TASQC/USAID TASQC/Table/127	2	90.57
1511	129	99	SGSN-01501	TASQC/USAID TASQC/Table/25	2	90.57
1512	129	99	SGSN-01502	TASQC/USAID TASQC/Table/26	2	90.57
1513	129	99	SGSN-01503	TASQC/USAID TASQC/Table/27	2	90.57
1514	129	99	SGSN-01504	TASQC/USAID TASQC/Table/28	2	90.57
1515	129	99	SGSN-01505	TASQC/USAID TASQC/Table/33	2	90.57
1516	129	99	SGSN-01506	TASQC/USAID TASQC/Table/34	2	90.57
1517	129	99	SGSN-01507	TASQC/USAID TASQC/Table/35	2	90.57
1518	129	99	SGSN-01508	TASQC/USAID TASQC/Table/36	2	90.57
1519	129	99	SGSN-01509	TASQC/USAID TASQC/Table/37	2	90.57
1520	129	99	SGSN-01510	TASQC/USAID TASQC/Table/38	2	90.57
1521	129	99	SGSN-01511	TASQC/USAID TASQC/Table/39	2	90.57
1522	129	99	SGSN-01512	TASQC/USAID TASQC/Table/157	8	90.57
1523	129	99	SGSN-01513	TASQC/USAID TASQC/Table/174	2	90.57
1524	129	99	SGSN-01514	TASQC/USAID TASQC/Table/159	2	90.57
1525	129	99	SGSN-01515	TASQC/USAID TASQC/Table/160	2	90.57
1526	129	99	SGSN-01516	TASQC/USAID TASQC/Table/161	2	90.57
1527	129	99	SGSN-01517	TASQC/USAID TASQC/Table/162	2	90.57
1528	129	99	SGSN-01518	TASQC/USAID TASQC/Table/68	2	90.57
1529	129	99	SGSN-01519	TASQC/USAID TASQC/Table/69	2	90.57
1530	129	99	SGSN-01520	TASQC/USAID TASQC/Table/70	2	90.57
1531	129	99	SGSN-01521	TASQC/USAID TASQC/Table/74	2	90.57
1532	129	99	SGSN-01522	TASQC/USAID TASQC/Table/88	2	90.57
1533	129	99	SGSN-01523	TASQC/USAID TASQC/Table/89	2	90.57
1534	129	99	SGSN-01524	TASQC/USAID TASQC/Table/90	2	90.57
1535	129	99	SGSN-01525	TASQC/USAID TASQC/Table/91	2	90.57
1536	129	99	SGSN-01526	TASQC/USAID TASQC/Table/92	2	90.57
1537	129	99	SGSN-01527	TASQC/USAID TASQC/Table/93	2	90.57
1538	129	99	SGSN-01528	TASQC/USAID TASQC/Table/94	2	90.57
1539	129	99	SGSN-01529	TASQC/USAID TASQC/Table/95	2	90.57
1540	129	99	SGSN-01530	TASQC/USAID TASQC/Table/96	2	90.57
1541	129	99	SGSN-01531	TASQC/USAID TASQC/Table/97	2	90.57
1542	129	99	SGSN-01532	TASQC/USAID TASQC/Table/100	2	90.57
1543	129	99	SGSN-01533	TASQC/USAID TASQC/Table/185	2	90.57
1544	129	99	SGSN-01534	TASQC/USAID TASQC/Table/186	2	90.57
1545	129	99	SGSN-01535	TASQC/USAID TASQC/Table/129	2	90.57
1546	129	99	SGSN-01536	TASQC/USAID TASQC/Table/175	2	90.57
1547	129	99	SGSN-01537	TASQC/USAID TASQC/Table/187	2	90.57
1548	129	99	SGSN-01538	TASQC/USAID TASQC/Table/188	2	90.57
1549	129	99	SGSN-01539	TASQC/USAID TASQC/Table/189	2	90.57
1550	122	100	SGSN-01540	TASQC/USAID TASQC/Tent/66	2	450.00
1551	122	100	SGSN-01541	TASQC/USAID TASQC/Tent/67	2	450.00
1552	130	100	SGSN-01542	SANOFI/SANOFI/Tent/118	2	875.15
1553	122	100	SGSN-01543	TASQC/USAID TASQC/Tent/68	2	450.00
1554	130	100	SGSN-01544	SANOFI/SANOFI/Tent/116	2	875.15
1555	130	100	SGSN-01545	SANOFI/SANOFI/Tent/115	2	875.15
1556	122	100	SGSN-01546	TASQC/USAID TASQC/Tent/81	2	450.00
1557	131	101	ICR1070K1P	TASQC/USAID TASQC/Monitor/13	2	250.00
1558	131	101	ICR1070JYZ	TASQC/USAID TASQC/Monitor/15	2	250.00
1559	131	101	ICR1070JZI	TASQC/USAID TASQC/Monitor/14	2	250.00
1560	131	101	ICR1070JZF	TASQC/USAID TASQC/Monitor/16	2	250.00
1561	132	102	358421270656081	TASQC/USAID TASQC/Cell-Phone/266	2	145.00
1562	132	102	358421279872705	TASQC/USAID TASQC/Cell-Phone/500	2	145.00
1563	132	102	358421278737826	TASQC/USAID TASQC/Cell-Phone/505	3	145.00
1564	132	102	358421270653625	TASQC/USAID TASQC/Cell-Phone/260	2	145.00
1565	132	102	358421270679125	TASQC/USAID TASQC/Cell-Phone/257	2	145.00
1566	133	103	5CD324P061	TASQC/USAID TASQC/Laptop/433	2	1013.00
1567	133	103	5CD324P0FW	TASQC/USAID TASQC/Laptop/436	2	1013.00
1568	133	103	5CD324P0NN	TASQC/USAID TASQC/Laptop/466	2	1013.00
1569	133	103	5CD324P05D	TASQC/USAID TASQC/Laptop/452	2	1013.00
1570	133	103	5CD324P0CJ	TASQC/USAID TASQC/Laptop/439	2	1013.00
1571	133	103	5CD324P06L	TASQC/USAID TASQC/Laptop/440	2	1013.00
1572	133	103	5CD324P05K	TASQC/USAID TASQC/Laptop/408	3	1013.00
1573	133	103	5CD324P02G	TASQC/USAID TASQC/Laptop/442	3	1013.00
1574	133	103	5CD324P042	TASQC/USAID TASQC/Laptop/419	3	1013.00
1575	134	103	5CD324P09P	TASQC/USAID TASQC/Laptop/477	2	989.00
1576	133	103	5CD324P0H6	TASQC/USAID TASQC/Laptop/424	8	1013.00
1577	135	103	8CG228829P0	TASQC/USAID TASQC/Laptop/390	2	1680.00
1578	133	103	5CD324P05C	TASQC/USAID TASQC/Laptop/402	2	1013.00
1579	133	103	5CD324P06N	TASQC/USAID TASQC/Laptop/405	2	1013.00
1580	133	103	5CD324P05Y	TASQC/USAID TASQC/Laptop/417	2	1013.00
1581	133	103	5CD324P05M	TASQC/USAID TASQC/Laptop/429	2	1013.00
1582	133	103	5CD324P0HC	TASQC/USAID TASQC/Laptop/438	2	1013.00
1583	133	103	5CD324P0J8	TASQC/USAID TASQC/Laptop/464	2	1013.00
1584	136	103	5CD132FVSF	TASQC/USAID TASQC/Laptop/240	2	1450.00
1585	133	103	5CD324P06B	TASQC/USAID TASQC/Laptop/454	2	1013.00
1586	133	103	5CD324P04B	TASQC/USAID TASQC/Laptop/427	2	1013.00
1587	133	103	5CD324P052	TASQC/USAID TASQC/Laptop/465	2	1013.00
1588	133	103	5CD324P04X	TASQC/USAID TASQC/Laptop/463	2	1013.00
1589	137	103	5CD132FVSR	TASQC-COVIDGO/USAID TASQC-COVIDGO/Laptop/267	2	1450.00
1590	133	103	5CD324P05R	TASQC/USAID TASQC/Laptop/461	2	1013.00
1591	133	103	5CD324P057	TASQC/USAID TASQC/Laptop/420	2	1013.00
1592	133	103	5CD324P03Q	TASQC/USAID TASQC/Laptop/404	2	1013.00
1593	138	103	5CD4076QKS	TASQC/USAID TASQC/Laptop/482	2	1028.00
1594	139	103	5CD147BDRN	TASQC/USAID TASQC/Laptop/304	2	1603.00
1595	133	103	5CD324P0FY	TASQC/USAID TASQC/Laptop/451	2	1013.00
1596	140	103	5CD147BFY2	TASQC/USAID TASQC/Laptop/287	2	1603.00
1597	133	103	5CD324P06R	TASQC/USAID TASQC/Laptop/426	2	1013.00
1598	136	103	5CD132FVW2	TASQC/USAID TASQC/Laptop/235	2	1450.00
1599	140	103	5CD147BG7M	TASQC/USAID TASQC/Laptop/292	2	1603.00
1600	133	103	5CD324P06G	TASQC/USAID TASQC/Laptop/403	2	1013.00
1601	139	103	5CD134CXMJ	TASQC/USAID TASQC/Laptop/305	2	1603.00
1602	133	103	5CD324P050	TASQC/USAID TASQC/Laptop/459	2	1013.00
1603	133	103	5CD324P05B	TASQC/USAID TASQC/Laptop/448	2	1013.00
1604	136	103	5CD132FVKJ	TASQC/USAID TASQC/Laptop/228	2	1450.00
1605	133	103	5CD324P05V	TASQC/USAID TASQC/Laptop/415	2	1013.00
1606	140	103	5CD1347YFL	TASQC/USAID TASQC/Laptop/295	2	1603.00
1607	138	103	5CD4061LY1	TASQC/USAID TASQC/Laptop/479	2	1028.00
1608	133	103	5CD324NZRR	TASQC/USAID TASQC/Laptop/450	2	1013.00
1609	133	103	5CD324P05T	TASQC/USAID TASQC/Laptop/423	2	1013.00
1610	133	103	5CD324P060	TASQC/USAID TASQC/Laptop/472	2	1013.00
1611	133	103	5CD324P048	TASQC/USAID TASQC/Laptop/457	2	1013.00
1612	137	103	5CD132FVNY	TASQC-COVIDGO/USAID TASQC-COVIDGO/Laptop/275	3	1450.00
1613	133	103	5CD324P056	TASQC/USAID TASQC/Laptop/422	2	1013.00
1614	133	103	5CD324P04W	TASQC/USAID TASQC/Laptop/421	2	1013.00
1615	133	103	5CD324P0F5	TASQC/USAID TASQC/Laptop/458	2	1013.00
1616	133	103	5CD324P058	TASQC/USAID TASQC/Laptop/409	2	1013.00
1617	133	103	5CD324P0G8	TASQC/USAID TASQC/Laptop/430	2	1013.00
1618	133	103	5CD324P01N	TASQC/USAID TASQC/Laptop/406	2	1013.00
1619	133	103	5CD324P05P	TASQC/USAID TASQC/Laptop/432	2	1013.00
1620	133	103	5CD324P0G9	TASQC/USAID TASQC/Laptop/413	2	1013.00
1621	133	103	5CD324NZZ9	TASQC/USAID TASQC/Laptop/407	2	1013.00
1622	137	103	5CD132FVM5	TASQC-COVIDGO/USAID TASQC-COVIDGO/Laptop/265	2	1450.00
1623	138	103	5CD324P0LH	TASQC/USAID TASQC/Laptop/484	2	1028.00
1624	134	103	5CD324NZXX	TASQC/USAID TASQC/Laptop/478	2	989.00
1625	133	103	5CD324P05S	TASQC/USAID TASQC/Laptop/473	2	1013.00
1626	133	103	5CD324P0NX	TASQC/USAID TASQC/Laptop/418	2	1013.00
1627	133	103	5CD324P003	TASQC/USAID TASQC/Laptop/456	2	1013.00
1628	133	103	5CD324P0D9	TASQC/USAID TASQC/Laptop/449	2	1013.00
1629	133	103	5CD324P07T	TASQC/USAID TASQC/Laptop/410	2	1013.00
1630	133	103	5CD324P05N	TASQC/USAID TASQC/Laptop/435	2	1013.00
1631	133	103	5CD324P06H	TASQC/USAID TASQC/Laptop/416	2	1013.00
1632	133	103	5CD324P05W	TASQC/USAID TASQC/Laptop/453	2	1013.00
1633	136	103	5CD132FVRL	TASQC/USAID TASQC/Laptop/227	2	1450.00
1634	139	103	5CD134CXK3	TASQC/USAID TASQC/Laptop/315	2	1603.00
1635	133	103	5CD324P059	TASQC/USAID TASQC/Laptop/462	2	1013.00
1636	133	103	5CD324P0S7	TASQC/USAID TASQC/Laptop/474	2	1013.00
1637	133	103	5CD324P02F	TASQC/USAID TASQC/Laptop/412	2	1013.00
1638	133	103	5CD324P05F	TASQC/USAID TASQC/Laptop/444	2	1013.00
1639	13	104	VKA37361	TASQC/USAID TASQC/Monitor/33	2	500.00
1640	141	105	AGI4713	OPHID/OPHID/Vehicle/64	2	41550.00
1641	142	106	5CD105779Z	TASQC/USAID TASQC/Laptop/64	2	1395.00
1642	143	106	5CD122FW6NC	TASQC/USAID TASQC/Laptop/184	2	1375.00
1643	142	106	5CD1057827	TASQC/USAID TASQC/Laptop/34	2	1395.00
1644	142	106	5CD10577B4	TASQC/USAID TASQC/Laptop/48	2	1395.00
1645	143	106	5CD122FWCK	TASQC/USAID TASQC/Laptop/192	8	1375.00
1646	143	106	5CD122FWCJ	TASQC/USAID TASQC/Laptop/174	8	1375.00
1647	143	106	5CD122FVSWC	TASQC/USAID TASQC/Laptop/209	8	1375.00
1648	142	106	5CD1057844	TASQC/USAID TASQC/Laptop/41	2	1395.00
1649	143	106	5CD122FVN7C	TASQC/USAID TASQC/Laptop/208	2	1375.00
1650	142	106	5CD105782F	TASQC/USAID TASQC/Laptop/57	8	1395.00
1651	142	106	5CD10577KZ	TASQC/USAID TASQC/Laptop/30	2	1395.00
1652	142	106	5CD105778Y	TASQC/USAID TASQC/Laptop/98	2	1395.00
1653	142	106	5CD105782G	TASQC/USAID TASQC/Laptop/25	2	1395.00
1654	142	106	5CD105783K	TASQC/USAID TASQC/Laptop/70	2	1395.00
1655	142	106	5CD10577RH	TASQC/USAID TASQC/Laptop/95	2	1395.00
1656	142	106	5CD1057839	TASQC/USAID TASQC/Laptop/29	2	1395.00
1657	143	106	5CD122FVXJ	TASQC/USAID TASQC/Laptop/215	8	1375.00
1658	143	106	5CD122FVYGC	TASQC/USAID TASQC/Laptop/219	2	1375.00
1659	142	106	5CD10577DL	TASQC/USAID TASQC/Laptop/3	2	1395.00
1660	142	106	5CD105783B	TASQC/USAID TASQC/Laptop/42	2	1395.00
1661	142	106	5CD105783J	TASQC/USAID TASQC/Laptop/96	8	1395.00
1662	143	106	5CD122FW2JC	TASQC/USAID TASQC/Laptop/175	8	1375.00
1663	142	106	5CD10577BG	TASQC/USAID TASQC/Laptop/28	2	1395.00
1664	143	106	5CD122FVQGC	TASQC/USAID TASQC/Laptop/217	8	1375.00
1665	142	106	5CD10577BC	TASQC/USAID TASQC/Laptop/49	8	1395.00
1666	142	106	5CD10577CH	TASQC/USAID TASQC/Laptop/18	2	1395.00
1667	142	106	5CD1057842	TASQC/USAID TASQC/Laptop/81	8	1395.00
1668	143	106	5CD122FW1PC	TASQC/USAID TASQC/Laptop/194	2	1375.00
1669	142	106	5CD105784J	TASQC/USAID TASQC/Laptop/40	2	1395.00
1670	142	106	5CD1057813	TASQC/USAID TASQC/Laptop/86	2	1395.00
1671	142	106	5CD10577HB	TASQC/USAID TASQC/Laptop/58	2	1395.00
1672	142	106	5CD10577BW	TASQC/USAID TASQC/Laptop/55	2	1395.00
1673	142	106	5CD10577JY	TASQC/USAID TASQC/Laptop/13	2	1395.00
1674	142	106	5CD10577SB	TASQC/USAID TASQC/Laptop/91	2	1395.00
1675	142	106	5CD1057847	TASQC/USAID TASQC/Laptop/90	2	1395.00
1676	144	106	R9WR20N1C0J	TASQC/USAID TASQC/Cell-Phone/1186	2	255.33
1677	143	106	5CD122FVYYC	TASQC/USAID TASQC/Laptop/204	2	1375.00
1678	142	106	5CD10577SG	TASQC/USAID TASQC/Laptop/17	2	1395.00
1679	143	106	5CD122FW73	TASQC/USAID TASQC/Laptop/189	2	1375.00
1680	143	106	5CD122FVW1 	TASQC/USAID TASQC/Laptop/213	2	1375.00
1681	142	106	5CD1057826	TASQC/USAID TASQC/Laptop/63	2	1395.00
1682	142	106	5CD105784Y	TASQC/USAID TASQC/Laptop/14	2	1395.00
1683	142	106	5CD105782B	TASQC/USAID TASQC/Laptop/92	2	1395.00
1684	142	106	5CD10577DW	TASQC/USAID TASQC/Laptop/60	2	1395.00
1685	143	106	5CD122FVWB	TASQC/USAID TASQC/Laptop/201	8	1375.00
1686	143	106	5CD122FW8BC	TASQC/USAID TASQC/Laptop/176	8	1375.00
1687	142	106	5CD105775Y	TASQC/USAID TASQC/Laptop/20	2	1395.00
1688	142	106	5CD1057837	TASQC/USAID TASQC/Laptop/99	8	1395.00
1689	142	106	5CD10577DS	TASQC/USAID TASQC/Laptop/84	2	1395.00
1690	142	106	5CD105783X	TASQC/USAID TASQC/Laptop/51	2	1395.00
1691	142	106	5CD105782N	TASQC/USAID TASQC/Laptop/62	2	1395.00
1692	142	106	5CD10577DJ	TASQC/USAID TASQC/Laptop/36	2	1395.00
1693	142	106	5CD1057843	TASQC/USAID TASQC/Laptop/38	2	1395.00
1694	142	106	5CD105781Z	TASQC/USAID TASQC/Laptop/94	3	1395.00
1695	142	106	5CD10577BM	TASQC/USAID TASQC/Laptop/11	2	1395.00
1696	143	106	5CD122FW7MC	TASQC/USAID TASQC/Laptop/205	2	1375.00
1697	142	106	5CD105781H	TASQC/USAID TASQC/Laptop/71	2	1395.00
1698	142	106	5CD10577YJ	TASQC/USAID TASQC/Laptop/65	2	1395.00
1699	13	107	60X- 1307120482	TASQC/USAID TASQC/Shredder/5	2	220.00
1700	145	107	PM1931701991	TASQC/USAID TASQC/Shredder/1	2	1800.00
1701	13	108	SGSN-01691	TASQC/USAID TASQC/Chair/400	2	120.00
1702	13	108	SGSN-01692	TASQC/USAID TASQC/Chair/401	2	120.00
1703	13	108	SGSN-01693	TASQC/USAID TASQC/Chair/402	2	120.00
1704	13	108	SGSN-01694	TASQC/USAID TASQC/Chair/403	2	120.00
1705	13	108	SGSN-01695	TASQC/USAID TASQC/Chair/404	2	120.00
1706	13	108	SGSN-01696	TASQC/USAID TASQC/Chair/405	2	120.00
1707	13	108	SGSN-01697	TASQC/USAID TASQC/Chair/406	2	120.00
1708	13	108	SGSN-01698	TASQC/USAID TASQC/Chair/407	2	120.00
1709	13	109	SGSN-01699	TASQC/USAID TASQC/Fan/47	2	35.00
1710	13	109	SGSN-01700	TASQC/USAID TASQC/Fan/60	2	35.00
1711	13	109	SGSN-01701	TASQC/USAID TASQC/Fan/83	2	40.00
1712	13	109	SGSN-01702	TASQC/USAID TASQC/Fan/20	2	35.00
1713	13	109	SGSN-01703	TASQC/USAID TASQC/Fan/49	2	50.00
1714	13	109	SGSN-01704	TASQC/USAID TASQC/Fan/63	2	40.00
1715	13	109	SGSN-01705	TASQC/USAID TASQC/Fan/57	2	35.00
1716	13	109	SGSN-01706	TASQC/USAID TASQC/Fan/61	2	45.00
1717	13	109	SGSN-01707	TASQC/USAID TASQC/Fan/56	2	35.00
1718	13	109	SGSN-01708	TASQC/USAID TASQC/Fan/45	2	65.00
1719	13	109	SGSN-01709	TASQC/USAID TASQC/Fan/46	2	35.00
1720	13	109	SGSN-01710	TASQC/USAID TASQC/Fan/51	2	40.00
1721	13	109	SGSN-01711	TASQC/USAID TASQC/Fan/59	2	45.00
1722	146	110	SGSN-01712	TASQC/USAID TASQC/Fan/42	8	120.00
1723	13	111	SGSN-01713	TASQC/USAID TASQC/Table/24	2	200.00
1724	13	112	SGSN-01714	TASQC/USAID TASQC/Heater/26	2	45.00
1725	147	112	SGSN-01715	TASQC/USAID TASQC/Heater/34	2	60.00
1726	13	112	SGSN-01716	TASQC/USAID TASQC/Heater/24	2	45.00
1727	13	112	SGSN-01717	TASQC/USAID TASQC/Heater/25	2	45.00
1728	13	112	SGSN-01718	TASQC/USAID TASQC/Heater/28	2	45.00
1729	13	112	SGSN-01719	TASQC/USAID TASQC/Heater/29	2	45.00
1730	13	112	SGSN-01720	TASQC/USAID TASQC/Heater/36	2	50.00
1731	148	113	SGSN-01721	TASQC/USAID TASQC/Safe/2	2	300.00
1732	148	113	SGSN-01722	TASQC/USAID TASQC/Safe/5	2	300.00
1733	149	113	SGSN-01723	TASQC/USAID TASQC/Safe/12	2	300.00
1734	13	113	SGSN-01724	TASQC/USAID TASQC/Safe/18	2	300.00
1735	150	113	SGSN-01725	TASQC/USAID TASQC/Safe/14	2	300.00
1736	13	113	SGSN-01726	TASQC/USAID TASQC/Safe/19	2	300.00
1737	147	113	SGSN-01727	TASQC/USAID TASQC/Safe/10	2	350.00
1738	150	113	SGSN-01728	TASQC/USAID TASQC/Safe/13	2	300.00
1739	149	113	SGSN-01729	TASQC/USAID TASQC/Safe/17	2	300.00
1740	151	113	SGSN-01730	TASQC/USAID TASQC/Safe/8	2	300.00
1741	149	113	SGSN-01731	TASQC/USAID TASQC/Safe/11	2	300.00
1742	148	113	SGSN-01732	TASQC/USAID TASQC/Safe/6	2	300.00
1743	13	113	SGSN-01733	TASQC/USAID TASQC/Safe/15	2	300.00
1744	149	113	SGSN-01734	TASQC/USAID TASQC/Safe/9	2	300.00
1745	148	113	SGSN-01735	TASQC/USAID TASQC/Safe/3	2	300.00
1746	149	113	SGSN-01736	TASQC/USAID TASQC/Safe/16	2	1000.00
1747	148	113	SGSN-01737	TASQC/USAID TASQC/Safe/7	2	300.00
1748	148	113	SGSN-01738	TASQC/USAID TASQC/Safe/1	2	300.00
1749	148	113	SGSN-01739	TASQC/USAID TASQC/Safe/4	2	1000.00
1750	152	114	5G183114K4	TASQC/USAID TASQC/Scanner/1	2	700.00
1751	13	115	SGSN-01741	TASQC/USAID TASQC/Microwave /2	2	250.00
1752	114	116	X4K20700086	TASQC/USAID TASQC/Projector/2	2	300.00
1753	13	116	X4K20700075	TASQC/USAID TASQC/Projector/1	2	300.00
1754	13	116	SGSN-01744	TASQC/USAID TASQC/Projector/3	2	200.00
1755	153	117	1DDA1262256	TASQC/USAID TASQC/Projector-screen/10	2	1255.00
1756	153	117	1DDA1260556	TASQC/USAID TASQC/Projector-screen/8	2	1255.00
1757	153	117	1DDA510955	TASQC/USAID TASQC/Projector-screen/2	2	1255.00
1758	153	117	1DDA1260573	TASQC/USAID TASQC/Projector-screen/7	2	1255.00
1759	153	117	1DDA510740	TASQC/USAID TASQC/Projector-screen/4	2	1255.00
1760	153	117	1DDA1262250	TASQC/USAID TASQC/Projector-screen/5	2	1255.00
1761	153	117	1DDA510754	TASQC/USAID TASQC/Projector-screen/1	2	1255.00
1762	153	117	1DDA1265439	TASQC/USAID TASQC/Projector-screen/6	2	1255.00
1763	13	118	SGSN-01753	TASQC/USAID TASQC/Suggestion Box/2	2	45.00
1764	13	118	SGSN-01754	TASQC/USAID TASQC/Suggestion Box/4	2	70.00
1765	13	118	SGSN-01755	TASQC/USAID TASQC/Suggestion Box/3	2	65.00
1766	13	119	SGSN-01756	TASQC/USAID TASQC/Chair/369	2	120.00
1767	55	119	SGSN-01757	TASQC/USAID TASQC/Chair/50	2	150.00
1768	13	119	SGSN-01758	TASQC/USAID TASQC/Chair/462	2	120.00
1769	55	119	SGSN-01759	TASQC/USAID TASQC/Chair/22	2	150.00
1770	55	119	SGSN-01760	TASQC/USAID TASQC/Chair/39	2	150.00
1771	55	119	SGSN-01761	TASQC/USAID TASQC/Chair/2	2	150.00
1772	55	119	SGSN-01762	TASQC/USAID TASQC/Chair/1	2	150.00
1773	13	119	SGSN-01763	TASQC/USAID TASQC/Chair/267	2	120.00
1774	13	119	SGSN-01764	TASQC/USAID TASQC/Chair/294	2	120.00
1775	13	119	SGSN-01765	TASQC/USAID TASQC/Chair/367	2	120.00
1776	13	119	SGSN-01766	TASQC/USAID TASQC/Chair/370	2	120.00
1777	55	119	SGSN-01767	TASQC/USAID TASQC/Chair/23	2	150.00
1778	154	119	SGSN-01768	TASQC/USAID TASQC/Chair/1107	2	300.00
1779	55	119	SGSN-01769	TASQC/USAID TASQC/Chair/47	2	150.00
1780	55	119	SGSN-01770	TASQC/USAID TASQC/Chair/24	2	150.00
1781	13	119	SGSN-01771	TASQC/USAID TASQC/Chair/290	2	120.00
1782	13	119	SGSN-01772	TASQC/USAID TASQC/Chair/281	2	120.00
1783	13	119	SGSN-01773	TASQC/USAID TASQC/Chair/276	2	120.00
1784	55	119	SGSN-01774	TASQC/USAID TASQC/Chair/33	2	150.00
1785	13	119	SGSN-01775	TASQC/USAID TASQC/Chair/252	2	120.00
1786	155	119	SGSN-01776	TASQC/USAID TASQC/Chair/1105	2	228.67
1787	55	119	SGSN-01777	TASQC/USAID TASQC/Chair/10	2	150.00
1788	55	119	SGSN-01778	TASQC/USAID TASQC/Chair/18	2	150.00
1789	55	119	SGSN-01779	TASQC/USAID TASQC/Chair/19	2	150.00
1790	13	119	SGSN-01780	TASQC/USAID TASQC/Chair/387	2	110.00
1791	55	119	SGSN-01781	TASQC/USAID TASQC/Chair/40	2	150.00
1792	13	119	SGSN-01782	TASQC/USAID TASQC/Chair/463	2	120.00
1793	13	119	SGSN-01783	TASQC/USAID TASQC/Chair/262	2	120.00
1794	13	119	SGSN-01784	TASQC/USAID TASQC/Chair/264	2	120.00
1795	13	119	SGSN-01785	TASQC/USAID TASQC/Chair/287	2	120.00
1796	13	119	SGSN-01786	TASQC/USAID TASQC/Chair/297	2	120.00
1797	13	119	SGSN-01787	TASQC/USAID TASQC/Chair/298	2	120.00
1798	55	119	SGSN-01788	TASQC/USAID TASQC/Chair/3	2	150.00
1799	55	119	SGSN-01789	TASQC/USAID TASQC/Chair/17	2	150.00
1800	13	119	SGSN-01790	TASQC/USAID TASQC/Chair/289	2	120.00
1801	55	119	SGSN-01791	TASQC/USAID TASQC/Chair/35	2	150.00
1802	55	119	SGSN-01792	TASQC/USAID TASQC/Chair/29	2	150.00
1803	13	119	SGSN-01793	TASQC/USAID TASQC/Chair/502	2	120.00
1804	13	119	SGSN-01794	TASQC/USAID TASQC/Chair/260	2	120.00
1805	22	119	SGSN-01795	TASQC/USAID TASQC/Chair/464	2	190.00
1806	22	119	SGSN-01796	TASQC/USAID TASQC/Chair/466	2	190.00
1807	147	119	SGSN-01797	TASQC/USAID TASQC/Chair/474	2	240.00
1808	13	119	SGSN-01798	TASQC/USAID TASQC/Chair/1043	2	150.00
1809	13	119	SGSN-01799	TASQC/USAID TASQC/Chair/266	2	120.00
1810	55	119	SGSN-01800	TASQC/USAID TASQC/Chair/25	2	150.00
1811	55	119	SGSN-01801	TASQC/USAID TASQC/Chair/27	2	150.00
1812	55	119	SGSN-01802	TASQC/USAID TASQC/Chair/30	2	150.00
1813	13	119	SGSN-01803	TASQC/USAID TASQC/Chair/255	2	120.00
1814	13	119	SGSN-01804	TASQC/USAID TASQC/Chair/283	2	120.00
1815	13	119	SGSN-01805	TASQC/USAID TASQC/Chair/274	2	120.00
1816	13	119	SGSN-01806	TASQC/USAID TASQC/Chair/275	2	120.00
1817	13	119	SGSN-01807	TASQC/USAID TASQC/Chair/377	2	110.00
1818	13	119	SGSN-01808	TASQC/USAID TASQC/Chair/392	2	120.00
1819	13	119	SGSN-01809	TASQC/USAID TASQC/Chair/393	2	120.00
1820	13	119	SGSN-01810	TASQC/USAID TASQC/Chair/394	2	120.00
1821	13	119	SGSN-01811	TASQC/USAID TASQC/Chair/423	2	120.00
1822	13	119	SGSN-01812	TASQC/USAID TASQC/Chair/424	2	120.00
1823	13	119	SGSN-01813	TASQC/USAID TASQC/Chair/425	2	120.00
1824	13	119	SGSN-01814	TASQC/USAID TASQC/Chair/427	2	120.00
1825	55	119	SGSN-01815	TASQC/USAID TASQC/Chair/31	2	150.00
1826	55	119	SGSN-01816	TASQC/USAID TASQC/Chair/32	2	150.00
1827	55	119	SGSN-01817	TASQC/USAID TASQC/Chair/34	2	150.00
1828	13	119	SGSN-01818	TASQC/USAID TASQC/Chair/461	2	120.00
1829	55	119	SGSN-01819	TASQC/USAID TASQC/Chair/37	2	150.00
1830	55	119	SGSN-01820	TASQC/USAID TASQC/Chair/8	2	150.00
1831	13	119	SGSN-01821	TASQC/USAID TASQC/Chair/253	2	120.00
1832	13	119	SGSN-01822	TASQC/USAID TASQC/Chair/288	2	120.00
1833	13	119	SGSN-01823	TASQC/USAID TASQC/Chair/254	2	120.00
1834	13	119	SGSN-01824	TASQC/USAID TASQC/Chair/259	2	120.00
1835	13	119	SGSN-01825	TASQC/USAID TASQC/Chair/250	2	120.00
1836	13	119	SGSN-01826	TASQC/USAID TASQC/Chair/269	2	120.00
1837	155	119	SGSN-01827	TASQC/USAID TASQC/Chair/1104	2	228.67
1838	55	119	SGSN-01828	TASQC/USAID TASQC/Chair/5	2	150.00
1839	13	119	SGSN-01829	TASQC/USAID TASQC/Chair/372	2	120.00
1840	55	119	SGSN-01830	TASQC/USAID TASQC/Chair/6	2	150.00
1841	55	119	SGSN-01831	TASQC/USAID TASQC/Chair/7	2	150.00
1842	55	119	SGSN-01832	TASQC/USAID TASQC/Chair/11	2	150.00
1843	55	119	SGSN-01833	TASQC/USAID TASQC/Chair/12	2	150.00
1844	55	119	SGSN-01834	TASQC/USAID TASQC/Chair/14	2	150.00
1845	55	119	SGSN-01835	TASQC/USAID TASQC/Chair/15	2	150.00
1846	55	119	SGSN-01836	TASQC/USAID TASQC/Chair/16	2	150.00
1847	13	119	SGSN-01837	TASQC/USAID TASQC/Chair/284	2	120.00
1848	13	119	SGSN-01838	TASQC/USAID TASQC/Chair/373	2	120.00
1849	13	119	SGSN-01839	TASQC/USAID TASQC/Chair/279	2	120.00
1850	13	119	SGSN-01840	TASQC/USAID TASQC/Chair/499	2	120.00
1851	13	119	SGSN-01841	TASQC/USAID TASQC/Chair/500	2	120.00
1852	13	119	SGSN-01842	TASQC/USAID TASQC/Chair/503	2	120.00
1853	13	119	SGSN-01843	TASQC/USAID TASQC/Chair/285	2	120.00
1854	13	119	SGSN-01844	TASQC/USAID TASQC/Chair/286	2	120.00
1855	13	119	SGSN-01845	TASQC/USAID TASQC/Chair/295	2	120.00
1856	13	119	SGSN-01846	TASQC/USAID TASQC/Chair/426	2	120.00
1857	55	119	SGSN-01847	TASQC/USAID TASQC/Chair/4	2	150.00
1858	55	119	SGSN-01848	TASQC/USAID TASQC/Chair/42	2	150.00
1859	55	119	SGSN-01849	TASQC/USAID TASQC/Chair/43	2	150.00
1860	13	119	SGSN-01850	TASQC/USAID TASQC/Chair/280	2	120.00
1861	155	119	SGSN-01851	TASQC/USAID TASQC/Chair/1106	2	228.67
1862	13	119	SGSN-01852	TASQC/USAID TASQC/Chair/265	2	120.00
1863	13	119	SGSN-01853	TASQC/USAID TASQC/Chair/271	2	120.00
1864	13	119	SGSN-01854	TASQC/USAID TASQC/Chair/277	2	120.00
1865	13	120	358893198477719	TASQC/USAID TASQC/Tablet/1	8	450.00
1866	156	121	357358142898759	TRIPLE-P/TRIPLE-P/Cell-Phone/1221	2	280.00
1867	156	121	357358142898775	TRIPLE-P/TRIPLE-P/Cell-Phone/1226	2	280.00
1868	156	121	357358142958132	TRIPLE-P/TRIPLE-P/Cell-Phone/1214	2	280.00
1869	156	121	357358142898601	TRIPLE-P/TRIPLE-P/Cell-Phone/1222	2	280.00
1870	157	121	RWNR20X6PEJ	TASQC/USAID TASQC/Cell-Phone/557	2	455.00
1871	158	121	R9WNBOFK75J	TASQC/USAID TASQC/Cell-Phone/355	2	415.00
1872	156	121	357358142956565	TRIPLE-P/TRIPLE-P/Cell-Phone/1218	2	280.00
1873	157	121	356054118257549	TASQC/USAID TASQC/Cell-Phone/930	8	455.00
1874	157	121	351089963396765	TASQC/USAID TASQC/Cell-Phone/932	8	455.00
1875	157	121	351089962312409	TASQC/USAID TASQC/Cell-Phone/939	8	455.00
1876	156	121	357358142956359	TRIPLE-P/TRIPLE-P/Cell-Phone/1213	2	280.00
1877	158	121	R9WR20N0TLJ	TASQC/USAID TASQC/Cell-Phone/356	8	415.00
1878	156	121	357358142898882	TRIPLE-P/TRIPLE-P/Cell-Phone/1227	2	280.00
1879	157	121	351089963396872	TASQC/USAID TASQC/Cell-Phone/931	8	455.00
1880	157	121	356196381215611	TASQC/USAID TASQC/Cell-Phone/990	2	455.00
1881	157	121	351089960293411	TASQC/USAID TASQC/Cell-Phone/1021	2	455.00
1882	158	121	356196382707483	TASQC/USAID TASQC/Cell-Phone/358	2	415.00
1883	158	121	R9WR20X6PAJ	TASQC/USAID TASQC/Cell-Phone/1153	2	415.00
1884	158	121	351089963396906	TASQC/USAID TASQC/Cell-Phone/322	2	415.00
1885	158	121	356196383267081	TASQC/USAID TASQC/Cell-Phone/285	2	415.00
1886	158	121	356196383263569	TASQC/USAID TASQC/Cell-Phone/365	2	415.00
1887	156	121	357358142896522	TRIPLE-P/TRIPLE-P/Cell-Phone/1230	2	280.00
1888	157	121	351089962312698	TASQC/USAID TASQC/Cell-Phone/564	2	455.00
1889	156	121	357358142898791	TRIPLE-P/TRIPLE-P/Cell-Phone/1228	2	280.00
1890	156	121	357358142894568	TRIPLE-P/TRIPLE-P/Cell-Phone/1223	2	280.00
1891	158	121	351089963396120	TASQC/USAID TASQC/Cell-Phone/294	2	415.00
1892	156	121	357358142895672	TRIPLE-P/TRIPLE-P/Cell-Phone/1229	2	280.00
1893	158	121	356196383235526	TASQC/USAID TASQC/Cell-Phone/325	2	415.00
1894	156	121	357358142956789	TRIPLE-P/TRIPLE-P/Cell-Phone/1219	2	280.00
1895	156	121	357358142957415	TRIPLE-P/TRIPLE-P/Cell-Phone/1215	2	280.00
1896	158	121	356196383235500	TASQC/USAID TASQC/Cell-Phone/283	2	415.00
1897	144	122	R9WR20MYLAJ	TASQC/USAID TASQC/Cell-Phone/1143	2	255.33
1898	159	123	SGSN-01888	TASQC/USAID TASQC/Table/19	2	200.00
1899	159	123	SGSN-01889	TASQC/USAID TASQC/Table/20	2	200.00
1900	159	123	SGSN-01890	TASQC/USAID TASQC/Table/21	2	200.00
1901	159	123	SGSN-01891	TASQC/USAID TASQC/Table/22	2	200.00
1902	62	124	355041992697743	TASQC/USAID TASQC/Cell-Phone/135	3	232.50
1903	62	124	R9WR20NO2LJ	TASQC/USAID TASQC/Cell-Phone/199	2	232.50
1904	144	124	357035514121891	TASQC/USAID TASQC/Cell-Phone/373	2	255.33
1905	62	124	355041992337829	TASQC/USAID TASQC/Cell-Phone/74	8	232.50
1906	62	124	355041992331657	TASQC/USAID TASQC/Cell-Phone/19	2	232.50
1907	62	124	R9WNBOOFHP1J	TASQC/USAID TASQC/Cell-Phone/213	2	232.50
1908	144	124	358893195175258	TASQC/USAID TASQC/Cell-Phone/544	2	255.00
1909	144	124	358893195171596	TASQC/USAID TASQC/Cell-Phone/1130	3	255.33
1910	62	124	355041992688585	TASQC/USAID TASQC/Cell-Phone/24	8	232.50
1911	62	124	355041992699442	TASQC/USAID TASQC/Cell-Phone/57	2	232.50
1912	62	124	358893195461112	TASQC/USAID TASQC/Cell-Phone/126	8	232.50
1913	62	124	355041992336722	TASQC/USAID TASQC/Cell-Phone/53	2	232.50
1914	62	124	R9WR41166MJ	TASQC/USAID TASQC/Cell-Phone/185	2	232.50
1915	144	124	358893195155847	TASQC/USAID TASQC/Cell-Phone/1133	3	255.33
1916	62	124	358893199260684	TASQC/USAID TASQC/Cell-Phone/68	2	232.50
1917	62	124	R9WNBOFK5BJ	TASQC/USAID TASQC/Cell-Phone/216	2	232.50
1918	62	124	355041992701024	TASQC/USAID TASQC/Cell-Phone/136	2	232.50
1919	62	124	355041992335724	TASQC/USAID TASQC/Cell-Phone/131	8	232.50
1920	144	124	358893195170150	TASQC/USAID TASQC/Cell-Phone/454	2	255.33
1921	62	124	355041992336201	TASQC/USAID TASQC/Cell-Phone/101	2	232.50
1922	144	124	358893195166679	TASQC/USAID TASQC/Cell-Phone/1134	3	255.33
1923	62	124	355041992331400	TASQC/USAID TASQC/Cell-Phone/87	2	232.50
1924	62	124	358893199262870	TASQC/USAID TASQC/Cell-Phone/139	2	232.50
1925	144	124	R9WNBOFHXDJ	TASQC/USAID TASQC/Cell-Phone/438	8	255.33
1926	62	124	355041992331277	TASQC/USAID TASQC/Cell-Phone/43	2	232.50
1927	62	124	355041992328307	TASQC/USAID TASQC/Cell-Phone/1180	2	232.50
1928	144	124	R9WR414GNJ	TASQC/USAID TASQC/Cell-Phone/464	3	255.33
1929	144	124	R9WR4144MEJ	TASQC/USAID TASQC/Cell-Phone/463	3	255.33
1930	62	124	355041992701347	TASQC/USAID TASQC/Cell-Phone/29	3	232.50
1931	62	124	355041992698733	TASQC/USAID TASQC/Cell-Phone/58	3	232.50
1932	62	124	R9WR4115DPJ	TASQC/USAID TASQC/Cell-Phone/222	2	232.50
1933	62	124	355041992699483	TASQC/USAID TASQC/Cell-Phone/82	3	232.50
1934	160	124	352035569395262	LSHTM/LSHTM-ZVATINODA/Cell-Phone/1238	2	157.00
1935	62	124	355041992700596	TASQC/USAID TASQC/Cell-Phone/121	2	232.50
1936	62	124	355041992328224	TASQC/USAID TASQC/Cell-Phone/61	2	232.50
1937	62	124	355041992700521	TASQC/USAID TASQC/Cell-Phone/75	3	232.50
1938	62	124	R9WNB0FK5YJ	TASQC/USAID TASQC/Cell-Phone/179	2	232.50
1939	62	124	R9WR20N112J	TASQC/USAID TASQC/Cell-Phone/172	2	232.50
1940	62	124	355041992696216	TASQC/USAID TASQC/Cell-Phone/96	2	232.50
1941	62	124	355041992698550	TASQC/USAID TASQC/Cell-Phone/1156	2	232.50
1942	62	124	355041992689336	TASQC/USAID TASQC/Cell-Phone/76	8	232.50
1943	144	124	358893195183450	TASQC/USAID TASQC/Cell-Phone/385	2	255.33
1944	62	124	R9WR4115YAJ	TASQC/USAID TASQC/Cell-Phone/221	2	232.50
1945	62	124	358893195154733	TASQC/USAID TASQC/Cell-Phone/1178	2	232.50
1946	62	124	357035517488735	TASQC/USAID TASQC/Cell-Phone/97	2	232.50
1947	62	124	355041992336565	TASQC/USAID TASQC/Cell-Phone/85	2	232.50
1948	62	124	R9WR4115H5J	TASQC/USAID TASQC/Cell-Phone/226	2	232.50
1949	62	124	355041992331681	TASQC/USAID TASQC/Cell-Phone/59	3	232.50
1950	62	124	355041994602931	TASQC/USAID TASQC/Cell-Phone/64	2	232.50
1951	62	124	355041992700463	TASQC/USAID TASQC/Cell-Phone/124	3	232.50
1952	144	124	R9WNB0FHZ2J	TASQC/USAID TASQC/Cell-Phone/460	3	255.33
1953	62	124	355041992697966	TASQC/USAID TASQC/Cell-Phone/51	2	232.50
1954	144	124	358893195156977	TASQC/USAID TASQC/Cell-Phone/1135	3	255.33
1955	62	124	355041992699970	TASQC/USAID TASQC/Cell-Phone/84	3	232.50
1956	62	124	355041992700059	TASQC/USAID TASQC/Cell-Phone/17	2	232.50
1957	144	124	R9WR50LMPCJ	TASQC/USAID TASQC/Cell-Phone/465	3	255.33
1958	62	124	R9WNB0FK5QJ	TASQC/USAID TASQC/Cell-Phone/157	2	232.50
1959	62	124	R9WR4115GBJ	TASQC/USAID TASQC/Cell-Phone/223	2	232.50
1960	62	124	R9WNB0FK5TJ	TASQC/USAID TASQC/Cell-Phone/171	2	232.50
1961	62	124	357035515516867	TASQC/USAID TASQC/Cell-Phone/21	2	232.50
1962	62	124	357035154128144	TASQC/USAID TASQC/Cell-Phone/150	2	232.50
1963	62	124	355041992697974	TASQC/USAID TASQC/Cell-Phone/26	2	232.50
1964	62	124	355041992337423	TASQC/USAID TASQC/Cell-Phone/202	3	232.50
1965	62	124	355041992328372	TASQC/USAID TASQC/Cell-Phone/73	2	232.50
1966	62	124	357035516358632	TASQC/USAID TASQC/Cell-Phone/10	2	232.50
1967	62	124	355041992335328	TASQC/USAID TASQC/Cell-Phone/50	2	232.50
1968	144	124	R9WNBOFK5NJ	TASQC/USAID TASQC/Cell-Phone/431	8	255.33
1969	144	124	R9WNBOFHYPJ	TASQC/USAID TASQC/Cell-Phone/432	8	255.33
1970	62	124	355041992336425	TASQC/USAID TASQC/Cell-Phone/123	8	232.50
1971	62	124	355041992336136	TASQC/USAID TASQC/Cell-Phone/81	2	232.50
1972	62	124	357035514122261	TASQC/USAID TASQC/Cell-Phone/145	8	232.50
1973	62	124	359306105120602	TASQC/USAID TASQC/Cell-Phone/154	2	232.50
1974	161	124	358893198480325	TASQC-COVIDGO/USAID TASQC-COVIDGO/Cell-Phone/1082	8	255.00
1975	62	124	358893195183286	TASQC/USAID TASQC/Cell-Phone/207	2	232.50
1976	62	124	355041992701321	TASQC/USAID TASQC/Cell-Phone/11	8	232.50
1977	62	124	357035514128235	TASQC/USAID TASQC/Cell-Phone/146	2	232.50
1978	62	124	R9WNB0FHHBJ	TASQC/USAID TASQC/Cell-Phone/158	2	232.50
1979	62	124	355041992697826	TASQC/USAID TASQC/Cell-Phone/138	2	232.50
1980	62	124	358893195155649	TASQC/USAID TASQC/Cell-Phone/231	2	232.50
1981	144	124	R9WR4144CPJ	TASQC/USAID TASQC/Cell-Phone/471	3	255.33
1982	144	124	355041992334016	TASQC/USAID TASQC/Cell-Phone/382	2	255.33
1983	62	124	355041992699517	TASQC/USAID TASQC/Cell-Phone/104	2	232.50
1984	62	124	357035514124309	TASQC/USAID TASQC/Cell-Phone/80	2	232.50
1985	62	124	355041992700315	TASQC/USAID TASQC/Cell-Phone/54	2	232.50
1986	144	124	R9WNB0FK4XJ	TASQC/USAID TASQC/Cell-Phone/420	2	255.33
1987	144	124	359306105035644	TASQC/USAID TASQC/Cell-Phone/488	2	255.33
1988	144	124	358893195155318	TASQC/USAID TASQC/Cell-Phone/1140	3	255.33
1989	144	124	R9WNBOFHKNJ	TASQC/USAID TASQC/Cell-Phone/444	8	255.33
1990	144	124	355041992697958	TASQC/USAID TASQC/Cell-Phone/374	2	255.33
1991	62	124	355041992700455	TASQC/USAID TASQC/Cell-Phone/129	2	232.50
1992	144	124	358893195180514	TASQC/USAID TASQC/Cell-Phone/1142	3	255.33
1993	144	124	R9WNB0FHMBJ	TASQC/USAID TASQC/Cell-Phone/447	8	255.33
1994	144	124	R9WNB0FHKKJ	TASQC/USAID TASQC/Cell-Phone/448	8	255.33
1995	144	124	R9WR4143PBJ	TASQC/USAID TASQC/Cell-Phone/470	3	255.33
1996	62	124	R9WNB0FHMDJ	TASQC/USAID TASQC/Cell-Phone/181	2	232.50
1997	144	124	R9WR4144CEJ	TASQC/USAID TASQC/Cell-Phone/462	2	255.33
1998	62	124	355041992700067	TASQC/USAID TASQC/Cell-Phone/1157	8	232.50
1999	62	124	355041992326608	TASQC/USAID TASQC/Cell-Phone/88	2	232.50
2000	144	124	358893195183203	TASQC/USAID TASQC/Cell-Phone/376	2	255.33
2001	62	124	356136107796643	TASQC/USAID TASQC/Cell-Phone/91	2	232.50
2002	144	124	355041992336169	TASQC/USAID TASQC/Cell-Phone/383	2	255.33
2003	62	124	355041992331210	TASQC/USAID TASQC/Cell-Phone/44	2	232.50
2004	62	124	355041992337837	TASQC/USAID TASQC/Cell-Phone/151	2	232.50
2005	62	124	355041992334610	TASQC/USAID TASQC/Cell-Phone/153	2	232.50
2006	144	124	358893195176942	TASQC/USAID TASQC/Cell-Phone/387	2	255.33
2007	62	124	355041992331673	TASQC/USAID TASQC/Cell-Phone/105	2	232.50
2008	144	124	R9WR20MYMYJ	TASQC/USAID TASQC/Cell-Phone/459	3	255.33
2087	62	124	R9WNB2C20GJ	TASQC/USAID TASQC/Cell-Phone/166	2	232.50
2009	62	124	355041992336672	TASQC/USAID TASQC/Cell-Phone/102	2	232.50
2010	144	124	357035514124457	TASQC/USAID TASQC/Cell-Phone/379	2	255.33
2011	144	124	R9WNB0FK53J	TASQC/USAID TASQC/Cell-Phone/461	3	255.33
2012	62	124	355041992699418	TASQC/USAID TASQC/Cell-Phone/55	2	232.50
2013	62	124	355041995676744	TASQC/USAID TASQC/Cell-Phone/109	2	232.50
2014	144	124	357035514127468	TASQC/USAID TASQC/Cell-Phone/1137	3	255.33
2015	62	124	357035514125348	TASQC/USAID TASQC/Cell-Phone/1179	2	232.50
2016	62	124	357035514128193	TASQC/USAID TASQC/Cell-Phone/244	2	232.50
2017	144	124	R9WNB1WARZJ	TASQC/USAID TASQC/Cell-Phone/468	3	255.33
2018	144	124	355041992337340	TASQC/USAID TASQC/Cell-Phone/384	2	255.33
2019	144	124	357035514123251	TASQC/USAID TASQC/Cell-Phone/375	2	255.33
2020	144	124	R9WR4144LXJ	TASQC/USAID TASQC/Cell-Phone/466	3	255.33
2021	62	124	355041992702410	TASQC/USAID TASQC/Cell-Phone/112	2	232.50
2022	62	124	355041992337290	TASQC/USAID TASQC/Cell-Phone/103	8	232.50
2023	62	124	R9WR20N0RMJ	TASQC/USAID TASQC/Cell-Phone/218	2	232.50
2024	144	124	357035514123517	TASQC/USAID TASQC/Cell-Phone/1040	2	255.33
2025	62	124	355041992700349	TASQC/USAID TASQC/Cell-Phone/7	3	232.50
2026	62	124	357035516361925	TASQC/USAID TASQC/Cell-Phone/37	8	232.50
2027	62	124	355041992331525	TASQC/USAID TASQC/Cell-Phone/118	8	232.50
2028	144	124	R9WNBOFKH5J	TASQC/USAID TASQC/Cell-Phone/425	2	255.33
2029	62	124	355041992700083	TASQC/USAID TASQC/Cell-Phone/36	2	232.50
2030	62	124	355041992699335	TASQC/USAID TASQC/Cell-Phone/16	2	232.50
2031	62	124	R9WR4115GRJ	TASQC/USAID TASQC/Cell-Phone/183	2	232.50
2032	144	124	358893195163098	TASQC/USAID TASQC/Cell-Phone/386	2	255.33
2033	62	124	357035514122014	TASQC/USAID TASQC/Cell-Phone/1175	2	232.50
2034	62	124	355041992698147	TASQC/USAID TASQC/Cell-Phone/108	2	232.50
2035	62	124	355041992699913	TASQC/USAID TASQC/Cell-Phone/72	8	232.50
2036	62	124	355041992696638	TASQC/USAID TASQC/Cell-Phone/83	2	232.50
2037	62	124	355041992700612	TASQC/USAID TASQC/Cell-Phone/128	2	232.50
2038	62	124	355041992701180	TASQC/USAID TASQC/Cell-Phone/39	2	232.50
2039	62	124	358893195184185	TASQC/USAID TASQC/Cell-Phone/206	2	232.50
2040	62	124	355041992330915	TASQC/USAID TASQC/Cell-Phone/60	2	232.50
2041	62	124	355041992700174	TASQC/USAID TASQC/Cell-Phone/119	8	232.50
2042	144	124	R9WR4144H2J	TASQC/USAID TASQC/Cell-Phone/467	3	255.33
2043	62	124	357035514122642	TASQC/USAID TASQC/Cell-Phone/1174	2	232.50
2044	62	124	355041992699228	TASQC/USAID TASQC/Cell-Phone/22	2	232.50
2045	62	124	355041992701156	TASQC/USAID TASQC/Cell-Phone/18	2	232.50
2046	62	124	35504199269897	TASQC/USAID TASQC/Cell-Phone/152	2	232.50
2047	62	124	357035514126130	TASQC/USAID TASQC/Cell-Phone/1171	2	232.50
2048	62	124	R9WR4115YLJ	TASQC/USAID TASQC/Cell-Phone/225	2	232.50
2049	144	124	358893195153255	TASQC/USAID TASQC/Cell-Phone/1132	3	255.33
2050	62	124	355041992331285	TASQC/USAID TASQC/Cell-Phone/86	2	232.50
2051	62	124	355041992702444	TASQC/USAID TASQC/Cell-Phone/23	2	232.50
2052	62	124	357035514122451	TASQC/USAID TASQC/Cell-Phone/147	2	232.50
2053	62	124	355041992336490	TASQC/USAID TASQC/Cell-Phone/79	2	232.50
2054	144	124	R9WR20MZYNJ	TASQC/USAID TASQC/Cell-Phone/491	8	255.33
2055	144	124	R9WR20MZVKJ	TASQC/USAID TASQC/Cell-Phone/492	8	255.33
2056	144	124	358893195179300	TASQC/USAID TASQC/Cell-Phone/1131	3	255.33
2057	62	124	355041992699079	TASQC/USAID TASQC/Cell-Phone/141	8	232.50
2058	62	124	355041992699012	TASQC/USAID TASQC/Cell-Phone/52	2	232.50
2059	62	124	R9WNBOFK3HJ	TASQC/USAID TASQC/Cell-Phone/217	2	232.50
2060	62	124	R9WR4115GYJ	TASQC/USAID TASQC/Cell-Phone/224	2	232.50
2061	62	124	357035515525686	TASQC/USAID TASQC/Cell-Phone/30	2	232.50
2062	62	124	355041992337456	TASQC/USAID TASQC/Cell-Phone/78	2	232.50
2063	62	124	358893195460726	TASQC/USAID TASQC/Cell-Phone/116	8	232.50
2064	144	124	358893195183757	TASQC/USAID TASQC/Cell-Phone/1002	2	255.00
2065	144	124	358893195172818	TASQC/USAID TASQC/Cell-Phone/1003	2	255.00
2066	62	124	358893195173006	TASQC/USAID TASQC/Cell-Phone/239	2	232.50
2067	62	124	358893195180985	TASQC/USAID TASQC/Cell-Phone/240	2	232.50
2068	144	124	358893195176355	TASQC/USAID TASQC/Cell-Phone/485	2	255.33
2069	62	124	355041992702428	TASQC/USAID TASQC/Cell-Phone/137	2	232.50
2070	98	124	358893195184094	TASQC/USAID TASQC/Cell-Phone/1010	2	255.00
2071	98	124	358893195154691	TASQC/USAID TASQC/Cell-Phone/1011	2	255.00
2072	144	124	R9WR20NO77J	TASQC/USAID TASQC/Cell-Phone/435	2	255.33
2073	144	124	R9WR20NOW9J	TASQC/USAID TASQC/Cell-Phone/436	2	255.33
2074	144	124	R9WR20X6PBJ	TASQC/USAID TASQC/Cell-Phone/548	2	255.00
2075	98	124	357035514127732	TASQC/USAID TASQC/Cell-Phone/1013	2	255.00
2076	144	124	R9WR20MY3RJ	TASQC/USAID TASQC/Cell-Phone/439	8	255.33
2077	144	124	R9WR20NOLHJ	TASQC/USAID TASQC/Cell-Phone/440	8	255.33
2078	144	124	R9WNBOFHPWJ	TASQC/USAID TASQC/Cell-Phone/443	8	255.33
2079	161	124	357035517489212	TASQC-COVIDGO/USAID TASQC-COVIDGO/Cell-Phone/1083	8	255.00
2080	144	124	355041992335815	TASQC/USAID TASQC/Cell-Phone/999	2	255.00
2081	144	124	355041992326780	TASQC/USAID TASQC/Cell-Phone/1000	2	255.00
2082	144	124	357035514122931	TASQC/USAID TASQC/Cell-Phone/595	2	255.00
2083	144	124	358893195168261	TASQC/USAID TASQC/Cell-Phone/1049	2	255.33
2084	144	124	R9WN80FHYLJ	TASQC/USAID TASQC/Cell-Phone/422	2	255.33
2085	62	124	R9WR41165FJ	TASQC/USAID TASQC/Cell-Phone/176	2	232.50
2086	62	124	R9WNB0FHVCJ	TASQC/USAID TASQC/Cell-Phone/41	2	232.50
2088	161	124	R9WR20X6F5J	TASQC-COVIDGO/USAID TASQC-COVIDGO/Cell-Phone/1080	2	255.00
2089	144	124	358893195153685	TASQC/USAID TASQC/Cell-Phone/1060	2	255.33
2090	144	124	357035514125280	TASQC/USAID TASQC/Cell-Phone/1061	2	255.33
2091	144	124	R9WNB0FHFVJ	TASQC/USAID TASQC/Cell-Phone/1063	2	255.33
2092	144	124	357035517489394	TASQC/USAID TASQC/Cell-Phone/1041	2	255.33
2093	144	124	R9WR20NOVVJ	TASQC/USAID TASQC/Cell-Phone/433	2	255.33
2094	144	124	R9WR20NOVLJ	TASQC/USAID TASQC/Cell-Phone/434	2	255.33
2095	144	124	R9WR20MYHXJ	TASQC/USAID TASQC/Cell-Phone/426	2	255.33
2096	62	124	R9WR20NO1KI	TASQC/USAID TASQC/Cell-Phone/187	2	232.50
2097	144	124	358893195178567	TASQC/USAID TASQC/Cell-Phone/476	2	255.33
2098	144	124	357035514121883	TASQC/USAID TASQC/Cell-Phone/478	2	255.33
2099	144	124	355041992334479	TASQC/USAID TASQC/Cell-Phone/604	2	255.00
2100	144	124	358893195156522	TASQC/USAID TASQC/Cell-Phone/1050	2	255.33
2101	144	124	358893195170317	TASQC/USAID TASQC/Cell-Phone/1051	2	255.33
2102	144	124	358893195157298	TASQC/USAID TASQC/Cell-Phone/1052	2	255.33
2103	144	124	357035514123590	TASQC/USAID TASQC/Cell-Phone/1053	2	255.33
2104	144	124	358893195170697	TASQC/USAID TASQC/Cell-Phone/1055	2	255.33
2105	144	124	358893195180951	TASQC/USAID TASQC/Cell-Phone/1067	2	255.33
2106	62	124	R9WR20NO8CJ	TASQC/USAID TASQC/Cell-Phone/1168	8	232.50
2107	144	124	355041992331244	TASQC/USAID TASQC/Cell-Phone/601	2	255.00
2108	62	124	357035514127526	TASQC/USAID TASQC/Cell-Phone/142	2	232.50
2109	98	124	358893195182544	TASQC/USAID TASQC/Cell-Phone/1008	2	255.00
2110	62	124	R9WR20X6F4J	TASQC/USAID TASQC/Cell-Phone/167	2	232.50
2111	62	124	R9WNB0FHX3J	TASQC/USAID TASQC/Cell-Phone/170	2	232.50
2112	62	124	358893195183765	TASQC/USAID TASQC/Cell-Phone/205	2	232.50
2113	62	124	358893195176728	TASQC/USAID TASQC/Cell-Phone/209	2	232.50
2114	62	124	358893195169749	TASQC/USAID TASQC/Cell-Phone/211	2	232.50
2115	62	124	358893195173816	TASQC/USAID TASQC/Cell-Phone/234	2	232.50
2116	62	124	357035514126460	TASQC/USAID TASQC/Cell-Phone/235	2	232.50
2117	62	124	358893195177981	TASQC/USAID TASQC/Cell-Phone/232	2	232.50
2118	144	124	R9WN80FHN2J	TASQC/USAID TASQC/Cell-Phone/429	2	255.33
2119	144	124	R9WN80FMTVJ	TASQC/USAID TASQC/Cell-Phone/430	2	255.33
2120	62	124	355041992338009	TASQC/USAID TASQC/Cell-Phone/90	2	232.50
2121	144	124	357035514128250	TASQC/USAID TASQC/Cell-Phone/378	2	255.33
2122	144	124	357035574125777	TASQC/USAID TASQC/Cell-Phone/381	2	255.33
2123	144	124	357035514126247	TASQC/USAID TASQC/Cell-Phone/598	2	255.00
2124	144	124	355041992331475	TASQC/USAID TASQC/Cell-Phone/600	2	255.00
2125	144	124	355041992336847	TASQC/USAID TASQC/Cell-Phone/603	2	255.00
2126	144	124	R9WNBOFHVBJ	TASQC/USAID TASQC/Cell-Phone/421	2	255.33
2127	144	124	R9WNBOFHX2J	TASQC/USAID TASQC/Cell-Phone/424	2	255.33
2128	62	124	R9WNB0FK5CJ	TASQC/USAID TASQC/Cell-Phone/1165	8	232.50
2129	62	124	R9WNBOFK423	TASQC/USAID TASQC/Cell-Phone/1167	8	232.50
2130	144	124	R9WN80FHV1J	TASQC/USAID TASQC/Cell-Phone/445	8	255.33
2131	144	124	R9WN80FHY2J	TASQC/USAID TASQC/Cell-Phone/446	8	255.33
2132	144	124	R9WR20MZV6J	TASQC/USAID TASQC/Cell-Phone/419	2	255.33
2133	62	124	R9WR4144RFJ	TASQC/USAID TASQC/Cell-Phone/177	2	232.50
2134	144	124	R9WNBOFHYKJ	TASQC/USAID TASQC/Cell-Phone/427	2	255.33
2135	144	124	R9WNBOFHWAJ	TASQC/USAID TASQC/Cell-Phone/428	2	255.33
2136	62	124	357035514123079	TASQC/USAID TASQC/Cell-Phone/238	2	232.50
2137	144	124	357035514151633	TASQC/USAID TASQC/Cell-Phone/594	2	255.00
2138	144	124	357035514122121	TASQC/USAID TASQC/Cell-Phone/596	2	255.00
2139	144	124	358893193969579	TASQC/USAID TASQC/Cell-Phone/597	2	255.00
2140	144	124	357035514122485	TASQC/USAID TASQC/Cell-Phone/599	2	255.00
2141	144	124	355041992335617	TASQC/USAID TASQC/Cell-Phone/602	2	255.00
2142	144	124	355041992335559	TASQC/USAID TASQC/Cell-Phone/605	2	255.00
2143	144	124	357035514123236	TASQC/USAID TASQC/Cell-Phone/1056	2	255.33
2144	62	124	355041992335419	TASQC/USAID TASQC/Cell-Phone/6	2	232.50
2145	62	124	358893195176991	TASQC/USAID TASQC/Cell-Phone/15	2	232.50
2146	144	124	355041992336466	TASQC/USAID TASQC/Cell-Phone/377	2	255.33
2147	144	124	R9WR20X6P8J	TASQC/USAID TASQC/Cell-Phone/543	2	255.00
2148	144	124	358893195161159	TASQC/USAID TASQC/Cell-Phone/1139	3	255.33
2149	144	124	R9WR4144R8J	TASQC/USAID TASQC/Cell-Phone/472	3	255.33
2150	161	124	358893197350552	TASQC-COVIDGO/USAID TASQC-COVIDGO/Cell-Phone/1081	8	255.00
2151	144	124	357035514127799	TASQC/USAID TASQC/Cell-Phone/372	2	255.33
2152	144	124	358893195184540	TASQC/USAID TASQC/Cell-Phone/380	2	255.33
2153	62	124	357035514125181	TASQC/USAID TASQC/Cell-Phone/111	2	232.50
2154	62	124	355041992327846	TASQC/USAID TASQC/Cell-Phone/48	2	232.50
2155	13	125	210120029568202000	TASQC/USAID TASQC/Refrigerator/20	2	500.00
2156	63	125	C350-7005	TASQC/USAID TASQC/Refrigerator/5	2	500.00
2157	22	125	C290-12123	TASQC/USAID TASQC/Refrigerator/12	2	400.00
2158	162	125	R072119882	TASQC/USAID TASQC/Refrigerator/3	2	489.00
2159	162	125	R072120893	TASQC/USAID TASQC/Refrigerator/4	2	489.00
2160	163	125	32KHS63904	TASQC/USAID TASQC/Refrigerator/9	2	500.00
2161	13	125	SGSN-02151	TASQC/USAID TASQC/Refrigerator/16	2	500.00
2162	162	125	R072120761	TASQC/USAID TASQC/Refrigerator/1	2	489.00
2163	13	125	SYL09170930	TASQC/USAID TASQC/Refrigerator/19	2	500.00
2164	46	39	AFS6092	TASQC/USAID TASQC/Vehicle/87	2	34900.00
2165	72	39	AEX4859	TASQC/USAID TASQC/Vehicle/50	2	25500.00
2166	72	39	AEX4723	TASQC/USAID TASQC/Vehicle/51	2	25500.00
2167	72	39	AEX4722	TASQC/USAID TASQC/Vehicle/52	2	25500.00
2168	164	39	AEK6831	TASQC/USAID TASQC/Vehicle/85	8	24520.00
2169	165	39	AGP7849	TASQC/USAID TASQC/Vehicle/86	2	36250.00
2170	166	126	1CR0120039	TASQC/USAID TASQC/Monitor/11	2	399.50
2171	167	126	1CR91024HS	TASQC/USAID TASQC/Monitor/2	2	400.75
2172	167	126	1CR90706TV	TASQC/USAID TASQC/Monitor/5	2	400.75
2173	13	126	1CR10808TS	TASQC/USAID TASQC/Monitor/30	2	320.00
2174	166	126	1CR01200D4	TASQC/USAID TASQC/Monitor/8	2	399.50
2175	168	126	1CR9091CJQ	TASQC/USAID TASQC/Monitor/18	2	322.00
2176	167	126	1CR01200BC	TASQC/USAID TASQC/Monitor/1	2	400.75
2177	169	126	1CR01200BY	TASQC/USAID TASQC/Monitor/26	2	600.00
2178	166	126	1CR1150RHM	TASQC/USAID TASQC/Monitor/9	2	399.50
2179	168	126	1CR9091CK1	TASQC/USAID TASQC/Monitor/17	2	322.00
2180	168	126	1CR9091CHY	TASQC/USAID TASQC/Monitor/19	2	322.00
2181	166	126	1CR01200D0	TASQC/USAID TASQC/Monitor/12	2	399.50
2182	167	126	1CR9080039	TASQC/USAID TASQC/Monitor/3	2	400.75
2183	13	126	6CM62426NG	TASQC/USAID TASQC/Monitor/31	2	320.00
2184	170	126	1CR10808TR	TASQC/USAID TASQC/Monitor/21	2	352.24
2185	171	126	1CR01200BX	TASQC/USAID TASQC/Monitor/34	2	350.00
2186	166	126	1CR01200CN	TASQC/USAID TASQC/Monitor/7	2	399.50
2187	166	126	1CR01200CZ	TASQC/USAID TASQC/Monitor/6	2	399.50
2188	166	126	1CR9070VRS	TASQC/USAID TASQC/Monitor/10	2	399.50
2189	172	126	ICR01200DV	TASQC/USAID TASQC/Monitor/28	2	400.00
2190	167	126	1CR9080IMZ	TASQC/USAID TASQC/Monitor/4	2	400.75
2191	13	127	LW14112442723	TASQC/USAID TASQC/Water Dispenser /6	2	120.00
2192	173	127	LW-5230640118190	TASQC/USAID TASQC/Water Dispenser /8	2	210.00
2193	13	127	SGSN-02183	TASQC/USAID TASQC/Water Dispenser /5	3	150.00
2194	174	127	835568	TASQC/USAID TASQC/Water Dispenser /13	2	335.00
2195	174	127	835552	TASQC/USAID TASQC/Water Dispenser /14	2	335.00
2196	174	127	835771	TASQC/USAID TASQC/Water Dispenser /15	2	335.00
2197	175	127	R134a/35g-02	TASQC/USAID TASQC/Water Dispenser /17	2	275.00
2198	173	127	LW-5230640115204	TASQC/USAID TASQC/Water Dispenser /7	2	210.00
2199	173	127	LW-5230640118200	TASQC/USAID TASQC/Water Dispenser /10	2	210.00
2200	176	127	R134a/35g-01	TASQC/USAID TASQC/Water Dispenser /16	2	465.00
2201	173	127	LW-5230640118236	TASQC/USAID TASQC/Water Dispenser /11	2	210.00
2202	13	127	SGSN-02192	TASQC/USAID TASQC/Water Dispenser /3	2	200.00
2203	173	127	LW-5230640118233	TASQC/USAID TASQC/Water Dispenser /12	2	210.00
2204	173	127	LW-5230640118223	TASQC/USAID TASQC/Water Dispenser /9	2	210.00
2205	13	127	C27211120114	TASQC/USAID TASQC/Water Dispenser /1	2	200.00
2206	111	127	83283Z231Z1101P0193	TASQC/USAID TASQC/Water Dispenser /18	2	104.60
2207	13	128	SGSN-02197	TASQC/USAID TASQC/Fan/3	2	100.00
2208	13	128	SGSN-02198	TASQC/USAID TASQC/Fan/5	2	100.00
2209	13	128	SGSN-02199	TASQC/USAID TASQC/Fan/55	2	50.00
2210	13	128	SGSN-02200	TASQC/USAID TASQC/Fan/29	2	50.00
2211	13	128	SGSN-02201	TASQC/USAID TASQC/Fan/4	2	100.00
2212	13	128	SGSN-02202	TASQC/USAID TASQC/Fan/7	2	100.00
2213	13	128	SGSN-02203	TASQC/USAID TASQC/Fan/8	2	100.00
2214	13	128	SGSN-02204	TASQC/USAID TASQC/Fan/9	2	100.00
2215	13	128	SGSN-02205	TASQC/USAID TASQC/Fan/10	2	50.00
2216	13	128	SGSN-02206	TASQC/USAID TASQC/Fan/11	2	50.00
2217	13	128	SGSN-02207	TASQC/USAID TASQC/Fan/6	2	50.00
2218	13	128	SGSN-02208	TASQC/USAID TASQC/Fan/13	2	35.00
2219	13	128	SGSN-02209	TASQC/USAID TASQC/Fan/54	2	50.00
2220	13	128	SGSN-02210	TASQC/USAID TASQC/Fan/43	2	50.00
2221	177	129	SGSN-02211	TASQC/USAID TASQC/Notice Board/28	8	65.00
2222	13	129	SGSN-02212	TASQC/USAID TASQC/Notice Board/9	2	70.00
2223	13	129	SGSN-02213	TASQC/USAID TASQC/Notice Board/12	2	45.00
2224	13	129	SGSN-02214	TASQC/USAID TASQC/Notice Board/13	2	45.00
2225	122	129	SGSN-02215	TASQC/USAID TASQC/Notice Board/7	2	70.00
2226	13	129	SGSN-02216	TASQC/USAID TASQC/Notice Board/17	2	45.00
2227	122	129	SGSN-02217	TASQC/USAID TASQC/Notice Board/6	2	70.00
2228	13	129	SGSN-02218	TASQC/USAID TASQC/Notice Board/3	2	200.00
2229	13	129	SGSN-02219	TASQC/USAID TASQC/Notice Board/4	2	200.00
2230	13	129	SGSN-02220	TASQC/USAID TASQC/Notice Board/5	2	200.00
2231	13	129	SGSN-02221	TASQC/USAID TASQC/Notice Board/8	2	40.00
2232	13	129	SGSN-02222	TASQC/USAID TASQC/Notice Board/14	2	45.00
2233	13	130	22074A6001398	TASQC/USAID TASQC/Router/9	2	1000.00
2234	13	130	SGSN-02224	TASQC/USAID TASQC/Router/1	2	980.00
2235	13	130	22074B1000027	TASQC/USAID TASQC/Router/2	2	1000.00
2236	178	130	KIT401308979HRK	TASQC/USAID TASQC/Router/14	2	496.00
2237	13	130	SGSN-02227	TASQC/USAID TASQC/Router/7	2	1000.00
2238	179	130	KIT401376356Z53	TASQC/USAID TASQC/Router/17	2	496.00
2239	13	130	2022K74ACB92C2CA0-8AD3P1	TASQC/USAID TASQC/Router/3	2	1000.00
2240	13	130	2216121000307	TASQC/USAID TASQC/Router/5	2	1000.00
2241	179	130	KIT401376355XXR	TASQC/USAID TASQC/Router/16	2	496.00
2242	13	130	22074A6001384	TASQC/USAID TASQC/Router/10	2	980.00
2243	178	130	KIT401625364U8E	TASQC/USAID TASQC/Router/15	2	496.00
2244	13	131	SGSN-02234	TASQC/USAID TASQC/Cabinet/96	2	210.00
2245	13	131	SGSN-02235	TASQC/USAID TASQC/Cabinet/97	2	210.00
2246	180	131	SGSN-02236	TASQC/USAID TASQC/Cabinet/69	2	680.00
2247	180	131	SGSN-02237	TASQC/USAID TASQC/Cabinet/70	2	680.00
2248	13	132	SGSN-02238	TASQC/USAID TASQC/Desk/141	2	270.00
2249	154	132	SGSN-02239	TASQC/USAID TASQC/Desk/215	2	475.00
2250	22	132	SGSN-02240	TASQC/USAID TASQC/Desk/174	3	300.00
2251	13	132	SGSN-02241	TASQC/USAID TASQC/Desk/187	2	150.00
2252	22	132	SGSN-02242	TASQC/USAID TASQC/Desk/173	2	300.00
2253	22	132	SGSN-02243	TASQC/USAID TASQC/Desk/175	2	300.00
2254	13	132	SGSN-02244	TASQC/USAID TASQC/Desk/199	2	210.00
2255	13	132	SGSN-02245	TASQC/USAID TASQC/Desk/142	2	270.00
2256	13	132	SGSN-02246	TASQC/USAID TASQC/Desk/189	2	140.00
2257	13	133	SGSN-02247	TASQC/USAID TASQC/Chair/325	2	110.00
2258	13	133	SGSN-02248	TASQC/USAID TASQC/Chair/1042	2	110.00
2259	13	133	SGSN-02249	TASQC/USAID TASQC/Chair/360	2	110.00
2260	13	133	SGSN-02250	TASQC/USAID TASQC/Chair/326	2	110.00
2261	13	133	SGSN-02251	TASQC/USAID TASQC/Chair/359	2	110.00
2262	13	133	SGSN-02252	TASQC/USAID TASQC/Chair/327	2	110.00
2263	13	133	SGSN-02253	TASQC/USAID TASQC/Chair/351	2	110.00
2264	181	134	SGSN-02254	TASQC/USAID TASQC/Desk/45	2	330.00
2265	182	134	SGSN-02255	TASQC/USAID TASQC/Desk/40	2	280.00
2266	181	134	SGSN-02256	TASQC/USAID TASQC/Desk/47	2	330.00
2267	183	134	SGSN-02257	TASQC/USAID TASQC/Desk/18	2	280.00
2268	182	134	SGSN-02258	TASQC/USAID TASQC/Desk/39	2	280.00
2269	182	134	SGSN-02259	TASQC/USAID TASQC/Desk/36	2	280.00
2270	182	134	SGSN-02260	TASQC/USAID TASQC/Desk/37	2	280.00
2271	182	134	SGSN-02261	TASQC/USAID TASQC/Desk/41	2	280.00
2272	184	134	SGSN-02262	TASQC/USAID TASQC/Desk/50	2	330.00
2273	181	134	SGSN-02263	TASQC/USAID TASQC/Desk/46	2	330.00
2274	185	134	SGSN-02264	TASQC/USAID TASQC/Desk/114	2	321.00
2275	184	134	SGSN-02265	TASQC/USAID TASQC/Desk/51	2	330.00
2276	185	134	SGSN-02266	TASQC/USAID TASQC/Desk/111	2	321.00
2277	185	134	SGSN-02267	TASQC/USAID TASQC/Desk/112	2	321.00
2278	185	134	SGSN-02268	TASQC/USAID TASQC/Desk/115	2	321.00
2279	13	134	SGSN-02269	TASQC/USAID TASQC/Desk/185	2	130.00
2280	186	134	SGSN-02270	TASQC/USAID TASQC/Desk/92	2	321.00
2281	186	134	SGSN-02271	TASQC/USAID TASQC/Desk/93	2	321.00
2282	183	134	SGSN-02272	TASQC/USAID TASQC/Desk/3	2	280.00
2283	183	134	SGSN-02273	TASQC/USAID TASQC/Desk/8	2	280.00
2284	183	134	SGSN-02274	TASQC/USAID TASQC/Desk/9	2	280.00
2285	183	134	SGSN-02275	TASQC/USAID TASQC/Desk/13	2	280.00
2286	183	134	SGSN-02276	TASQC/USAID TASQC/Desk/26	2	280.00
2287	185	134	SGSN-02277	TASQC/USAID TASQC/Desk/110	2	321.00
2288	185	134	SGSN-02278	TASQC/USAID TASQC/Desk/125	2	321.00
2289	183	134	SGSN-02279	TASQC/USAID TASQC/Desk/29	2	280.00
2290	185	134	SGSN-02280	TASQC/USAID TASQC/Desk/124	2	321.00
2291	185	134	SGSN-02281	TASQC/USAID TASQC/Desk/127	2	321.00
2292	183	134	SGSN-02282	TASQC/USAID TASQC/Desk/24	2	280.00
2293	182	134	SGSN-02283	TASQC/USAID TASQC/Desk/38	2	280.00
2294	183	134	SGSN-02284	TASQC/USAID TASQC/Desk/2	2	280.00
2295	185	134	SGSN-02285	TASQC/USAID TASQC/Desk/130	2	321.00
2296	185	134	SGSN-02286	TASQC/USAID TASQC/Desk/94	2	110.00
2297	185	134	SGSN-02287	TASQC/USAID TASQC/Desk/108	2	321.00
2298	13	134	SGSN-02288	TASQC/USAID TASQC/Desk/200	2	210.00
2299	183	134	SGSN-02289	TASQC/USAID TASQC/Desk/21	2	280.00
2300	185	134	SGSN-02290	TASQC/USAID TASQC/Desk/95	2	321.00
2301	185	134	SGSN-02291	TASQC/USAID TASQC/Desk/118	2	321.00
2302	183	134	SGSN-02292	TASQC/USAID TASQC/Desk/11	2	280.00
2303	183	134	SGSN-02293	TASQC/USAID TASQC/Desk/12	2	280.00
2304	183	134	SGSN-02294	TASQC/USAID TASQC/Desk/14	2	280.00
2305	183	134	SGSN-02295	TASQC/USAID TASQC/Desk/15	2	280.00
2306	183	134	SGSN-02296	TASQC/USAID TASQC/Desk/17	2	280.00
2307	187	134	SGSN-02297	TASQC/USAID TASQC/Desk/180	2	321.00
2308	188	134	SGSN-02298	TASQC/USAID TASQC/Desk/181	8	321.00
2309	185	134	SGSN-02299	TASQC/USAID TASQC/Desk/101	2	321.00
2310	185	134	SGSN-02300	TASQC/USAID TASQC/Desk/109	2	321.00
2311	185	134	SGSN-02301	TASQC/USAID TASQC/Desk/117	2	321.00
2312	183	134	SGSN-02302	TASQC/USAID TASQC/Desk/27	2	280.00
2313	183	134	SGSN-02303	TASQC/USAID TASQC/Desk/19	2	280.00
2314	183	134	SGSN-02304	TASQC/USAID TASQC/Desk/20	2	280.00
2315	183	134	SGSN-02305	TASQC/USAID TASQC/Desk/28	2	280.00
2316	185	134	SGSN-02306	TASQC/USAID TASQC/Desk/99	2	321.00
2317	185	134	SGSN-02307	TASQC/USAID TASQC/Desk/122	2	321.00
2318	185	134	SGSN-02308	TASQC/USAID TASQC/Desk/132	2	321.00
2319	185	134	SGSN-02309	TASQC/USAID TASQC/Desk/100	2	321.00
2320	13	134	SGSN-02310	TASQC/USAID TASQC/Desk/184	2	130.00
2321	185	134	SGSN-02311	TASQC/USAID TASQC/Desk/98	2	321.00
2322	13	134	SGSN-02312	TASQC/USAID TASQC/Desk/194	2	220.00
2323	185	134	SGSN-02313	TASQC/USAID TASQC/Desk/107	2	321.00
2324	185	134	SGSN-02314	TASQC/USAID TASQC/Desk/126	2	321.00
2325	13	134	SGSN-02315	TASQC/USAID TASQC/Desk/190	2	120.00
2326	185	134	SGSN-02316	TASQC/USAID TASQC/Desk/105	2	321.00
2327	185	134	SGSN-02317	TASQC/USAID TASQC/Desk/106	2	321.00
2328	183	134	SGSN-02318	TASQC/USAID TASQC/Desk/1	2	280.00
2329	183	134	SGSN-02319	TASQC/USAID TASQC/Desk/5	2	280.00
2330	183	134	SGSN-02320	TASQC/USAID TASQC/Desk/6	2	280.00
2331	183	134	SGSN-02321	TASQC/USAID TASQC/Desk/22	2	280.00
2332	183	134	SGSN-02322	TASQC/USAID TASQC/Desk/23	2	280.00
2333	184	134	SGSN-02323	TASQC/USAID TASQC/Desk/49	2	330.00
2334	185	134	SGSN-02324	TASQC/USAID TASQC/Desk/129	2	321.00
2335	185	134	SGSN-02325	TASQC/USAID TASQC/Desk/120	2	321.00
2336	185	134	SGSN-02326	TASQC/USAID TASQC/Desk/113	2	321.00
2337	183	134	SGSN-02327	TASQC/USAID TASQC/Desk/35	2	280.00
2338	181	134	SGSN-02328	TASQC/USAID TASQC/Desk/42	2	330.00
2339	181	134	SGSN-02329	TASQC/USAID TASQC/Desk/43	2	330.00
2340	181	134	SGSN-02330	TASQC/USAID TASQC/Desk/44	2	330.00
2341	13	134	SGSN-02331	TASQC/USAID TASQC/Desk/182	2	130.00
2342	13	134	SGSN-02332	TASQC/USAID TASQC/Desk/183	2	130.00
2343	185	134	SGSN-02333	TASQC/USAID TASQC/Desk/121	2	321.00
2344	185	134	SGSN-02334	TASQC/USAID TASQC/Desk/131	2	321.00
2345	185	134	SGSN-02335	TASQC/USAID TASQC/Desk/128	2	321.00
2346	183	134	SGSN-02336	TASQC/USAID TASQC/Desk/10	2	280.00
2347	159	134	SGSN-02337	TASQC/USAID TASQC/Desk/151	2	150.00
2348	185	134	SGSN-02338	TASQC/USAID TASQC/Desk/96	2	321.00
2349	185	134	SGSN-02339	TASQC/USAID TASQC/Desk/97	2	321.00
2350	185	134	SGSN-02340	TASQC/USAID TASQC/Desk/102	2	321.00
2351	185	134	SGSN-02341	TASQC/USAID TASQC/Desk/104	2	321.00
2352	185	134	SGSN-02342	TASQC/USAID TASQC/Desk/119	2	321.00
2353	185	134	SGSN-02343	TASQC/USAID TASQC/Desk/123	2	321.00
2354	189	135	SGSN-02344	TASQC/USAID TASQC/Table/17	2	171.00
2355	189	135	SGSN-02345	TASQC/USAID TASQC/Table/18	2	171.00
2356	157	136	SGSN-02346	TASQC/USAID TASQC/Height Body/1	2	500.00
2357	94	137	SGSN-02347	TASQC/USAID TASQC/Desk/154	2	350.00
2358	190	137	SGSN-02348	TASQC/USAID TASQC/Desk/133	2	589.85
2359	191	138	SGSN-02349	TASQC/USAID TASQC/Table/15	2	170.00
2360	191	138	SGSN-02350	TASQC/USAID TASQC/Table/16	2	170.00
2361	19	139	SGSN-02351	TASQC/USAID TASQC/Desk/136	2	816.00
2362	19	139	SGSN-02352	TASQC/USAID TASQC/Desk/137	2	816.00
2363	192	140	AER5013	TASQC/USAID TASQC/Motor-Cycle/13	2	2750.00
2364	192	140	AER5033	TASQC/USAID TASQC/Motor-Cycle/33	2	2750.00
2365	192	140	AER5008	TASQC/USAID TASQC/Motor-Cycle/8	2	2750.00
2366	192	140	AER5015	TASQC/USAID TASQC/Motor-Cycle/15	2	2750.00
2367	192	140	AER5036	TASQC/USAID TASQC/Motor-Cycle/36	2	2750.00
2368	192	140	AER5043	TASQC/USAID TASQC/Motor-Cycle/43	2	2750.00
2369	192	140	AER5044	TASQC/USAID TASQC/Motor-Cycle/44	2	2750.00
2370	192	140	AER5045	TASQC/USAID TASQC/Motor-Cycle/45	2	2750.00
2371	192	140	AER8962	TASQC/USAID TASQC/Motor-Cycle/58	2	2750.00
2372	192	140	AGR4959	TASQC/USAID TASQC/Motor-Cycle/37	2	2750.00
2373	192	140	AER5001	TASQC/USAID TASQC/Motor-Cycle/1	2	2750.00
2374	192	140	AER5002	TASQC/USAID TASQC/Motor-Cycle/2	2	2750.00
2375	192	140	AER5003	TASQC/USAID TASQC/Motor-Cycle/3	2	2750.00
2376	192	140	AER5029	TASQC/USAID TASQC/Motor-Cycle/29	2	2750.00
2377	192	140	AGR5074	TASQC/USAID TASQC/Motor-Cycle/38	2	2750.00
2378	192	140	AER5038	TASQC/USAID TASQC/Motor-Cycle/39	2	2750.00
2379	192	140	AER5040	TASQC/USAID TASQC/Motor-Cycle/40	2	2750.00
2380	192	140	AER5852	TASQC/USAID TASQC/Motor-Cycle/46	2	2750.00
2381	192	140	AER5853	TASQC/USAID TASQC/Motor-Cycle/47	2	2750.00
2382	192	140	AER5024-1	TASQC/USAID TASQC/Motor-Cycle/21	2	2750.00
2383	192	140	AER6379	TASQC/USAID TASQC/Motor-Cycle/52	2	2750.00
2384	192	140	AER8963	TASQC/USAID TASQC/Motor-Cycle/57	2	2750.00
2385	193	140	AER5006	TASQC/USAID TASQC/Motor-Cycle/54	2	2750.00
2386	192	140	AER6540	TASQC/USAID TASQC/Motor-Cycle/50	5	2750.00
2387	192	140	AER6378	TASQC/USAID TASQC/Motor-Cycle/49	2	2750.00
2388	192	140	AER5024	TASQC/USAID TASQC/Motor-Cycle/24	2	2750.00
2389	192	140	AER5023	TASQC/USAID TASQC/Motor-Cycle/23	2	2750.00
2390	192	140	AER5012	TASQC/USAID TASQC/Motor-Cycle/12	2	2750.00
2391	193	140	AER5871	TASQC/USAID TASQC/Motor-Cycle/53	2	2750.00
2392	192	140	AER5032	TASQC/USAID TASQC/Motor-Cycle/32	2	2750.00
2393	192	140	AER5009	TASQC/USAID TASQC/Motor-Cycle/9	2	2750.00
2394	192	140	AER5021	TASQC/USAID TASQC/Motor-Cycle/20	2	2750.00
2395	192	140	AER5022	TASQC/USAID TASQC/Motor-Cycle/22	2	2750.00
2396	192	140	AER5034	TASQC/USAID TASQC/Motor-Cycle/34	2	2750.00
2397	192	140	AER5035	TASQC/USAID TASQC/Motor-Cycle/35	2	2750.00
2398	192	140	AER5016	TASQC/USAID TASQC/Motor-Cycle/16	2	2750.00
2399	192	140	AER5851	TASQC/USAID TASQC/Motor-Cycle/51	2	2750.00
2400	192	140	AER5018	TASQC/USAID TASQC/Motor-Cycle/18	2	2750.00
2401	192	140	AER5011	TASQC/USAID TASQC/Motor-Cycle/11	2	2750.00
2402	192	140	AER5004	TASQC/USAID TASQC/Motor-Cycle/4	2	2750.00
2403	192	140	AER5005	TASQC/USAID TASQC/Motor-Cycle/5	2	2750.00
2404	192	140	AER5030	TASQC/USAID TASQC/Motor-Cycle/30	2	2750.00
2405	192	140	AER5014	TASQC/USAID TASQC/Motor-Cycle/14	2	2750.00
2406	192	140	AER5019	TASQC/USAID TASQC/Motor-Cycle/19	2	2750.00
2407	192	140	AER5027	TASQC/USAID TASQC/Motor-Cycle/27	2	2750.00
2408	192	140	AER5028	TASQC/USAID TASQC/Motor-Cycle/28	2	2750.00
2409	192	140	AER5031	TASQC/USAID TASQC/Motor-Cycle/31	2	2750.00
2410	192	140	AER5041	TASQC/USAID TASQC/Motor-Cycle/41	2	2750.00
2411	192	140	AER5042	TASQC/USAID TASQC/Motor-Cycle/42	2	2750.00
2412	192	140	AER5010	TASQC/USAID TASQC/Motor-Cycle/10	2	2750.00
2413	192	140	AER5017	TASQC/USAID TASQC/Motor-Cycle/17	2	2750.00
2414	192	140	AER5025	TASQC/USAID TASQC/Motor-Cycle/25	2	2750.00
2415	192	140	AER5026	TASQC/USAID TASQC/Motor-Cycle/26	2	2750.00
2416	192	140	AER5856	TASQC/USAID TASQC/Motor-Cycle/48	2	2750.00
2417	192	140	AER5007	TASQC/USAID TASQC/Motor-Cycle/7	2	2750.00
2418	192	140	AER8964	TASQC/USAID TASQC/Motor-Cycle/56	2	2750.00
2419	192	140	AER9102	TASQC/USAID TASQC/Motor-Cycle/59	2	2750.00
2420	194	141	4JYZJ24	OPHID/OPHID/Laptop/476	2	4350.00
2421	195	142	HSYT494	OPHID/OPHID/Laptop/485	2	4370.00
2422	196	143	1H85350J1W	TASQC/USAID TASQC/Laptop/508	1	3465.00
2423	196	143	1H85350J1L	TASQC/USAID TASQC/Laptop/507	1	3465.00
2424	196	143	1H85350J1M	TASQC/USAID TASQC/Laptop/510	1	3465.00
2425	196	143	1H85350J1V	TASQC/USAID TASQC/Laptop/509	1	3465.00
2426	197	143	5CD451HFZT	LSHTM/LSHTM-ZVATINODA/Laptop/486	2	2898.99
\.


--
-- TOC entry 3800 (class 0 OID 466395)
-- Dependencies: 210
-- Data for Name: role_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_types (id, name) FROM stdin;
10	General User
20	Assets Administrator
30	Auctions Administrator
40	Supervisor
50	Manager
60	Auditor
70	Users Administrator
80	System Administrator
\.


--
-- TOC entry 3833 (class 0 OID 466576)
-- Dependencies: 243
-- Data for Name: staff_accounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_accounts (id, staff_profile_id, secret_key) FROM stdin;
1	1	240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
2	2	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
3	3	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
4	4	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
5	5	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
8	7	8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918
9	59	02dbbc8a7483ed7ef37e34cb6bf3c41c0851721b7a4cc90eb84164baf81d9399
10	135	d4e83da275af7f3b5bc7726bdc173493fd2bda3c175b232cc3f780081358b92b
11	264	c7b6b8f614d5e8ffdafc812483e1d72545b7b6d5fe01fffbc2f5144b18627e60
12	528	a3890b041bbe728c337d2d40082b182095c64255823ea05d63c43d4f97772790
13	639	53326f1ec84a34a49bc9f5b7c0cb6479da26ee10709fac7bc76d01777d187632
14	683	b47a57875095bfe57410840826719db62e74983451c876673273fa6de45ce9ad
15	696	207d116b2188ff2dca5bb034a32cca9d821a8363cc1a4407cc829d73df909bb7
16	896	9c5a6cdf0c971cd0ea82bf8eddc1e971fa8be8ff235705d48dc0bf4fd528823b
17	898	bb53c27759c2d69ed98ad97e8d36070a493611b185d390c640b9decb21aef077
18	899	2d754f8ab322f9db7b4690dd00dd606c387e26c42ea55455334a95f553ada82b
19	983	1ef783be353b8d886c46236d7ec747bcf1e227a6400556a18e053aa0cdc0c377
20	21014	4c8a448be34a64190b408ebde7e0529c37e80b8fa50ec37505fb817dc150c34d
21	21015	bed78f41e4848fb7046ace5d04a752f80eaa36e762546abd86889718572e33d0
22	21046	fd13141be22645be1e427c3e4797c87968a0494a58688d4824e424c2cc7b8c43
23	21102	524e4f525a3b589abde1e651ae07c09e1e5a4feab0de2fb5cee6891ee468a3e5
24	23068	7934ad32955803c04f006ae02aa0cd8f147f288f3876509ee7827193f2048433
25	23071	d61666082ae2c92a68c49660000297a186aa47c408b6d05cb308ab637621d816
26	25109	a96efa8218a3bb7c035059449938f5164bdb7f6a67e56be4be308ec0e849f940
27	25110	dda2a83cbe48febea65bfd99e38d9289e0ef7d7672ec03f135aa4c359de1575d
28	132	1942d4401e3febee66c2c87e27b4f0e2fe1b627c177376e6301a1c6304ab1dd7
29	591	16925a92b2b2c23d6ed2408088165c02fb061816686ae9108a4fff88cb540fa2
30	251111	289becce9cd750155b8bcc4042f2d2f8802e0f5ce186706c357934a8895c86e8
31	2114310	6b3d34c0eb0452611f6a3ab440fd3725b9b02a6970f698adcdb4c09312d2dc8c
32	482	f620993b1ccc043e0e000b985a9935f5078b363106fb7dcced503de6306c7e4d
33	636	c409087580bee8587dc375a29d745fffbbe3040e9d940f5d7bd156435270f1b8
34	642	4270ae34675d7232c4cc495df12d38acaf17f0bd4cb636132cb7e2b515f71a30
35	692	6baadf6d06966c31b83c3859070be79a9f524dc87c6e0aac1fb63673fe6dff1d
36	694	48279057114a428d57e301cbb8f7458132f5fb70e9594613f7659f089dfa02b3
37	698	67e220cdf57334951bba436934a42437a411cfb38afef7929b360556548e7909
38	707	5f8043affda4dea23fe8329719dbe3820ea92a57be35de65f846a230db6fd422
39	870	618a035db65c323e57136535db3d0997070be7ff9ef951f4452b3f0171b74d48
40	875	5e820d9df151d8ab2343a94891bc8cf91584577464ec19429d738ae51a8be432
41	922	744e030d7d4e3fba4ee76e9e294d822603c2db9c4220560ce2bec3b542fcf6c8
42	923	e9121d64aab915721a0288c28ed1ae9cd7e3903f85d88043effec7507e568ce3
43	927	c6aa8d9b1d1aa84ca14d816ebc85ca1390a2620092e5bce7f387f34b4d594018
44	932	d43d6fcde793a8e2fd6d7d4e03a22e39c868c6bff699396102eac8026185af7c
45	939	66d143830a801698bc42eda79b8384dd96c390d0371f635d0f40b4ef35632a2f
46	946	3a9fa44b9d67eeacd841b277a50a46669c84e05c7448adadf0e48e1669107fc4
47	948	28b2f4e257512921232f43202059aabd911013e4fec47b57481a218fe353aeef
48	952	d0243b88bf37fd8d1f3cb4fa50b1e254cd5034f683173c5cc25d61c758883ef8
49	954	76f8258be3adba01104545f34a1e59930a01675267b4972d8045bc1ceadca195
50	958	3d2aab3ac18c6fa0327949ccb3226e8219c17727772315fe92f5b50a429ffb27
51	963	697e59511b5cd7babdaf609786f41249be45e83b89e7b30729ffcbd2b1a205b3
52	966	4f5d1d970263485f774309db352c0e2d6ba3f2a8a1db1c49db5dccfeeff7ef4c
53	967	52e933cf12b25b56b1bd2092c07982478796fb138e1aa03097cf19604decb5bb
54	968	1fe818880f2744dc4fdc615b4d26b38a561d620cbfd140a07e8137574ba9f078
55	975	0381bc848959a04caed349fb74fac71d99647bd01bc60e0b5bed4bc6f3961c9d
56	976	7ec04496dd4fa53a74e8f989351c753273ebb26a9c4fb79eb6f1aed56f739b5f
57	977	1104a73bd01994a8a04d1ce3374cc305d6129595b2bcbce8b5b2b4ecef0e0b87
58	981	a4978f5b07c01a555fdf03f48d1faed26c3e99f617846220103ed899a12a159f
59	986	f2b4fc154b00c174798c57405550acca422f63acc73a04aec8509e5529c4203a
60	21022	2a2ef97d408fe7da35e4d1b79544311131396f92fdab48b289c86e48673e05c7
61	21026	4d00971bc2059ec2296894e857953092160d396aefab6d3c969c84f757b4a6c2
62	21030	420c02477170760b461c0c1a1889d2449862bd916d4c54ae8788ed5698a11f6d
63	21032	d972cba4a2cd370bdd26d1cddb412052d28c4bc93dcc4f66d4c9c5bf1b907a52
64	21033	d188cc53ba35add7d556e6a578a24ed540114243158de4aff4c3462ae86e93b4
65	21034	cb6d179243619953fb57ea4818bcc56eaf5737332417a8edeeff913753bb1066
66	21039	237b7b23dd69bb0719f667193a491b8a178df7228e224c3d13a84b5e0b8a58f6
67	21041	49b36d31ac2157f89341197141634f09aa5a57325981bbad9da1f32facffdec9
68	21049	e2dc941480fa7ad69b6f7bc88ab45d7545fe281c3611cea0337b0816d4433f05
69	21051	e621d6f4c327e752fcffac28b7c7c5678ea2460d4bd2af3e0d87f14486846adb
70	21054	f7cea3b78e947e9a9e915d9fca4f9a914cbef66d2efd76690aea581cf1eaced9
71	21055	60c8fb6d5f6eae3021df5640aa5b53d7d6997bd87a333ff3ffe6e24b4d5a1689
72	21058	0a6a50259d1aa446bfbbc1ec84becae5541c163e25e7d2ac7f210e69c6a00b81
73	21063	f26d7936d110c37955ceb4fda91b9754b1a0e16fdcafbe2649ac86f33fd878e8
74	21064	ffcd58daa2a56c9d80a152aff544da44a4b01161c6e62a9dbdd4f639515c0669
75	21065	4b87037709ea8db7d40a08332a073c247a99dbeaa6ef525ee3153ff457623336
76	21066	f36e86669303cad4d8fbb8012d4125bce02e30eccb30c4bbda5de9cbf9d94087
77	21067	71126d5a80325fa88b5c0a9329fc98b5dfe051925b0b083ea631f50393007025
78	21068	2a01898e4642e25820f265debec393481afe5088fa6dd9543e464ef30644111a
79	21069	ed33aa8c189a506d21ac64263d952a8b4ef6c3259c0f361519eb2abfd01969de
80	21071	e044bd91adc481444ccc355785f85e4aeaea1d4e9fb443515ae5c5c435e24dbb
81	21072	9fee20ace8b43708df048cfb31bfa276ff3ff3dd6c9429834700580350f03a95
82	21079	00c98cb1030e95bf75e5f87e49ca8b3d4194371b42e2798a9b1c9e078d1f533e
83	21084	b91d9eb19896f0c2157b20e36ee381c1df9347ecc512b588f3261a888fb82a1f
84	21089	96fda1c2b7cac35f4cc36b0978c61b124680734a052324d86dcebb59bbf2436d
85	21090	92102cc25774517d60dbaf387aa203df9731e52ce745e259e11f66bc715e20b2
86	21091	a6c23f7d8cdc70d65d69a41c46180a0f6c5acb1bc07194a2f58d38539a0404c8
87	21092	20e15c891eb96605285cfc9da0566c87b52883d72582a028d85286334c7566d5
88	21095	89ca82b73932d16d144452f61c62138d9e59946175d04e84c8ac93db93c2c2b6
89	21099	89e68bd08b3188a02a5ba4528daab2a5af4e90c529c7a8ce22aa36740010d8f8
90	21103	15efc86b44df2153109dbdd26d6da8f8b623e98f3e1540690bfc0038f326ca57
91	21110	2c517ebd019979b38420c7cebed417b060d4619f4cf730c485f57ad35941049c
92	21112	08fc7caaf841a92d3c032e036e891c32b24482f0b0256aadd2423bd196168e10
93	21114	96f4c8883498c28277f853e6ef42da2da17795e54ddc849022775ff3a7c42f63
94	22006	3886b5f155d72391348c791fde306fdd437e044d9243a72e018f32476ad0e024
95	22007	cf93839b54a66fa79d26e9aede323cacbe1aca0b5eaa451adbc560a4b35fc0de
96	22009	9365dbd27677a9b0dcbcbb81eb8c5286bb7517cb4c97c046006a7e4e1846a0e5
97	22038	8c1ecf072d5c3dd3d1be5b5fe85e097d8e032bc3c9e2f6bde525a464765ca5db
98	22052	9a13a35de80d785dc2b75c7e788ac83fb3c8e0688059e3638f649ff2f6170fb3
99	22068	5ec67a3a98fef4c26e6f1448b38d30b37568841f070d65e272eb8038a35cd5ef
100	22071	f06b79b0e52a403fbd2127631aabd7940956d24eeee9caa00eac7734705baf53
101	22079	88beda928331b2e9d2fd513cf1c2b89fdeb4021045d1a4d07f1a5366c199aa1d
102	22081	7c9cb6ac7c7a22ef7cac5cd42fa968f4f73fb6d80b46c587996f4f63a5331dc2
103	22096	ae3ba86d3d4eea1d38eea4bc43588cd005dfb8ed074f2c136324f00b5bb19245
104	22106	bcc1833fe50c1577c067c36b5f7ae36add24f47a7b7b57dedc4663fb549a2728
105	22107	87f6f232edbe4429cd59914fcad247160a184e44278c1d21b8b5207228b62ade
106	22109	ef6346cb33ce828423aa404cddba401b79c90d8e10261c4a2d91f4f1fe543870
107	22110	ae0a0be0d3856162396fa42c25cf73aad4b9d7c0c80c08074fcee8dc7f08e1ee
108	22115	6d6dfc6e779168c9b7c83065856aee175c3eafc53eafcfc9b7bf68680febf9b2
109	22116	36f6b4399344979c1d09cf67bfe69b2ca9ad18dc443128b2b1300354768038b4
110	22117	348285391ae08d331a8b1c05420e25303eb89bb75ed352e58af90461c7899643
111	22123	aeccb44e8bf35cb26ddc078e3eb3130944112145a9882eefec4e0dfe6e4b34bc
112	22131	cf663836c83f1ebb71957d5b7293f44670783d40ff555f135c5353be25f16b0c
113	22132	744b9e0c25c31d0151692a5f88b0c21fbe6334b2c3b36222e8a74be1ea2f6963
114	22135	b9b74011a5f94bf56e3a277b51e1e8059f4e3fa606366eaadf02f05e0eda4da1
115	22138	7f9fd16b7310ab45fcf618dfa4802ddcd1ed8ccccbdcbcfd1007bb2bffbeadd1
116	22141	0102c365e65b36e48a9cc363a3580378ce34218daf94a57ebb9fdc14b501afaa
117	22142	1fad103d7bee99c466553e558e69d6d19981c241599cab206724ceaacecaa6be
118	23004	7cd2fa6d7a019419803b8bf58500ed74c083e632fe55ef7768655e4c079ddeea
119	23008	6abb4bf330bb02ad86b03ae1ac972997a2de70ff1d5735f3e2a6486f4aa44a44
120	23012	a489b3d194fc4d84e7f5a0aaf570c7be23e452380abe3448aedc0b1c915ed84a
121	23013	8dbd48adafa7bdb0f9b1a7b2ee487769ce3b243518e733873312549c82fe7345
122	23014	86196adddc5ddbd80a58893e46185acc2c80bc72c45acf55e3c60a12fa09cbb3
123	23015	eb1edd3be86cd341bb805779636bc2212d726dbeceacee9c0c8cb6312505a86c
124	23017	5fb6658f829789226920621eed14933c2f03e3534d72e60872059257499f1cd8
125	23019	9d40e7c50a7a3d3a1fa3a4c3afff2e316d2edfb99d54fb1e62be82c3e26c64f7
126	23020	e058b05ca4e5961ad0139155a7a4baf495757f78c0a3369bbc89405e4c6ab5b0
127	23024	677c121bbae5957f87b9dfe25bdaa7365b37c680795b26d9e3fe19285dbde2cd
128	23025	55a2ba4f90f92957461373359aefc74e88df3de90d5fe83657befc63c0bd822a
129	23035	60864581f00af42934dcf5132be59abb44d4c447274c58f42264f7c28cee8118
130	23036	493847757a2c094b9cf8782693ed079830a01306bae24d261362ea2894b6534d
131	23039	0bb5c863db1a3bd4fe6d300ece321c6404cc153573ff5e578dce1824de0e1189
132	23041	b1824bde014a52ba2603b518703d16d3e13d8f37d6258507e77be158584cf457
133	23045	d0436bcb9336d3995dc08811736ef149dfdfc4fdd255f5226880a9d3cc38306a
134	23062	009cc5386559ac2da063eab40aea5362e6d669fb0a2bc336b6af951bc9b3b354
135	23064	200ed22fdac268c7d23316eeb12f7f5caaf8d62678507990a15b68ec77129e90
136	23065	61f31cadd30de0b493c72507f39c6788aa15a57d6474d27774fe08f9d7440703
137	23077	295d30e28635f44a45a7f64956e67b2efbea2bc1f5c37b837fff514d6cc1b5c1
138	23083	8e76c0318700941b0f00e6aff0216d9634cd51d9c5d14c7a0b96e620175481c3
139	23084	c8f0bb78a36588f05502015ed96ef3f60faa8c81d8de77af4614ebeca539dd9f
140	24001	a74de09a9f1107bf441156e068ccdb56b7fb1d02e08aea3c6f7c68e1a0f4b80e
141	24004	1304fd731ba9466203b98be4006e40db0d3a28377549e1000025c09be3d18653
142	24014	fb7afd142d65d0c9e4cedb21942fd46c5f762e05f30710247d5ffa54fcba6679
143	24017	456f8b761a783232caedcdb31bb3ddcadc97f78f7ca9ef678e227ad2b744005d
144	24018	80ff6082c85ffb47f3544d2bbb2f8252747e922c73863cc6a9252e2171fbade0
145	25003	3fd402a69185a943e2dd7b303d06563920493e192a81c4c6530f37434e11bb2f
146	25004	7ea041667221088e79776b87453e6fee83c911949c815b7699798cacc0f40594
147	25005	570bff89a465f42740f488b3a2bd2631b88afa9df8845c0cbdccd4124497dd44
148	25006	49bde7f2c4381c76c9ac6cd5844684737c321a5362c5a29ee43a5e3c79c31735
149	25008	bafdfaae078bcbedc43de7e437177f613945d6bff5c80083843d532b8b754d87
150	25009	8121dd248ccb1f58373cf33f1725b4f57e43b47a80513f77d7af03e1274b38dd
151	25010	1c572fe0d54d5e46efcc382675de2d1739d453d86b2f24816c42d97bef959edd
152	25011	56d59a0899bed91e9177bccc6cb896145de951e02c77b8eb9809600da7165d0e
153	25012	bff5311c0b7d69b691128eb58181a9805dee485c39a623927a5efbe2fd41884c
154	25013	f41852ec599333d03bc1bb1aecee2f0af8502ba75fa6c80bc34a9967ca071075
155	25014	707e83662950b773ed6539868e6f3c2ba1ad642ee79dd73ca1bd12f43f48e661
156	25018	504c3a2005b542585784ad53a511fc947ad240b6333f82ba94c39ddf7aa86562
157	25019	fb66b7a90c4692ccb1d384e3d4ecbd7eac14c597e31ec874a42dc6598cda0817
158	25020	fef5158a8e52a21259d2cde6719f5ca9edd1cf4b70170fa0b5f9a03f5e6973e0
159	25021	bd7f7b8c769f4e24558b2fcbdd91ecb418c151071d25e81e9ff5e24e78357e1e
160	25022	75afd6bb315dfbea11736e17f6562500b979666ff42b32a6b197f03a2fe94efe
161	25023	1ae5d39020100bdfd97a77fc74530cb13b6989d299c8f0440e251b1988e6cc7e
162	25024	4faa0b107abdb5a3049b0508551e97c4890e7ef4bfa6acef4ebf4d047cb2d555
163	25025	c9d3bfeeb3d21f039713e4c37bfd91bb99fc1728ccfb7700a8c6743ad2d6c981
164	25027	a6bef48e17e8f1d16fe73bf77fec2117e1839e74a7008cd868d18aff1fe586a1
165	25028	71ce8a4d86a95dc91bc31492e639d61675f86abc715de49cea199e57e797a02f
166	25030	5ac3cab89a98c8714bc1a11af1e11780f117b059db2912be1026ca6e90aed06d
167	25031	e392ffeb06ca70f40e9a9559506d9d0aaf1be5d8178f652730fd60476a4b0a94
168	25033	123fbd91930088dd4684994eae3d47ef70c1923bb740ae47d7653f460b454a60
169	25034	8bb5d924fe89737a416375f28eb5c356b71cea16495e97189b4db9f59d3df0e7
170	25035	61c63b293bb11a779a981f9f3c13fd02eae50051c602bc6a5a2c66f7d3c8d453
171	25036	63a5c823193dc9f51e0caf2965872b00f7a8bb0f67603ce376e112fdb9044235
172	25037	f4b7667e2d3d4f1128ba506b8fe39d567892b23eb085cc4912ce4287955022f5
173	25038	95be41a0e6764fcc1cea35246c1478a8e9cb93ee1ddfd8653c599236bd0ad6e1
174	25039	369c1648a7cc7b8359b7c7dff0981c950615ae899ab10a0a76e35748da659ced
175	25040	c3ad8e337c68ff1ff5d85c62d459e7e2a2c221bbdc16890d836ec5a8d42aae7b
176	25041	09d4d60a8ac1e11978ff9668950785287e6b216e9468b16ece59e6b17203e5b2
177	25042	beb502d6ec6a0ed9e75fe9a94c04536a001d27161f76d6fa08055f22e9e03ee7
178	25045	e1527ed0945a1ba0243d59ed224d916f5881f0559b2d0260a7d54c91acf7ab62
179	25046	cbd2bca09cd3271a61496c81903246febcff6325ca9a9d6ae25ba1762461998c
180	25047	7fe63cc466f0c87eaea31309861b5813c1be2adfe3fe47a521bf71199a3af470
181	25048	1a56db591181f9335ce0b7143989ee226d13bb2b16ada4b52d67d4e42640c67e
182	25049	b77039f15b61268487c188ef5acaa5f2dca356eac7e162901f24b11a25dee518
183	25050	11429c9e257d52e057db019cbd87a371dd3b20c29c49de8e3f91c57857e500cf
184	25051	26db37284beb979c68fe37be1cd187ae939efd99deba3553a2e2be62747bb90a
185	25052	8e5efb07acfc745567808258a5182da41d821ad16c500ee4fb91cae1ba18d20d
186	25053	acd2f16e7a9b88241993775b62eab1befaf4f552ad2ca7a5029db2a88edf151d
187	25054	ed3f1abde8fb1ee174e188b4b98b50f0817ac84493a8949e1354df75c7f25816
188	25055	4de04bb028b606d3eeec4a5147ce95bca3f9d764e014b1653ca0c3f15a659140
189	25056	c488be1bcb2544b85b3c21dd14dada7c5685012735df5a048042e65b56f30cd9
190	25057	ed2920f2a54e4aee48f0010f9bce64c67cca72851de074aeecac3297678e3963
191	25058	9b5e34fc240cb45f8d1b6f3ec77edb738b7ee981e092ae3863d562169d617875
192	25060	97de5ec670c25ab06d7e779bc209f1d254b0a3e87fb3438e7d9b1507758984c9
193	25061	6da1150418ec6af7b23f7c2809c08187f5a9c766899dcc0da54365e2fb057d36
194	25062	c1d5c06c116a89ddea6377a072c07e90e686510a4e78d20b97d7501645cf4c53
195	25063	fd40eff4b72376b24a2baad451f531bf978cadebe06cdc6426fad7fc473eda2a
196	25066	20bd5c42e0dd20fcde850dd238d6e3d3f44aec2601e8750bd470906300b53148
197	25067	e7837bb8397b10285a09eac1f766b30c343601a0d5165f270f120e58bf9a5ca3
198	25068	ba887fcc5b680c27569a7a056045bed858f3908bbe63fcee511b06eb0aae74b5
199	25069	c12a33a4c20188a582c11ff4740135ab65f380c5d7981d4406cdea580a2c2c3f
200	25070	cfec84399a95318fa89a15f38658885eca3f805bcb81827b29166f9a7106bcc9
201	25073	1970923e776374f51dadb2471f0e9f078ae6be99c6c248f4931123271afcac63
202	25075	7bd54545c7b346234421ada6ab4444b5fe6f91c6490d78ed1d7ca2c4ab763684
203	25076	1bdd55ba916bbb67d8a7c8d4f014474b6bb787b73fc8b031eee26a3a39cb603f
204	25077	efab574a961b294a49adf18aa92f4c3ac7ba8067aee32bafbd0e714cc5e42946
205	25078	468bdbe008536fe146fdcb89fc37128e62e190055c34aae85a13e0e727d3a35e
206	25079	6725ab1a60b16be009f12290e00cc3f9c688142f7ce0bfbb8eaeca869a42f869
207	25080	952b1e2130b998ec196bd996a5ed3588db5a22335bd22264dd92edd76e24a6c7
208	25081	cab6b99018e8d1939f897e2781ebf573ac3d85404e1781f9042c845d145851e1
209	25082	d5d3c526dd76180215bf07c73a9b55c7650f5f4bf4e484f2f090c7b131521185
210	25083	3a5ad417819b255a21888f9aaf722cca86b5d8da417041e016a735b703b28441
211	25084	14ba8976d54eb25cd20d72b83255360d51a7f07f73da0c72284cea14caccf82e
212	25085	34405a5b028b85a922595252b2b21174998ea954672e242dbe7d9326a64d699b
213	25086	b6d1b60dec48b1ed3c860c7d3648809dabbfc179e6d2f8ae63b87c3831f1b469
214	25087	ce570011dca1b984b678e7e2ebf5810f2d8869af90b0641f14b9bb61b3701494
215	25088	539cf36de56dd8a1aca7c991010ef787c78a9a4339633af8de39e9aa55822799
216	25089	a9946a58e8dce34cdfab97c37d9d6a65d2d5b4cf45a1b42101f7ceb620f4fa81
217	25090	9fc3c1475b482e015a71ffe40f199194e85b304d8f6dc56f74ea448e5e76086f
218	25091	b08341e02e37c6f8dbfe2ece62a21b8cd98ef372e89d310f0cda03317b7e83fc
219	25092	9160c4f87c3d442d27b5e57c1a4335ee4c511d508b220368ec36a3de0049bf59
220	25093	76e77693285fd0e0e56d2eac82618306123eeffcc0394d53f5160689aff0e140
221	25094	0754a757acb6c2744ad6be00be71cb8cb63ea073ff3dccee26df9d140b3657ac
222	25095	11cde3908ecc02cfe311b8294736faf381af2e15145b9db6ed87eb3ade251d21
223	25096	079099992bbbf37f65763abb724a7861cb2a57483134597e0c3b17d66dc305c9
224	25097	338283cf2cc1419d4d58aac0d332e7efa2f46a61d3a57bd90c4350180521a890
225	25098	faf164b0e171330825a8f4c2b8319254362774763d45d34405a07cac5b938b00
226	25099	50bff5a45c0a9703c7fd7992609dfc5caaef48a8d7157fe03c0e6e9de3a3c6ab
227	25102	9bdf2bf310f45d58fc1b130db5982c88d6613f531126354b85dfe34092a5fea4
228	25103	51c3b295e5c46dd97a9b1256b29fdf7673504e9029f6f9546e06abc3d5a32b69
229	25104	55e8f65350a87740f7f25a34c68c2026a9caf32ee47d1c71f8f86652aa9b8757
230	25107	2cf6e5bfe1c34007232b53ab541e43105bb18ca3f98045f43ab89fe00743e864
231	25108	c9f9a11b91a9946cb5f6bb6e06985eedd3baa0a23ab0a71a72581430af8126ce
232	25112	ef459205e7ef8d0ca221926de92f69208fd7263f6df058b98c92bd614168ad7c
233	25113	9e3cbe0c8ecb6bcba79e409ce7eff97585d28ce04e29502d11d0c6dc07aa504c
234	25115	7f788a528cf6d9f74f9142489f6e7a1f34ce01a536bfb4ddd50314ddee140efb
235	25116	8061ec08bd49ecdc959bebd271ec4080e30b75cd44098a8eaa4ac4c9ae34a05e
236	25117	8f293279ed50e386998f6b7d07ef0eb120aa7993abef18e8bac175a03e2cdc33
237	25119	dad8076bf52e6c8c119ba030c71938cdb3224ada12a4774db4a49d04d045ba1d
238	25120	d910e074e0490a64429b5bafc18e8ebe8ca36e89daa02d7d6396e37e85df426c
239	25121	677d8d08ff63178fe9a47c9bd8c173f489e8402fe4f0023f8911a95fef721267
240	853	d580a7f4a0521c0f4f9a666e191ac0b2e3e57014d2a5c0a27555386c43fd7e85
241	854	c7bb244f57b42d9adfa2881a5dce2e8aeaffae79d032d41e24da230e4b86c847
242	144	369c93ed56f3449afa98db09346825b838ad413a4eaa88f43b11253a05e416b3
243	45	435fa81d2e3e34b76e40154d878de9f7df8bdc18429d7321f14cd3cb906766a1
244	69	a36b4f42b54219a5dbb5c98680f23adb135b72cd48d34beed6b915ad3632494c
245	70	da08eac8478e4c85f16285f8e6acae04c4b1b337b60f0aea18b3607596611df0
246	76	023736a413a16146837bb207159639c81b0c680e22e0d0c123c06f81241ef214
247	195	9797bd8a16714738d51ed937e049eededdaab3902e913a021e957031382ef788
248	560	b028849446310300bedea02daf566541bc8f3401332149511d78095975c59837
249	593	168b012a961a384fad57021b559e95dc8bb10ae5d5020aec35d81d6714085bdf
250	607	89a699bb8129728cb6433d6288e440bca6df2a141e3c88eef09a79d5c7766717
251	676	cecaed5c97cdf2f58b5ef0074851f736dd2674bce2082cffc5ee501c10d1e9af
252	855	41a85b08694fa1ae4b91448c5b8ebc7eb6233b5cb0b2ef57798edf34e585d9c5
253	868	27b864e13e95c2c32242d642a42a7ba2224d814dd07634bef6f032426bcbc542
254	877	9f47bdeb1adfb059d00f3eb219ba126b78622dd0b1df3b981176f5b66aa5f0e5
255	882	6de07918a058a0a28220bb53b660f843f9f923e6ec26a61e2de5d8c667824e39
256	884	9306aa2c7bd8092e72164de2519554b480b8c3a417bf73ba56532c52f0414b8a
257	891	9d184ab261b06658e897b04c81ee2bb1183ff098a2f7882b83c882d49dc51b53
258	901	f14bfaf1554da5f150179fd08ccd64038c6842cd638562d6ebea87a9d4a8c099
259	914	49b173608ac32d6a8b22aece4fddf74e4c39212189ab71fe40ed47689e52ab78
260	920	f62272526f7e68f40580db6e0ca5629f3e21cf4e287b79af177722a3d2afe1c4
261	945	7160d5df090ea2ac3245471041f3d30aaadf952298f8ecfd18ebb9a9f9c6842a
262	970	d435eb45010e2ea19331ac1b1d1c35dde7a5f1a7e7eac1623cb727a3c02f52ca
263	21006	e77def695ab270fc3d4fa492c1e94250edbfbfc7aaa23f3b5d8f7a384c0020ed
264	21020	7baba5737669950c5da50f5cfcc6f80c02440c9c92e51adc6723e2cc27003d11
265	21040	4e7e124a33c266dc12493539694783cfd68836944b19437aa5b1ac02c0691cb4
266	21116	e3d83831f31bc089b37c96f9882842df0cabd00a9e518f9da25335d56163e037
267	22094	ef6955979589a3379b10cbd5e82c969bb948a15a8b1a67a9669679441fbe5832
268	22144	b25660bdcf6661fcfb6d97e9cd3a470c56bbef333faf71a648a79b2da9856e19
269	22146	033322f0c8b4e085aef10d0836e65b4bae125de140c75d4a1f2d85eb36ca3634
270	25002	18e2e2284b15448c2345095d45ff508b262d63c7fbdcff1e0d8c1b16c9cf6f9a
271	598	6141aa18031fe0ecef423b94518398adeca4e8b05c9b23a2c140e670f451f608
272	894	d8843dd460353cb7dc5bce0a4d74063a2b7e6391585265ee362c2b25bfaca46c
273	22001	0950fe4b8f0429cb2f3db3c59ed86b6b71493f98a2e1853426a88ea5aaaa0621
274	24025	6877649f71fc2ff5cf918c53d0340e2b7f488a4c5538655c342be4a70cfedbda
275	25118	28fd325408a6782d68b2063f2240797d33793768fab7fbb1a20e22a5757480c3
276	24020	7d8518a2f3ef973cd2e463c55d0777e0db8d0961e2e5eabc9dd4b9d1d83b7d22
277	22130	b95b0cde8e8660da27e00b63c0006db033953f76bae88be64d8053b156845d16
278	26001	8848c63fc089a99ef207f707d5a985bee87e2f92527d7db14c16e1b4bb6e355c
279	26002	e4fce30cd0b16e95d4d32272a8a976282c212a9e4fbaf8d93bfbe718470c7d25
280	26003	c6020baa081972d727cbddde1654b6c4da91f88f6716a13fdf419a11f18f9f47
281	26005	95f03f8d682a7072403ed3ce2912d57d3404e1288878f25317c0eca4b2099c6b
282	26006	fbecbebe0775cd8c8652a3197483bc8881c3c96eff1c4cb7fffb64ad09ecf725
283	26007	fe0c13cc8851942594ef58888e1565032072201a4ac29edc0b2e449c3aa671af
284	26008	ecf08c83e49fd8a94b463017cba306181c50b47953e9e2ef4f0c1ce5fea2898d
285	26009	02ce534c89470330898192f81cd81f0bd9cb5adabddfdf6c6f2fc77ad8dee16a
286	26010	a9ed42734aef4e1082ad459a15c7a100e7b663d040d2518e34d5e8925b5ab50c
287	26011	e7a461bca4c1a918751d3a242ab11ec7ab73dfe425d529f233f3225158297eb2
288	13	1834e148b518a43a37e04a4e4fbcee1eb845de6ee5a3f04fe9fb749f9695be42
289	109	696018a7a9406480b8d0851279712c3e1ce8c188eaed0782e8a8f255d9f7dfee
290	136	cae626741bc07bc55752c9350735897c0fdd38f5e6723ec251e0c2fcf24480b8
291	701	edde708fa033bbb27684d8677a6fff730888899e66c60beb7531c82749f8e91f
292	911	02e902832a58fc12a29cf2f890aa5ff5a78053b7810fe78ea31831ca42c91479
293	921	92846472c05901a554fc5dcb6feafabfd50b85c7fea269c9be37748c78eda63d
294	969	02e03c63f265d6c407295f7822ecdc0c171faa1e8e68381c072e6674406b81b7
295	21111	0c373aabeb1ac6746efdf3834f44f5b659cf16b338c4cccd34cd8a2456af25f4
296	22040	d6ef7613a113224d236721cf5bd60a08bda6019b2ea7cd8cdb70ba5b4cd4efb5
297	22134	b52176d0d161b1a045bf61df297fe5789ec0598d1d2198b74deab5a0c8dd5217
298	21120	a33ffa0cb9be08ec6a1ad01e53dc153c7bb1d5fbca05353df62578401f2c0335
299	26013	90e0cb1f4f09a7a18bfd39a057d5e2c36dbf50a7550c2aa9bffcfd506cf216a6
300	26014	b62c18d0abf73fc73f7bb640b580af49488afb7eb8355a1d55395b151acfd24d
301	21045	f741b30fc2bdccb92d348b05f944f6288dff973adbd7e2e9c3098491da29be03
302	22041	ee9fff58ed03f7e32179db59e35f555e1acc746ae0df8a584fe53978a11ad5f5
303	333793	162789dcf994f573d5cb24b5e10557ba5ce77394dccbbc81e53a1050ec479d30
304	333102	8911dc57bacdba1e0c95525ed461296f2c2300127f2bf4f495a5df7ddcb39cdb
305	333792	4da902313810ccfe0dde20878add6f97180b9ba85533d08e3f1ed11a1f3245a9
306	333872	f5f537c687a472443c963d98f56192dbf3ddfdb9ab6c0b67c8905c516e596bbb
307	333392	180ab0f0394ac99db0232dbc7b8ceb6a8dfa0fc1510f1a48f20213e8ebd06a29
308	333902	33d2b8b3f0b95f7ceefae9171ba699e1b03d1e3158d45a53ab07f07bd50a2bbc
309	333802	fa6c15d3ae711ae1d0404daff7eb9764b3e2e1ed5d55dd49b362dbfdde008a4d
310	333389	9906b48124f7c334e8a0dd5cc4ce1fd37bbb6c276a3697bee4d2ee81999ebc44
311	333769	f2476c63b0321c4a21a979c49f50f9e5a1f817e2fe5ece6807bb0c2743e628ae
312	333373	901f5acccaa3ec5e34c333c2ba0cbbafb43cadb65c44cf9d0da33b85cd31b2fb
313	333804	0a19000d6e1b9b6132ff77678b6ff3a73f8b35343d258aeacf52684ad698dcd9
314	333860	65b40d928a328c8401170f4b6f2055a423b3f1aca88693f8024977fe6cc36336
315	333370	815dcce28f3c6252adb4d09e031d8fa97164dd74a4e697e15fb8d8253db5e3fb
316	333083	f6fb7401194fda2b466f938386895918aa1d3d341feca0f94de3072a59c2a0ce
317	334013	253460aba272014a7859abae7c8c0edcf2b1b8a210b13065f6df321c18ed5170
318	333752	8bcf2883b00a8e08988becacf22c9347ef08b4f16ba94f8a7c80cb2901e26759
319	333339	00dcf0d301fc7b82d14aaed11c4a8fbc3699232f679e0d49420ba68611e658fc
320	333816	1058143c7f98c4dc6e61b71bebdf79649cf4cf3f5845815585ae4f80f34525d7
321	334016	74b745df6444d3a90e6f17d581df0f7e24810ea735d560ae5b94351a7ffa57b5
322	333374	c044316ee2204d388fbcc6a1a2af53ac16f6a0575342a967ea0894fb0192d891
323	333617	2d6b6f16c8fe02977d74ab76a2f9dbbc0942c0e3b83ffaf1cbdb6c480651ff04
324	333620	99a1b2252bc5747b31135a62dfa6dc1bcddaabf2d586553e5a12c1da83b24627
325	22157	ed01d61af8cc4452904d76afc6dc9f1aab70dfc032b49f631bef5742eba3f505
326	333757	840ac6f3c3f5bb9d422421b6b03a5d2086a9aa68f27f739dc778e88d86753299
327	333832	35d048b19f27f31f5bbfaa9e71e651a92b511bbcabe6afc669418207ca9e92de
328	333416	5efde756793a5162b71b30def1c9ad943086c8ce55b364f497eaabfcf1105d3d
329	333020	d104eb88f1a0bbfe43d0bc70ac2bdea451d166256ff505b891bd468c77ae8a5d
330	333764	85b1ae797c8bcde1e4b6f4e24a249a7be443123634371cd36afcce4c29c1f288
331	333917	1ac968956b0005fdc2be6cf43384fd8ad9e3acfbf10aebc2fb6d445841d97ab4
332	333173	98f3f495db5f410be7cdac76a078d80acac8276376d6d153a351822b555b279e
333	333612	c8f78c016892d5c451cf8a345b9349babb73f9b5edcee63c26015ddeb8e3cefc
334	22010	8dd6299f24bdd468a7cc0c2486ead72cb7bb088a435187ac10f97e06ca27a714
335	333259	7815e0ac46dcaa32c19b45465614e61bd09efe09444113f8a50498acfc692ad9
336	333086	2d1c34f4c839ecae7df9fd04b1b028d10ce63117100dda6c63adc9cda42ecbe4
337	333123	86070a8d97607eabcf651f31918e3a6932e76aaee3442aaa7748a8f11798026c
338	333868	08de44154b4d9d2607f375f3279b1e5e41b302bd59542d0017308f14111bd50f
339	333811	9f815a093e9075f84f7d14db6d3b25dd26dd6067b98deb9e722318b89ce46afc
340	333659	c509d19fe1da6494f6401b4b59a2d8f6bb8377036d05849e58e3ec758de67286
341	333382	dec5e9ced5b61d7868a20ca3b7ec13e949e8aacb3419b8c25bc55f5bb4ecbed4
342	333660	e51aa9fc6a143b484dced99bc1b7852858d5f1f32d9e1dd5a2e5cf06d4a7e68c
343	333578	8e14c5c4ba4fe24b2cd2e05b3eae1a6c565af89f829e47c02d5c6ccddad69673
344	333567	275aabd4fd471bb1a15f129c4737791b601ff89a1dfde7629b3593723723e83a
345	333794	e15462c9fda5961ba810064ea8c6e99a5348ceb64fb81a8685b8a7ed2a4171a1
346	333736	50a2d90dc066884b3ceaac697a142c5f9de7cb14cf76c16ec7da2fe5e1c74bdc
347	333315	e353a238ace6f53d589f67570331dd0ba6a10334fd32e1b71997c1959cab2282
348	333268	a326dbc2b7dbdbcece75029eae1cab5f54ad26368f945a349b78ac1e68c4b56a
349	333429	395bdf9b9878443f559c98d52677cb77f1b7f81b472716f4e88198b213864c0e
350	333756	189a11f8ddae995ba156ad0b7df314f986c0c789add6b2b0feccf6d7f4147ac3
351	333453	9bc5efcc449975fd8ebd43acd6568da1209271c9953970538f1ecf223b77ca37
352	333539	ae2bcbf4c1972334e8f8b1db9ee6cafee688c566e1bf8ab35d6bfbaeda34f24c
353	333939	694146e5715f69be1d306caed039a083a1ee06a840ea2b9e8eb1e008e9cdd6ef
354	333293	3c78eec7c023c1315caf0b0a71f27207e1fa68f79a867b22c963d1fde1615e5e
355	333378	d7d3ec5293f44e105292e214306b26e2d40b92194505f33b0b35b8c0422ac2f7
356	333425	fef064f7f8596668ec1e223a53e1ab7f4453bbc79030e429a0e06b547afd57f5
357	333989	a21917b2a23a421f7847e87f2937af2dfe1fe22e081c4fed2cbf863bd68e329a
358	333729	69c433b535f98a985f9a98724f31cf003175bf64dcc43ffa7f213b765d6c8c33
359	333994	b285e51b65c83fc003d1c5c708c80a37612556383cd935ff56c219109736271b
360	333141	7e66c529131a01aa22f8fb8864fd3cf4bc07b52b7f858bc2dcfc2956c93b62a7
361	333243	a70eb18c788901e71567ea04465d6f3da949659853290fec8c956c9561b62327
362	333305	5ca428d3781ab86872d811e557f2ce555f9b81ad45c70d606a565b957abbd169
363	99000	1339f60951f85e38e781556d92db3843dc9a358fad3206f74c08af2b474b87eb
364	333941	f27b59b1fc2718e5060016981de13c24aa1e39c3a56561475f68e2fe9d18ecce
365	333565	0396ab38b87ad22bda71469a1ce4d875049f8ac2f3955023f70c6fb70487a2b4
366	333961	868fe349edcf58549c12e4e82707855bfdb83024078c6381f3844c98d6192ce9
367	333574	fd0c6e94b3d6e324d31c4db895656aa8ccf57ce09fd7b1bbba2d37e613362d5d
368	333791	9294c26a3a1b99cb20e98d391e49d021f039ce30a564a77f9c5ef4356e9e41e4
369	333302	c0b29ac0d2e2fc30c8ea3de1769b00ad293ea3a16cf7ab4cfd0905e0aba871fb
370	333257	29ea700576c8a38c95912f3ecbfcabaefe28f0099dac1de25565800349d21148
371	333272	73a51855262f0c43c704bbd87835fc380ac81c2d576baa1a30e703c5c82b0ef8
372	333796	74aff1521c90dfc7bbbd02c5376da903add741c865b7d4c2b71f5d1975e27007
373	333721	c8cbf3fc83dffe29d10a3701b007acf8c80cf09fc4e8ef7bb0ce1c9344954074
374	333144	01d7efdb0dcdb7284847f5ddda9554f0ef7e34fdffff084061b4ac4acf1aaed0
375	893	2990b53535eab95de348aaba7c51ba87fec67fed82e608afe49cc8cb6a87a2ab
376	333292	c6e92039ecf5015bdaef31bdbb4421ebe21ae9a2c6a8b22e6cf76b80c5f4a986
377	333394	8d58f7bd3f0895ee077b46383eb2dc3b83433cdfd37c15751a60706f0148eb92
378	333012	8c9bd705494355f52829bab3d9016c30846642bda929c19a43afc287be36c57f
379	333284	900da2f05f3f1282afb39d60c2cfebcbbf2b0848710f22cf928f93b11f363ec4
380	333441	d152ee28b19f0a71b054e4ccd05beab85a10d84707ca2337e713450b46614638
381	333304	62bee9617f7aea0e42adc25f70a2515179e901cd9bd90825443dfaf580502e46
382	334002	e2313ca14542be5952be9343b01294b04da31d6aea097d012346e434257da9a2
383	333953	92342a907a7be30bcdd3c97f21b71b022af3b59d4edbef142035434c2456add0
384	333753	8f143940362f980659eeb62c11b3ebba4acec858758dc257383b8a4ad2190845
385	333449	869842fc8ad490a468b3671ea9bdefd5957f5f4311f410db14d1e2048a4a7980
386	333987	8a4714d49749345767ecfccd601007be6cf75b4f6019fc6e8e6957f6bd9204b5
387	333702	8901fb9eb4f052aa2076537f224c34860ee5022aa508624a1362208495d0d6b6
388	333827	bc9444cafbf8681aa920e8973f3057fac2d66301f908a6df35fb4e4bd89144f6
389	333889	e12c744d3f051677a5d2986c420e28c6db2c690ef9ae49aee941a59c7de55b37
390	333749	d12feced6b7418cea3193a9ec89f84c157bfae71eb0ede8ea274bb3c6226ea5e
391	333004	f7034e2502610eab7fcabae4094a9843af278e553ca9b808d0ff8262f35c4946
392	333786	4f4a281dd70ba683217af21b24c77b070a596c0c11d202dc844c638649bb4312
393	333964	1f62951b7a9914d47e4e86ecd389d04bcb617fb3ccd4dd3ab30e71c0655bf84d
394	22077	fd2363a8a0600121ed8cf47bd7d1432b19dfb0df6f339a14e8ffe61ce41270b3
395	333754	2c56c3e219db24f5af77bc8aecd0563da9f2832083853ffee494f6d30cfda239
396	333985	85c3102b6064ced45d87cd0e71fe24408a1735035b901640d29e7284ff901843
397	333957	b8c2907fd8c0e9a91722a045e418d09768b6d3e63cd6423d0f02dfe8e52abcfd
398	333841	7badda4236e0e21510d4ada60637342ce2fabb9f2e3921497af126412af57ea5
399	333876	e5eddbd20491fb5d79b314b820f197f5ce400ec48be503cd3a9d7b92d54f765e
400	333188	64050656eb49260c2791df32417958f79d4b4a88f140d5dd79ddbdf2f359994c
401	333398	b9947a9f3a441aa80f4c94506f818afb9767ecdc89ca1d9ae7c34c54958343f9
402	333138	209cc981510976ff9886a0cf6400aa585fa4acd3388dabfec4a540fc69f1ea7f
403	333627	07803c0cfed5c93ee868e954bedfd4d940b8b9d705473801be46b07870530743
404	333487	91dbac7b9213dc4ae94e1b214f744f5b81eb015b966bf10f22894ff8d0f52d95
405	333448	3a2546ea14870be41d265eb00d90a605f0e67f5feab7d69efe2839c39f5a1d5c
406	333414	628c4161410aa99ff3991f7cc28e38cfb34772d4abcc10bad44f24c298fe5319
407	333253	ccb4d51cb7ff9cbfa7e6b2d7577858eda96f7b88f7cf94d751d555b48040bf02
408	333450	bd547e7c9ef848f6c312de80432718a0c2875a3a85687dd3a76858589ccd9520
409	22051	77f0bed592bc9de061ee2effa261f967a80c9b09652d2197a6499916ce1fd4b6
410	596	56e77d4e851bdc7bab17c0e05c8bb592d038924ef87d3db34df8471a8d2598d9
411	333316	e51d6e0d5e4d3af613560ec708ead90072d34ed84fd6411cd4477ed7131f3993
412	23044	d4b8a106e8584d0005f067976a4e882dd3eaf1365b674d1b45af01824a96bf2b
413	333943	29ec1e9c1fa46a833a977b24a7f259c19c34a3f7c9df597bb26e058188bfe9a2
414	333724	70926c8203695bf6dca620b71bed97cae5290200f332f05d53d8b9e77e0d9dfd
415	333175	80fab4a118b296381dd9a60f303172f7603f5fa0e87a63f8a3cc12ccb8502416
416	333892	c2fc04a67dda9b9328300daef1271ea8cb490e3e68aee6d646b98c788e528c78
417	22095	1299bef28cc46ed16f03e3cbc05ea213c0b0f651431cb3e32074c88cae590817
418	992	9afc46a1d0df75f68e45a0156e84bc814f446111e88c6fc89db3c4318e0c10c8
419	333411	3a14dfc3b68e23d52e20bd76a9768410f3c47ab5c63133a50ba68991a848cf39
420	333731	a0c008338507b81ae11b331b76e8b8415249e489ef38548ed0d622bed8ab8252
421	333935	433f843cd9fda0dfbd51851d15d08e82c519ff7e4b013c1e39592f3063d9475e
422	333168	cbddd3ca077867dd5bd1a71812eee1c2bb2eba099b31a0f94280db3a68cc8352
423	333137	b357e93800e16063443227f0d2fd0c8e68b6e078e30e270b7de9bfc5ba5e8153
424	334006	4ff88bba8bd6d7ff708fc5d00ff26c1be092ed94b74cae2ede40b98722f699da
425	333766	149aed58bfe0ee5e53d6ea668e0abef62c0e0893d0a0b675fa6a57cd48cee446
426	333968	e9a72018daa64f054c59fd7372b77470875c79b7fee115c29582425b60450a31
427	333192	a23efa7fc8cbcc064ca4633313ebddefbca1842a29c1a8b0f23ecd86e1c36d46
428	333913	e0741b4b89a3a06e2cae48231cb799bea97d95483735f11e7a926251ff217657
429	333948	8bac0960547b5bfd1c5d3d1bddd97e40da5727d13207ae91d40476817e7df66b
430	333682	f12f328ac443fb175acbccf424b2b5cbdc5c906a4fb051aa9cc79296f9d0e991
431	333806	c9496fc2a93367f99a090b47720f62b681e6e9765fc2339c1518a84ed51427fd
432	333003	8b6091da25aef7683ddd99c5dc4c7134a69a228173ee249e625ed807cfe92f40
433	333895	f218fe5f5112de532d9ce63af260ef1f6289a5a64fd9666fe63e2c82bb23cc9e
434	333442	da9f416f3ccf0c1c9051c0c3d4e3e98004d8f9a5a2e2c3f778c7c8de5910296b
435	333247	2b6f92ff5f0c0d9119eb5ba7eb583322a4a05432601e683c5174fb372c3cdb17
436	333438	9599277f483e9bdea7634f16079d783bbf5153750e0ad7899f11af2a9aafb3a1
437	333649	c3cb34497a7d8879d88dfc2d6c136c9c21ffbae79680e1e63f18b2c3a2a69f3d
438	333936	e293177c5e438b73ea73e4e88fda3c37f3d7baca54ca466a7b79a26fbc617ab8
439	333366	23a7d4419a7b5f7fc73334a2d68656dd0f797aec838f3de967c09997a69823d8
440	333750	4bc39133a7484637455377716d465b55e24a51169f1393b6237965986da6cb84
441	333662	bddbef9c78c248cd2350e86f530d84dd381143fbb7b629c5458344fc33b88725
442	333992	f5d90f97d3611ad003373031c0d2681d4568853dc1de06d073be42cddb6a6d64
443	333864	7ee0693ce4e73829c343c0b442aa89b812cdbab78b706a521f9549879372d802
444	333746	883a18401ad2d9ad4aa718bca72bc9c035af982c8906f013dad87345ddd624b2
445	333684	3cd2fc9599e2e7d0b122ee82948262412a6013be3d34b15c90945310f0cd4a2c
446	333310	98d4993cb6c96ac0ca5a4e6dbd297534ec4e508fccb023be08ae408e7b77f47c
447	333568	c63c8d853dac967c7c77cd1b47e3a6e92216035aa6a90686781b39b3a0017df7
448	333743	528b846f45d2be2f85168a391049146170dc851ab0ef1c463778058a0f7f1156
449	333417	3c0808d9e6c78187c924c49b0035e6c79ca92e031a93530f511fc1e59bd1178f
450	333693	aa73518f86a92813b65862b28fe004c61b23bf82c38bd142bf6fe4bf79be3328
451	333415	d12c759a44252333eca9d5d1ab60b2ec6f2c4eb87fee3e211d66001f8de84dd5
452	333771	88f7c2cec31a13986ff7bd6df3da6c4c323d34720df07a9174dcfa4c86c8d8cc
453	333451	5837ac77536498187bdb78d97c4d00d5c06c6ec11b8cdbd77ba5d600af85b578
454	333278	d33e34f3dc4afc81e4184b42ba6e407f62613a064c1bc0391bc77fa84cbdd931
455	333858	47dc70a07a030de097f08c8c5895bff35926ea8f9b251a827748ff7dd5147502
456	333734	94415e580f5a474e038e15ba2a3be4fb69c87f8aa588d7052116ac9a043fb6da
457	21016	cf84d9097350aadb44399f58a786e89ba64e6bc32bc05d4fbe06956f00b7f00b
458	333562	192370f539aa38b9660cb18361937e585d6a391edd4a9df451ad29d7aeab9c83
459	333556	68eba499be180235a2f0f2e5f6aa9ed44463c9a700cde85430c71bec4b11f4ff
460	333814	1d0018fc5d7f0627c2254ba1b837447ead98a62221fb5506ae591978cc8ab594
461	333404	5fb4939b008df926888a6209f9c045222b5fd317856f61958a49a4a22e94e565
462	333988	36ab80305ebf322130b098088a3ff99e262d3941b174a357e0f3140f8762d1b6
463	333563	f97793fcac02b6a03536d1580e6604ad00acc24c748b520169f886150054142a
464	333439	256cd7a238b4266a3a850145fb40976d3de2f7a2e43e03a4182713ff2654d498
465	333263	6b45db8982e8984ba64f6005da37379e6a112863b79c8425dfb91ecc61d72bb6
466	333264	30ec2b3ef91873aedca87e19bf53812e0f6172d2f800e6c9a52f35d199227d1d
467	333833	7c363e391e76937e84c9136ba2607a6361fb233d9e09a67040b69e96766995d6
468	333372	f6d837f5b05a9826a157f80801e1950b461e3501d201f58cced8ce01eaea0ef4
469	333532	ad7669b2bb2628338b0e8711e086cc7c9d9daf4db108c897793e08ba3000c590
470	333283	1c07f87b2a0201330f221e9a4f65ec36d7896fa9bf2e66dacf798881890c2a24
471	333176	9eeacfa057e7de794b15489a249e23add85e5099539c1c16c0f705969f23e62f
472	333931	a055fdd69197cb072b27ea4202ce0e8679526020effd6c3e9292cd41dc9799a6
473	333205	c424770d6fbe7e390d506136c1c27d0f43e036a2f1640c895f6f07c720942157
474	334014	2b344fce68bb7d4838c13ffc518e69da501bdf196a7c672937b0e404ccd8a78c
475	333608	cef059b333b002a11adfdfc0ba95ea376d86170ddaee1a1ed6af89c40f51a926
476	333467	d21b304ba0f3e8567facfa7a0670518df17a5f3a02fa6974437bcabacef2674b
477	333363	88c51fc843535c764dfa9b8dc435b48d9f5c73e55d1c93428e175d7264a4be8d
478	333971	c4cf78499be5cf65eef4db172b45e2cc3b7ea4efd86aa23ac502929fbc6ccbb0
479	333571	e7ea0bc04877bc3fe4ecb6ba3923d5130c10ea4b40f23f9f3cbd13a0b23ff113
480	333267	e7c9109cdfef6cf26d39b737a1c068a02684c6e07d356abbabd68c9e614aa215
481	333424	d3adec2d1b8953683ba8b291e70be3d7cda7392868e8c5bf8557cb23a53a11ad
482	333812	be8166acf3b05901169d0344627a9879abeedba01e746e417ecdc4c2ded31507
483	333525	640b3bd4907c4db928f6f153e3aa83e8983a8a8da6a06efd0cb5642b976a0c0c
484	333481	1bd5bfef99296f713a9876239ed3c9cbbfd45af32f269442af1a3403bc2edbc1
485	333730	9688a868d5aecf8d1cc0cba03ac86c6afa1a844517c6b3e16b57c74e8f569bde
486	333867	9bf42bdc5732e93c16a9065d625465801ad2c2814077bf16671830669f5b4be5
487	333759	b46e6fbe9fffc02dcc4d669f0f17f26be9c229177326f7571b8b71c353918dac
488	333418	cec236d2574f3a2825f965f94ecfb3cfb083634a1018b68bd86b4248d721b73f
489	22060	95b3658d54fc974a55db58249931475880e7d220d6c5443388106e52c8f6fd03
490	333748	07b6d922f5e8860d7f16910d03d00eb152df8b1bc612f5f9a3ef76819eced127
491	333933	18acd5f45e7ea36438d9e358fd2db94a9a67d82220198c28cb419d03f7517109
492	23076	071158e7b607b460fe050ac9f877afa60790e2f4470331038d3ef12842501111
493	23003	377ded722a15a826ebd465ebb5e3df00a2fd4b64ec120687758fa11f67986cf3
494	22137	ab30dba63dc82d98dea47f56a6c0a3db4cbd678502ecfb2ed23dd57747b0926b
495	22098	6ea44c2369cc8202f0bffe42f00bc58b769403aadf587addcfe87473a5c20b86
496	333286	5a4c02999bb388b4bc13ec5cf80855167dc9d8c923aad83a95444917dcaf0918
497	333546	d9d85b63a5ee265593abfb32499302648bed3d08d3d448a5d4770bce34442112
498	333432	af08e1c2b2a42a00958624409ba9967c036bf4ab289595dda78d50a0f7953c5c
499	334009	accdb0ece21c5a1f15ec0a10354e7951342a92d0ab1d1b24e2705c8cbf3ea715
500	333704	6735ea0fe4d989a476f31d600b019b58962c6cf83ad8d905f7505448b172848f
501	333990	9be5e826097bbd100f329b85d607ef5033aad864af10dc0cad2493fbcaf672e7
502	333544	0c037f89e797ff68724cefec7b2c7bd2cba9d4034d33c231c65c09dc514e9586
503	895	3d93bf48ed66a9de05c65a1191efc76b285c36c71cde7192d0f1f4524d13e3fd
504	489	c579ba9cf2d0d64b8cdff05648d275677e222cadde13540b2e3a3cf26aea9b87
505	333491	eb19517edaee77f9983e44921c4166c57efdeb124bc6cd8d55d691138814ac9d
506	333395	d3a015c5091311fb2c20671409745effe229daf2272692b210b9aef5ca0394df
507	333463	026e90238c121fe74e385014d9d9d88188764ec9a98f10a8cdfff90642d7fcd9
508	333266	62d2b93c3a7e3b0095dd506a4a6d99e60b6a24e5bf389777eb04fd39d79f0058
509	333993	9c9af54773ff92e2a790bd436b48008b35c403624692679db774782c1557da39
510	333886	51d6ba50548ef18f791a0ee463ecda4424278da8f9a0a24500b59b8955c35fcb
511	333986	55e0ac87d4522f7735b890a99ff2917e6682fd0957cb661caa14eee81135f734
512	333437	d802ae2c29a9eb17d3d1ebb0c69e3e46cf3d7d464d85f5a2d0b7aa6217746854
513	990001	5c8c9624fb4a3a7e4444e7994f637d2a0b063e542ef709c40002784a3e29082b
514	98	47d59d7a57f92a874795101ae8a08dbc3d8684daeea1d6871f7e1e02c267cf7d
515	83	b6caf3d2c4c6effb2f212bd9bced665de6b2d503fafc60e46b6022fbfb5156c9
516	81	fe1f9f0fea79c9b9be38ad49a816ee32d36233e1aefd70559cebb0480e64e8cf
\.


--
-- TOC entry 3831 (class 0 OID 466564)
-- Dependencies: 241
-- Data for Name: staff_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_profiles (id, full_name, staff_email, staff_phone) FROM stdin;
4	User	user	+260970000004
5	Asset Administrator	assets	+260970000005
7	Fokisi	forgetbanda@hotmail.com	0779240028
59	Martin Nhidza	mnhidza@ophid.co.zw	26377000059
135	Tendayi Murape	tmurape@ophid.co.zw	263770000135
264	Manatsa Chirasha	mchirasha@ophid.co.zw	263770000264
528	Blessing Ziki	bziki@ophid.co.zw	263770000528
639	Obey Shoko	oshoko@ophid.co.zw	263770000639
683	Sithembinkosi Mazivisa	smazivisa@ophid.co.zw	263770000683
696	Nyaradzo Mushonga	nmushonga@ophid.co.zw	263770000696
896	Sithembinkosi Gumbo	sgumbo@ophid.co.zw	263770000896
898	Judith Dube	jdube@ophid.co.zw	263770000898
899	Saziso Nyathi	snyathi@ophid.co.zw	263770000899
983	Sheron Chakawora	schakawora@ophid.co.zw	263770000983
21014	Mathias Butale	mbutale@ophid.co.zw	26377000021014
21015	Khumbulani Moyo	kmoyo@ophid.co.zw	26377000021015
21046	Denise Donga	ddonga@ophid.co.zw	26377000021046
21102	Adam Chindore	achindore@ophid.co.zw	26377000021102
23068	Shaint Mudimba	smudimba@ophid.co.zw	26377000023068
23071	Francina Mudzingwa	fmudzingwa@ophid.co.zw	26377000023071
25109	Angela Mushavi	amushavi@ophid.co.zw	26377000025109
25110	Robert Gongora	rgongora@ophid.co.zw	26377000025110
132	Tsitsillina Apollo	tapollo@ophid.co.zw	263770000132
591	Takura Matare	tmatare@ophid.co.zw	263770000591
251111	Owen Mugurungi	omugurungi@ophid.co.zw	263770000251111
2114310	Gwendoline Kudzai Mugauri	gmugauri@ophid.co.zw	2637700002114310
482	Dorcas Mufaro Matora	dmatora@ophid.co.zw	263770000482
636	Obert Chisenye	ochisenye@ophid.co.zw	263770000636
642	Moreblessing Chikwava	mchikwava@ophid.co.zw	263770000642
692	Tshiyiwe Nyoni	tnyoni@ophid.co.zw	263770000692
694	Vongai Ngwenyama	vngwenyama@ophid.co.zw	263770000694
698	Diana Nyamupepema	dnyamupepema@ophid.co.zw	263770000698
707	Precious Mpofu	pmpofu@ophid.co.zw	263770000707
870	Simion Chipfunde	schipfunde@ophid.co.zw	263770000870
875	Sibonginkosi Moyo	toedit1@ophid.co.zw	263770000875
922	Angeline Nyajambwa	anyajambwa@ophid.co.zw	263770000922
923	Faith Vumbukwa	fvumbukwa@ophid.co.zw	263770000923
927	Lynette Ndlovu	lynette.ndlovu@ophid.co.zw	263770000927
932	Jacob Mutiti	jmutiti@ophid.co.zw	263770000932
939	Phumulani Moyo	pmoyo@ophid.co.zw	263770000939
946	Pamhidzai Masanganise	pmasanganise@ophid.co.zw	263770000946
948	Nqobizitha Ndiweni	nndiweni@ophid.co.zw	263770000948
952	Alice Nyamhuno	anyamhuno@ophid.co.zw	263770000952
954	Ireen Chibanda	ichibanda@ophid.co.zw	263770000954
958	Similo Ndlovu	sndlovu@ophid.co.zw	263770000958
963	Thando Mkhandla	tmkhandla@ophid.co.zw	263770000963
966	Atwell Moyo	amoyo@ophid.co.zw	263770000966
967	Josias Mabena	jmabena@ophid.co.zw	263770000967
968	Calvin Mbambo	cmbambo@ophid.co.zw	263770000968
975	Moses Mabanja	mmabanja@ophid.co.zw	263770000975
976	Sithembile Sithole	ssithole@ophid.co.zw	263770000976
977	LLOYD Garura	lgarura@ophid.co.zw	263770000977
981	Elinah Tembo	etembo@ophid.co.zw	263770000981
986	Nontokozo Sibanda	nontokozo.sibanda@ophid.co.zw	263770000986
21022	Primrose B Ndlovu	pndlovu@ophid.co.zw	26377000021022
21026	Sindiso Mpala	smpala@ophid.co.zw	26377000021026
21030	Ntombizile Setheli	nsetheli@ophid.co.zw	26377000021030
21032	Mavis Simanga	msimanga@ophid.co.zw	26377000021032
21033	Cynthia Mpofu	cmpofu@ophid.co.zw	26377000021033
21034	Sipiwe Hadebe	sipiwe.hadebe@ophid.co.zw	26377000021034
21039	Tinashe Hamunakwadi	thamunakwadi@ophid.co.zw	26377000021039
21041	Sandisiwe Ngwenya	sandisiwe.ngwenya@ophid.co.zw	26377000021041
21049	Ntombizodwa Dzotsa	ndzotsa@ophid.co.zw	26377000021049
21051	Lexington Ndlovu	lexington.ndlovu@ophid.co.zw	26377000021051
21054	Thembelani Msipha	tmsipha@ophid.co.zw	26377000021054
21055	Mavis Nyoni	mnyoni@ophid.co.zw	26377000021055
21058	Sibonokuhle Mlotshwa	smlotshwa@ophid.co.zw	26377000021058
21063	Mellissa Chikwana	mchikwana@ophid.co.zw	26377000021063
21064	Artson Zhou	azhou@ophid.co.zw	26377000021064
21065	Edith Ntini	entini@ophid.co.zw	26377000021065
21066	Noah Madziva	nmadziva@ophid.co.zw	26377000021066
21067	Sandra Danger	sdanger@ophid.co.zw	26377000021067
21068	Zenzo Dube	zdube@ophid.co.zw	26377000021068
21069	Khawulani Dube	kdube@ophid.co.zw	26377000021069
21071	Mncedisi Ncube	mncedisi.ncube@ophid.co.zw	26377000021071
21072	Thivi Muleya	tmuleya@ophid.co.zw	26377000021072
21079	Pelegi Ncube	pncube@ophid.co.zw	26377000021079
21084	Esnath Ndlovu	esnath.ndlovu@ophid.co.zw	26377000021084
21089	Cornwell Nkala	cnkala@ophid.co.zw	26377000021089
21090	Passmore Mamhinga	pmamhinga@ophid.co.zw	26377000021090
21091	Zandile Sibanda	zsibanda@ophid.co.zw	26377000021091
21092	Sikhuphukile Moyo	sikhuphukile.moyo@ophid.co.zw	26377000021092
21095	Kangamwiro Mavhiki	kmavhiki@ophid.co.zw	26377000021095
21099	Doreen Rafomoyo	drafomoyo@ophid.co.zw	26377000021099
21103	Ursula Dube	udube@ophid.co.zw	26377000021103
21110	Mandisi Ncube	mandisi.ncube@ophid.co.zw	26377000021110
21112	Bulukani Moyo	bmoyo@ophid.co.zw	26377000021112
21114	Pentecost Sithole	psithole@ophid.co.zw	26377000021114
22006	Sheila Mariga	smariga@ophid.co.zw	26377000022006
22007	Talent Mvenge	tmvenge@ophid.co.zw	26377000022007
22009	Virginia Ziki	vziki@ophid.co.zw	26377000022009
3	System Automation	sup	+260970000003
2	System Pool	man	+260970000002
22038	Norman Dube	ndube@ophid.co.zw	26377000022038
22052	Dingilizwe Mpofu	dmpofu@ophid.co.zw	26377000022052
22068	Beatrice Kantanzih	bkantanzih@ophid.co.zw	26377000022068
22071	Sizalobuhle Moyo	sizalobuhle.moyo@ophid.co.zw	26377000022071
22079	Ndumiso Makeba	nmakeba@ophid.co.zw	26377000022079
22081	Margaret Gengezha	mgengezha@ophid.co.zw	26377000022081
22096	Sifiso Ndebele	sndebele@ophid.co.zw	26377000022096
22106	Ruth Maria Mandaza	rmandaza@ophid.co.zw	26377000022106
22107	Nozihlobo Sibanda	nozihlobo.sibanda@ophid.co.zw	26377000022107
22109	Sibonginkosi Moyo	toedit2@ophid.co.zw	26377000022109
22110	Luka Mudenda	lmudenda@ophid.co.zw	26377000022110
22115	Joanna Sibanda	jsibanda@ophid.co.zw	26377000022115
22116	Bongani Tshuma	bongani.tshuma@ophid.co.zw	26377000022116
22117	Thabani Nyathi	thabani.nyathi@ophid.co.zw	26377000022117
22123	Emmaculate Gumbo	egumbo@ophid.co.zw	26377000022123
22131	Sihlobo Fuyana	sfuyana@ophid.co.zw	26377000022131
22132	Faith Wadzanai Marunya	fmarunya@ophid.co.zw	26377000022132
22135	Amanda Bubele Mpofu	ampofu@ophid.co.zw	26377000022135
22138	Ntombiyelanga Khumalo	nkhumalo@ophid.co.zw	26377000022138
22141	Shamiso Tagarira	stagarira@ophid.co.zw	26377000022141
22142	Rumbidzai Chinyowa	rchinyowa@ophid.co.zw	26377000022142
23004	Shylet Manyika	smanyika@ophid.co.zw	26377000023004
23008	Tafirenyika Ropa	tropa@ophid.co.zw	26377000023008
23012	Edgar Kamungwara Banda	ebanda@ophid.co.zw	26377000023012
23013	Norman Dondo	ndondo@ophid.co.zw	26377000023013
23014	Fransisca Ndlovu	fndlovu@ophid.co.zw	26377000023014
23015	Vusomuzi Magotsi	vmagotsi@ophid.co.zw	26377000023015
23017	Ntombiyempi Ncube	ntombiyempi.ncube@ophid.co.zw	26377000023017
23019	Nkosiphile Siziba	nsiziba@ophid.co.zw	26377000023019
23020	Nesisa Sithole	nsithole@ophid.co.zw	26377000023020
23024	Tambudzai Nyabinde	tnyabinde@ophid.co.zw	26377000023024
23025	Bongani Ndlovu	bndlovu@ophid.co.zw	26377000023025
23035	Ezimon Siamusanu Munkuli	emunkuli@ophid.co.zw	26377000023035
23036	Simon Siatimbula Siamilandu	ssiamilandu@ophid.co.zw	26377000023036
23039	Lungile Sibanda	lsibanda@ophid.co.zw	26377000023039
23041	Tobias Nkata	tnkata@ophid.co.zw	26377000023041
23045	Monica Chikura	mchikura@ophid.co.zw	26377000023045
23062	Mandlenkosi Kaweni	mkaweni@ophid.co.zw	26377000023062
23064	Jimmy Munsaka	jmunsaka@ophid.co.zw	26377000023064
23065	Tapiwa Gape Madzipa	tmadzipa@ophid.co.zw	26377000023065
23077	Sithulisiwe Nhlane	snhlane@ophid.co.zw	26377000023077
23083	Moreblessings Sibanda	msibanda@ophid.co.zw	26377000023083
23084	Ayanda Ncube	ancube@ophid.co.zw	26377000023084
24001	James Mwinde	jmwinde@ophid.co.zw	26377000024001
24004	Blessings Eriter Fakazai	bfakazai@ophid.co.zw	26377000024004
24014	Precious Ndou	pndou@ophid.co.zw	26377000024014
24017	Karen Ncube	kncube@ophid.co.zw	26377000024017
24018	Prichard Muzenda	pmuzenda@ophid.co.zw	26377000024018
25003	Saziwe Sibanda	ssibanda@ophid.co.zw	26377000025003
25004	Ackum Matira	amatira@ophid.co.zw	26377000025004
25005	Nicholate Kusekarombe	nkusekarombe@ophid.co.zw	26377000025005
25006	Ngoni Keith Bote	nbote@ophid.co.zw	26377000025006
25008	Sikhalo Shantani Faba	sfaba@ophid.co.zw	26377000025008
25009	Brian Zamasiya	bzamasiya@ophid.co.zw	26377000025009
25010	Xolisani Moyo	xmoyo@ophid.co.zw	26377000025010
25011	Mthokozisi Moyo	mthokozisi.moyo@ophid.co.zw	26377000025011
25012	Belton Sibanda	bsibanda@ophid.co.zw	26377000025012
25013	Cynthia Nkomo	cnkomo@ophid.co.zw	26377000025013
25014	Melusi Maphosa	mmaphosa@ophid.co.zw	26377000025014
25018	Nzona Zulu	nzulu@ophid.co.zw	26377000025018
25019	Angela Mbangani	ambangani@ophid.co.zw	26377000025019
25020	Concilia Dube	cdube@ophid.co.zw	26377000025020
25021	Nomcebo   Mcebowethu Msekiwa	nmsekiwa@ophid.co.zw	26377000025021
25022	Zifiso Ndlovu	zndlovu@ophid.co.zw	26377000025022
25023	Bezel Tshuma	bezel.tshuma@ophid.co.zw	26377000025023
25024	Payne Mudimba	pmudimba@ophid.co.zw	26377000025024
25025	Zibusiso Nkala	znkala@ophid.co.zw	26377000025025
25027	Mbonisi Tshuma	mbonisi.tshuma@ophid.co.zw	26377000025027
25028	Melusi Dube	mdube@ophid.co.zw	26377000025028
25030	Zanele Moyo	toedit3@ophid.co.zw	26377000025030
25031	Diana Nomthandazo Nkomo	dnkomo@ophid.co.zw	26377000025031
25033	Victor Dube	vdube@ophid.co.zw	26377000025033
25034	Nozipho Ncube	nozipho.ncube@ophid.co.zw	26377000025034
25035	Sandile Nehwati	snehwati@ophid.co.zw	26377000025035
25036	Petronella Michelle Ndebele	pndebele@ophid.co.zw	26377000025036
25037	Simingenkosi Hadebe	simingenkosi.hadebe@ophid.co.zw	26377000025037
25038	Brilliant Nompumelelo Nxumalo	bnxumalo@ophid.co.zw	26377000025038
25039	Zanele Moyo	toedit4@ophid.co.zw	26377000025039
25040	Vongai Mabhena	vmabhena@ophid.co.zw	26377000025040
25041	Melissa Tshuma	melissa.tshuma@ophid.co.zw	26377000025041
25042	Nomsa Dumani	ndumani@ophid.co.zw	26377000025042
25045	Tsitsi Ngwenya	tngwenya@ophid.co.zw	26377000025045
25046	Charity Ndlovu	cndlovu@ophid.co.zw	26377000025046
25047	Brendar Mtetwa	bmtetwa@ophid.co.zw	26377000025047
25048	Siphathokuhle Khumalo	skhumalo@ophid.co.zw	26377000025048
25049	Concilia Nothando Maphosa	cmaphosa@ophid.co.zw	26377000025049
25050	Lorraine Rudo Mlambo	lmlambo@ophid.co.zw	26377000025050
25051	Bahle Dube	bdube@ophid.co.zw	26377000025051
25052	Beverly Mirirayi Mangayi	bmangayi@ophid.co.zw	26377000025052
25053	Langton Matsetlo	lmatsetlo@ophid.co.zw	26377000025053
25054	Precious Bidi	pbidi@ophid.co.zw	26377000025054
25055	Sheron Moyo	sheron.moyo@ophid.co.zw	26377000025055
25056	Busi Chitambara	bchitambara@ophid.co.zw	26377000025056
25057	Ludgard Moyo	lmoyo@ophid.co.zw	26377000025057
25058	Sithenjisiwe Ncube	sncube@ophid.co.zw	26377000025058
25060	Kumbula Ruth Ndhlovu	kndhlovu@ophid.co.zw	26377000025060
25061	Primrose Mangena	pmangena@ophid.co.zw	26377000025061
25062	Esther Chipato	echipato@ophid.co.zw	26377000025062
25063	Tapiwa Maruza	tmaruza@ophid.co.zw	26377000025063
25066	Karen Muchezana	kmuchezana@ophid.co.zw	26377000025066
25067	Valerie Bekezela Msimanga	vmsimanga@ophid.co.zw	26377000025067
25068	Charity Musinake	cmusinake@ophid.co.zw	26377000025068
25069	Memory Hasha	mhasha@ophid.co.zw	26377000025069
25070	Christine Mhande	cmhande@ophid.co.zw	26377000025070
25073	Fortune Sheilla Ncube	fncube@ophid.co.zw	26377000025073
25075	Patricia Mhlanga	pmhlanga@ophid.co.zw	26377000025075
25076	Listen Pikirayi	lpikirayi@ophid.co.zw	26377000025076
25077	Sithembinkosi Jamela	sjamela@ophid.co.zw	26377000025077
25078	Junior Mweembe	jmweembe@ophid.co.zw	26377000025078
25079	Samkeliso Moyo	samkeliso.moyo@ophid.co.zw	26377000025079
25080	Chido Siyakurima	csiyakurima@ophid.co.zw	26377000025080
25081	Thulani Nyathi	thulani.nyathi@ophid.co.zw	26377000025081
25082	Stephen Shereni	sshereni@ophid.co.zw	26377000025082
25083	Nathan Tendayi Ruzane	nruzane@ophid.co.zw	26377000025083
25084	Funny Adams Mgugu	fmgugu@ophid.co.zw	26377000025084
25085	Alfred Nkohla	ankohla@ophid.co.zw	26377000025085
25086	Nancy Mushayi	nmushayi@ophid.co.zw	26377000025086
25087	Yvonne Rumbidzai Chimedza	ychimedza@ophid.co.zw	26377000025087
25088	Winnie Moyo	wmoyo@ophid.co.zw	26377000025088
25089	Sali Ngwenya	sali.ngwenya@ophid.co.zw	26377000025089
25090	Sandra Chizondo	schizondo@ophid.co.zw	26377000025090
25091	Mluleki Moyo	mluleki.moyo@ophid.co.zw	26377000025091
25092	Tongai Webester Govere	tgovere@ophid.co.zw	26377000025092
25093	Manqoba Moyo	manqoba.moyo@ophid.co.zw	26377000025093
25094	Charles Chikukwa	cchikukwa@ophid.co.zw	26377000025094
25095	Mpokiseng Ncube	mpokiseng.ncube@ophid.co.zw	26377000025095
25096	Tatenda Michael Charamba	tcharamba@ophid.co.zw	26377000025096
25097	Salia Chapanduka	schapanduka@ophid.co.zw	26377000025097
25098	Jeremiah Muzvidziwa	jmuzvidziwa@ophid.co.zw	26377000025098
25099	Mandy Buys	mbuys@ophid.co.zw	26377000025099
25102	Similo Moyo	similo.moyo@ophid.co.zw	26377000025102
25103	Nathan Sianzembwe	nsianzembwe@ophid.co.zw	26377000025103
25104	Reason Chirinda	rchirinda@ophid.co.zw	26377000025104
25107	Thamsanqa Nkomo	tnkomo@ophid.co.zw	26377000025107
25108	Tonderai Ernest Dobiwa	tdobiwa@ophid.co.zw	26377000025108
25112	Edith Ngwenya	engwenya@ophid.co.zw	26377000025112
25113	Irvine Zimbizi	izimbizi@ophid.co.zw	26377000025113
25115	Edelina Ndlovu	edelina.ndlovu@ophid.co.zw	26377000025115
25116	Samantha Mpofu	smpofu@ophid.co.zw	26377000025116
25117	Tonny Ruvingo	truvingo@ophid.co.zw	26377000025117
25119	Tapiwa Mpasi	tmpasi@ophid.co.zw	26377000025119
25120	Vusumuzi Ncube	vncube@ophid.co.zw	26377000025120
25121	Thandiwe Dlamini	tdlamini@ophid.co.zw	26377000025121
853	Rumbidzai Chiwetu	rchiwetu@ophid.co.zw	263770000853
854	Trish Manyati	tmanyati@ophid.co.zw	263770000854
144	Lekani Sansole	lsansole@ophid.co.zw	263770000144
45	Tandiwe Chinzodzi	tchinzodzi@ophid.co.zw	26377000045
69	Karen Webb	kwebb@ophid.co.zw	26377000069
70	Million Goredema	mgoredema@ophid.co.zw	26377000070
76	Sara Page-Mtongwiza	spagemtongwiza@ophid.co.zw	26377000076
195	Trudy Ncube	tncube@ophid.co.zw	263770000195
560	Tafadzwa Bepe	tbepe@ophid.co.zw	263770000560
593	Kenneth Masiye	kmasiye@ophid.co.zw	263770000593
607	Theonevus Chinyanga	tchinyanga@ophid.co.zw	263770000607
676	Muchaneta Mandara	mmandara@ophid.co.zw	263770000676
855	Aleck Mandivengerei	amandivengerei@ophid.co.zw	263770000855
868	Memory Benjamin	mbenjamin@ophid.co.zw	263770000868
877	Zvikomborero Mhaka	zmhaka@ophid.co.zw	263770000877
882	Denis Mumbire	dmumbire@ophid.co.zw	263770000882
884	Efison Dhodho	edhodho@ophid.co.zw	263770000884
891	Pugie Tawanda Chimberengwa	pchimberengwa@ophid.co.zw	263770000891
901	Benjamin Mukandi	bmukandi@ophid.co.zw	263770000901
914	Elliot Zingoni	ezingoni@ophid.co.zw	263770000914
920	Sylvester Midzi	smidzi@ophid.co.zw	263770000920
945	Kudakwashe Chisango	kchisango@ophid.co.zw	263770000945
970	Silas Magundani	smagundani@ophid.co.zw	263770000970
21006	Rodney Dembetembe	rdembetembe@ophid.co.zw	26377000021006
21020	Forget Banda	fbanda@ophid.co.zw	26377000021020
21040	Tinashe Chinenyanga	tchinenyanga@ophid.co.zw	26377000021040
21116	Sharon Musewe	smusewe@ophid.co.zw	26377000021116
22094	Yvonne Chinzou	ychinzou@ophid.co.zw	26377000022094
22144	Danai Kudakwashe Mutasa	dmutasa@ophid.co.zw	26377000022144
22146	Gladman Tatenda Magumise	gmagumise@ophid.co.zw	26377000022146
25002	Nyasha Chirandu	nchirandu@ophid.co.zw	26377000025002
598	Kety Choga	kchoga@ophid.co.zw	263770000598
894	Phumuzile Hlongwane	phlongwane@ophid.co.zw	263770000894
22001	Rutendo Wesley Mukondwa	rmukondwa@ophid.co.zw	26377000022001
24025	Charmaine Enkrome Andrew	candrew@ophid.co.zw	26377000024025
25118	Karlos Madziva	kmadziva@ophid.co.zw	26377000025118
24020	Precious Fadzai Dzingira	pdzingira@ophid.co.zw	26377000024020
22130	Fiona Tapiwa Mundoga	fmundoga@ophid.co.zw	26377000022130
26001	Agnes Ngirazi	angirazi@ophid.co.zw	26377000026001
26002	Faith Kandiye	fkandiye@ophid.co.zw	26377000026002
26003	Morris Baradza	mbaradza@ophid.co.zw	26377000026003
26005	Vimbai Sigudhu	vsigudhu@ophid.co.zw	26377000026005
26006	Prisca Nyamapfeni	pnyamapfeni@ophid.co.zw	26377000026006
26007	Mutsa Motsi	mmotsi@ophid.co.zw	26377000026007
26008	Norest Chambion	nchambion@ophid.co.zw	26377000026008
26009	Sarudzayi Chingwende	schingwende@ophid.co.zw	26377000026009
26010	Tsitsidzashe Makuni	tmakuni@ophid.co.zw	26377000026010
26011	Wilson Kumalo	wkumalo@ophid.co.zw	26377000026011
13	Edmond Hatumwi	ehatumwi@ophid.co.zw	26377000013
109	Simon Zidana	szidana@ophid.co.zw	263770000109
136	Terance Nyirenda	tnyirenda@ophid.co.zw	263770000136
701	Blessing Murefu	bmurefu@ophid.co.zw	263770000701
911	Tafadzwa Mukamba	tmukamba@ophid.co.zw	263770000911
921	Needmore Betera	nbetera@ophid.co.zw	263770000921
969	Raymond Kodzwa	rkodzwa@ophid.co.zw	263770000969
21111	Marian Mbedzi	mmbedzi@ophid.co.zw	26377000021111
22040	Tafadzwa Makamure	tmakamure@ophid.co.zw	26377000022040
22134	Virginniah Munsaka	vmunsaka@ophid.co.zw	26377000022134
21120	Ellington Jack	ejack@ophid.co.zw	26377000021120
26013	Violet Bunganai	vbunganai@ophid.co.zw	26377000026013
26014	Stella Majuru	smajuru@ophid.co.zw	26377000026014
21045	Tinashe Ashley Mudotsa	tmudotsa@ophid.co.zw	26377000021045
22041	Chigaba Abisha	cabisha@ophid.co.zw	26377000022041
333793	Albert Masiya	amasiya@ophid.co.zw	263770000333793
333102	Albertina P Sibanda	asibanda@ophid.co.zw	263770000333102
333792	Alfheli Smutha	asmutha@ophid.co.zw	263770000333792
333872	Alice Shumba	alice.shumba@ophid.co.zw	263770000333872
333392	Andrew Siziba	asiziba@ophid.co.zw	263770000333392
333902	Angeline Shumba	angeline.shumba@ophid.co.zw	263770000333902
333802	Anitha Moyo	anitha.moyo@ophid.co.zw	263770000333802
333389	Asakheni Masuku	amasuku@ophid.co.zw	263770000333389
333769	Babusi Dube	babusi.dube@ophid.co.zw	263770000333769
333373	Beauty Moyo	beauty.moyo@ophid.co.zw	263770000333373
333804	Beauty Ndlovu	beauty.ndlovu@ophid.co.zw	263770000333804
333860	Bigboy Sibindi	bsibindi@ophid.co.zw	263770000333860
333370	Bornface Mpofu	bmpofu@ophid.co.zw	263770000333370
333083	Bridgeter Ndlovu	bridgeter.ndlovu@ophid.co.zw	263770000333083
334013	Brilliant Sithembiso Nkomo	bnkomo@ophid.co.zw	263770000334013
333752	Caroline Z Chapxanya	cchapxanya@ophid.co.zw	263770000333752
333339	Casper Masina	cmasina@ophid.co.zw	263770000333339
333816	Cathrine Siziba	csiziba@ophid.co.zw	263770000333816
334016	Chantell Siwela	csiwela@ophid.co.zw	263770000334016
333374	Charity Mhasvi	cmhasvi@ophid.co.zw	263770000333374
333617	Chipo Moyo	cmoyo@ophid.co.zw	263770000333617
333620	Chirume Ellar	cellar@ophid.co.zw	263770000333620
22157	Chiuya Tracy	ctracy@ophid.co.zw	26377000022157
333757	Christinah Tagwira	ctagwira@ophid.co.zw	263770000333757
333832	Clara Dube	clara.dube@ophid.co.zw	263770000333832
333416	Clarence Chikwane	cchikwane@ophid.co.zw	263770000333416
333020	Clerysia Chimwala	cchimwala@ophid.co.zw	263770000333020
333764	Constance Dlodlo	cdlodlo@ophid.co.zw	263770000333764
333917	Costen Ndlovu	costen.ndlovu@ophid.co.zw	263770000333917
333173	Diana Moyo	dmoyo@ophid.co.zw	263770000333173
333612	Dorothy Ngulube	dngulube@ophid.co.zw	263770000333612
22010	Dube Elizabeth	delizabeth@ophid.co.zw	26377000022010
333259	Dube Respect	drespect@ophid.co.zw	263770000333259
333086	Edith Banda	edith.banda@ophid.co.zw	263770000333086
333123	Edith Dickens	edickens@ophid.co.zw	263770000333123
333868	Edna Macheza	emacheza@ophid.co.zw	263770000333868
333811	Elizabeth E Marufu	emarufu@ophid.co.zw	263770000333811
333659	Ellen Nhambura	enhambura@ophid.co.zw	263770000333659
333382	Enara Nkala	enkala@ophid.co.zw	263770000333382
333660	Esnath Mulupa	emulupa@ophid.co.zw	263770000333660
333578	Eveline Mashayamombe	emashayamombe@ophid.co.zw	263770000333578
333567	Evernice Hongoro	ehongoro@ophid.co.zw	263770000333567
333794	Febbie Muleya	fmuleya@ophid.co.zw	263770000333794
333736	Florence Nxumalo	fnxumalo@ophid.co.zw	263770000333736
333315	Fortunate Ndlovu	fortunate.ndlovu@ophid.co.zw	263770000333315
333268	Future Thusi	fthusi@ophid.co.zw	263770000333268
333429	Getrude Ncube	gncube@ophid.co.zw	263770000333429
333756	Gladys Makiwa	gmakiwa@ophid.co.zw	263770000333756
333453	Godwill Dube	gdube@ophid.co.zw	263770000333453
333539	Goodwill Mafu	gmafu@ophid.co.zw	263770000333539
333939	Griffin Moyo	gmoyo@ophid.co.zw	263770000333939
333293	Gundani Tendai	gtendai@ophid.co.zw	263770000333293
333378	Happiness Dube	hdube@ophid.co.zw	263770000333378
333425	Hlalisekani Moyo	hmoyo@ophid.co.zw	263770000333425
333989	Hleziphi Ndebele	hndebele@ophid.co.zw	263770000333989
333729	Hlongwane Khumbulani	hkhumbulani@ophid.co.zw	263770000333729
333994	Ivy Mkhwananzi	imkhwananzi@ophid.co.zw	263770000333994
333141	Janet Mpofu	jmpofu@ophid.co.zw	263770000333141
333243	Jennifer Dube	jennifer.dube@ophid.co.zw	263770000333243
333305	Jew Maseko	jmaseko@ophid.co.zw	263770000333305
99000	JF KAPNEK	jkapnek@ophid.co.zw	26377000099000
333941	Josephine Sibanda	josephine.sibanda@ophid.co.zw	263770000333941
333565	Joyce Matika	jmatika@ophid.co.zw	263770000333565
333961	Julian Goreraza	jgoreraza@ophid.co.zw	263770000333961
333574	Juliet Jotamu	jjotamu@ophid.co.zw	263770000333574
333791	Kaoetso Tlou	ktlou@ophid.co.zw	263770000333791
333302	Kaunda Moyo	kaunda.moyo@ophid.co.zw	263770000333302
333257	Keabetsoi Siziba	ksiziba@ophid.co.zw	263770000333257
333272	Kelta Moyo	kelta.moyo@ophid.co.zw	263770000333272
333796	Ketsibile Mbedzi	ketsibile.mbedzi@ophid.co.zw	263770000333796
333721	Kevin Mbedzi	kevin.mbedzi@ophid.co.zw	263770000333721
333144	Khamukelo Mtlongwa	kmtlongwa@ophid.co.zw	263770000333144
893	Khumalo Phumulani	kphumulani@ophid.co.zw	263770000893
333292	Khuphe Pecinia	kpecinia@ophid.co.zw	263770000333292
333394	Konzaphi Dube	konzaphi.dube@ophid.co.zw	263770000333394
333012	Kusanele Moyo	kusanele.moyo@ophid.co.zw	263770000333012
333284	Langelihle Ncube	langelihle.ncube@ophid.co.zw	263770000333284
333441	Leonard Tshuma	ltshuma@ophid.co.zw	263770000333441
333304	Lethukuthula Dube	ldube@ophid.co.zw	263770000333304
334002	Limasi Patricia	lpatricia@ophid.co.zw	263770000334002
333953	Linda Ngerenge	lngerenge@ophid.co.zw	263770000333953
333753	Lindiwe Mahlangu	lmahlangu@ophid.co.zw	263770000333753
333449	Lindiwe Mpala	lmpala@ophid.co.zw	263770000333449
333987	Linet Mguni	lmguni@ophid.co.zw	263770000333987
333702	Linet Ndou	lndou@ophid.co.zw	263770000333702
333827	Lister Sibanda	lister.sibanda@ophid.co.zw	263770000333827
333889	Loreen Ncube	loreen.ncube@ophid.co.zw	263770000333889
333749	Lovemore Nleya	lnleya@ophid.co.zw	263770000333749
333004	Loveness Phuthi	lphuthi@ophid.co.zw	263770000333004
333786	Lucia Sibanda	lucia.sibanda@ophid.co.zw	263770000333786
333964	Lwazi Moyo	lwazi.moyo@ophid.co.zw	263770000333964
22077	Mabigana Kundai	mkundai@ophid.co.zw	26377000022077
333754	Maria Dube	maria.dube@ophid.co.zw	263770000333754
333985	Masline Marovanidze	mmarovanidze@ophid.co.zw	263770000333985
333957	Mavis Moyo	mavis.moyo@ophid.co.zw	263770000333957
333841	Maybe Ncube	mncube@ophid.co.zw	263770000333841
333876	Mbedzi Sohlula	msohlula@ophid.co.zw	263770000333876
333188	Mercy Wachi	mwachi@ophid.co.zw	263770000333188
333398	Mfanelo Nyathi	mnyathi@ophid.co.zw	263770000333398
333138	Midget Moyo	midget.moyo@ophid.co.zw	263770000333138
333627	Millicent Moyo	millicent.moyo@ophid.co.zw	263770000333627
333487	Mirriam Moyo	mirriam.moyo@ophid.co.zw	263770000333487
333448	Misele Dube	misele.dube@ophid.co.zw	263770000333448
333414	Mlamleli Moyo	mlamleli.moyo@ophid.co.zw	263770000333414
333253	Mojapelu Kulube	mkulube@ophid.co.zw	263770000333253
333450	Mosland Ezekiel Pagiwa	mpagiwa@ophid.co.zw	263770000333450
22051	Moyo Taurai	mtaurai@ophid.co.zw	26377000022051
596	Ncube Leopatra	nleopatra@ophid.co.zw	263770000596
333316	Ncube Never	nnever@ophid.co.zw	263770000333316
23044	Ndlovu Trynos	ntrynos@ophid.co.zw	26377000023044
333943	Netsai Mbedzi	nmbedzi@ophid.co.zw	263770000333943
333724	Ngambeni Nyathi	nnyathi@ophid.co.zw	263770000333724
333175	Ngqabutho Zulu	ngqabutho.zulu@ophid.co.zw	263770000333175
333892	Ngqobile Ngwenya	nngwenya@ophid.co.zw	263770000333892
22095	Ngwenya Chantel	nchantel@ophid.co.zw	26377000022095
992	Nhapi Tatenda	ntatenda@ophid.co.zw	263770000992
333411	Nhlanhla Sibanda	nhlanhla.sibanda@ophid.co.zw	263770000333411
333731	Nigel Makhalima	nmakhalima@ophid.co.zw	263770000333731
333935	Njabulo Sibanda	njabulo.sibanda@ophid.co.zw	263770000333935
333168	Nkosana Phiri	nphiri@ophid.co.zw	263770000333168
333137	Nocebo Moyo	nocebo.moyo@ophid.co.zw	263770000333137
334006	Nomusa Moyo	nomusa.moyo@ophid.co.zw	263770000334006
333766	Nonhlanhla Mpofu	nmpofu@ophid.co.zw	263770000333766
333968	Nonqabutho Moyo	nonqabutho.moyo@ophid.co.zw	263770000333968
333192	Nontokozo Hlomuka	nhlomuka@ophid.co.zw	263770000333192
333913	Ntombizodwa Jele	njele@ophid.co.zw	263770000333913
333948	Ntshabo Tlou	ntlou@ophid.co.zw	263770000333948
333682	Nyarai Mavhengere	nmavhengere@ophid.co.zw	263770000333682
333806	Otillia Ndlovu	ondlovu@ophid.co.zw	263770000333806
333003	Pamela Zulu	pzulu@ophid.co.zw	263770000333003
333895	Phatisiwe Mpofu	phatisiwe.mpofu@ophid.co.zw	263770000333895
333442	Pheleza Maseko	pmaseko@ophid.co.zw	263770000333442
333247	Portia Ndlovu	portia.ndlovu@ophid.co.zw	263770000333247
333438	Priscilla Ncube	priscilla.ncube@ophid.co.zw	263770000333438
333649	Priscilla Sibanda	psibanda@ophid.co.zw	263770000333649
333936	Qhubani Zhirazhira	qzhirazhira@ophid.co.zw	263770000333936
333366	Ramwidzai Vurangu	rvurangu@ophid.co.zw	263770000333366
333750	Ranganai Chikowore	rchikowore@ophid.co.zw	263770000333750
333662	Rebecca Ncube	rncube@ophid.co.zw	263770000333662
333992	Rodrick Winesi	rwinesi@ophid.co.zw	263770000333992
333864	Ronald Nkomo	rnkomo@ophid.co.zw	263770000333864
333746	Rosemary Moffat	rmoffat@ophid.co.zw	263770000333746
333684	Rosita Mthunzi	rmthunzi@ophid.co.zw	263770000333684
333310	Samson Moyo	samson.moyo@ophid.co.zw	263770000333310
333568	Samukele Tawana	stawana@ophid.co.zw	263770000333568
333743	Samukelisiwe Nyathi	samukelisiwe.nyathi@ophid.co.zw	263770000333743
333417	Samukeliso Nkomo	samukeliso.nkomo@ophid.co.zw	263770000333417
333693	Sazini Nkomo	sazini.nkomo@ophid.co.zw	263770000333693
333415	Senzele Ndlovu	senzele.ndlovu@ophid.co.zw	263770000333415
333771	Senzeni Mpala	senzeni.mpala@ophid.co.zw	263770000333771
333451	Sethi Nyathi	sethi.nyathi@ophid.co.zw	263770000333451
333278	Sethukile Khumalo	sethukile.khumalo@ophid.co.zw	263770000333278
333858	Shiela Nyathi	shiela.nyathi@ophid.co.zw	263770000333858
333734	Sibahle Moyo	sibahle.moyo@ophid.co.zw	263770000333734
21016	Sibanda Lourine	slourine@ophid.co.zw	26377000021016
333562	Sibanda Sibonginkosi	ssibonginkosi@ophid.co.zw	263770000333562
333556	Sibanda Sithobekile	ssithobekile@ophid.co.zw	263770000333556
333814	Siboneni Shava	sshava@ophid.co.zw	263770000333814
333404	Sibongile Mdlongwa	smdlongwa@ophid.co.zw	263770000333404
333988	Sibongile Nkosi	snkosi@ophid.co.zw	263770000333988
333563	Sibonile Maphosa	smaphosa@ophid.co.zw	263770000333563
333439	Sibonokuhle Ndlovu	sibonokuhle.ndlovu@ophid.co.zw	263770000333439
333263	Sibusisiwe Sibanda	sibusisiwe.sibanda@ophid.co.zw	263770000333263
333264	Sichelesile Sibanda	sichelesile.sibanda@ophid.co.zw	263770000333264
333833	Sifiso Sebele	ssebele@ophid.co.zw	263770000333833
333372	Sifungeleni Timile	stimile@ophid.co.zw	263770000333372
333532	Sihle Dube	sihle.dube@ophid.co.zw	263770000333532
333283	Sikhangele Ncube	sikhangele.ncube@ophid.co.zw	263770000333283
333176	Sikhathaziwe Ncube	sikhathaziwe.ncube@ophid.co.zw	263770000333176
333931	Sikhululiwe Sibanda	sikhululiwe.sibanda@ophid.co.zw	263770000333931
333205	Siphephile Mlangeni	smlangeni@ophid.co.zw	263770000333205
334014	Siphilisiwe Chiwota	schiwota@ophid.co.zw	263770000334014
333608	Sipho Cala	scala@ophid.co.zw	263770000333608
333467	Sipho Sibanda	sipho.sibanda@ophid.co.zw	263770000333467
333363	Sitembiso Mvundhla	smvundhla@ophid.co.zw	263770000333363
333971	Sithabisiwe Ndlovu	sithabisiwe.ndlovu@ophid.co.zw	263770000333971
333571	Sithandazile Moyo	sithandazile.moyo@ophid.co.zw	263770000333571
333267	Sithandweyinkosi Ncube	sithandweyinkosi.ncube@ophid.co.zw	263770000333267
333424	Sithembiso Nungu	snungu@ophid.co.zw	263770000333424
333812	Sithokozile Dube	sithokozile.dube@ophid.co.zw	263770000333812
333525	Sitshengisiwe Sibanda	sitshengisiwe.sibanda@ophid.co.zw	263770000333525
333481	Siwinile Phiri	siwinile.phiri@ophid.co.zw	263770000333481
333730	Sonele Hlongwane	shlongwane@ophid.co.zw	263770000333730
333867	Stanley Phiri	stanley.phiri@ophid.co.zw	263770000333867
333759	Sukoluhle Ndimande	sndimande@ophid.co.zw	263770000333759
333418	Sukoluhle Ndlovu	sukoluhle.ndlovu@ophid.co.zw	263770000333418
22060	Tafadzwa Mukotekwa	tmukotekwa@ophid.co.zw	26377000022060
333748	Talente Mdhlongwa	tmdhlongwa@ophid.co.zw	263770000333748
333933	Tendai Khupe	tkhupe@ophid.co.zw	263770000333933
23076	Emmaculate Hlungwani	ehlungwani@ophid.co.zw	26377000023076
23003	Mthandazo Mpofu	mmpofu@ophid.co.zw	26377000023003
22137	Zibusiso Kanye	zkanye@ophid.co.zw	26377000022137
22098	Nomvelo Thandiwe Zaranyika	nzaranyika@ophid.co.zw	26377000022098
333286	Thalita Mavala Dube	tdube@ophid.co.zw	263770000333286
333546	Thandiwe Mkhwananzi	tmkhwananzi@ophid.co.zw	263770000333546
333432	Thembekile Mthuthuki	tmthuthuki@ophid.co.zw	263770000333432
334009	Tholiwe Mavenga	tmavenga@ophid.co.zw	263770000334009
333704	Thonie Ndou	tndou@ophid.co.zw	263770000333704
333990	Thubelihle Moyo	thubelihle.moyo@ophid.co.zw	263770000333990
333544	Thulani Ncube	thulani.ncube@ophid.co.zw	263770000333544
895	Shyllet Ndlela	sndlela@ophid.co.zw	263770000895
489	Bukhosi Ncube	bncube@ophid.co.zw	263770000489
333491	Thulisile Ngwenya	thulisile.ngwenya@ophid.co.zw	263770000333491
333395	Thuma Phiri	tphiri@ophid.co.zw	263770000333395
333463	Trecy Sibanda	tsibanda@ophid.co.zw	263770000333463
333266	Tshandapiwa Moyo	tshandapiwa.moyo@ophid.co.zw	263770000333266
333993	Violet Moyo	vmoyo@ophid.co.zw	263770000333993
333886	Washington Banda	wbanda@ophid.co.zw	263770000333886
333986	Zanele Nyathi	znyathi@ophid.co.zw	263770000333986
333437	Zelifa Dube	zelifa.dube@ophid.co.zw	263770000333437
990001	ZNNP+	znnp@ophid.co.zw	263770000990001
98	Deborrah Musarurwa	dmusarurwa@ophid.co.zw	26377000098
83	Ngonidzashe Manika	nmanika@ophid.co.zw	26377000083
81	Anesu Chimwaza	achimwaza@ophid.co.zw	26377000081
1	System Super Access	admin	+260970000001
\.


--
-- TOC entry 3835 (class 0 OID 466592)
-- Dependencies: 245
-- Data for Name: staff_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_roles (id, staff_profile_id, role_type_id, role_station_id) FROM stdin;
1	1	10	1
2	1	20	1
3	1	30	1
4	1	40	1
5	1	50	1
6	1	60	1
7	1	70	1
8	1	80	1
9	2	40	1
11	4	10	1
12	3	20	59
13	5	20	10
15	5	10	1
16	2	10	3
17	7	10	1
18	59	10	1
19	135	10	38
20	264	10	62
21	528	10	39
22	639	10	1
23	683	10	10
24	696	10	1093
25	896	10	108
26	898	10	148
27	899	10	62
28	983	10	166
29	21014	10	129
30	21015	10	11
31	21046	10	39
32	21102	10	38
33	23068	10	166
34	23071	10	1
35	25109	10	1
36	25110	10	1
37	132	10	1
38	591	10	1
39	251111	10	1
40	2114310	10	1
41	482	10	11
42	636	10	1093
43	642	10	1093
44	692	10	11
45	694	10	1093
46	698	10	11
47	707	10	11
48	870	10	129
49	875	10	11
50	922	10	1093
51	923	10	1093
52	927	10	129
53	932	10	39
54	939	10	86
55	946	10	39
56	948	10	108
57	952	10	1093
58	954	10	1093
59	958	10	166
60	963	10	166
61	966	10	62
62	967	10	62
63	968	10	62
64	975	10	11
65	976	10	11
66	977	10	11
67	981	10	11
68	986	10	148
69	21022	10	129
70	21026	10	11
71	21030	10	11
72	21032	10	11
73	21033	10	11
74	21034	10	11
75	21039	10	1093
76	21041	10	10
77	21049	10	62
78	21051	10	62
79	21054	10	62
80	21055	10	148
81	21058	10	11
82	21063	10	86
83	21064	10	129
84	21065	10	86
85	21066	10	166
86	21067	10	11
87	21068	10	108
88	21069	10	86
89	21071	10	108
90	21072	10	108
91	21079	10	86
92	21084	10	11
93	21089	10	108
94	21090	10	108
95	21091	10	108
96	21092	10	166
97	21095	10	166
98	21099	10	62
99	21103	10	148
100	21110	10	62
101	21112	10	62
102	21114	10	148
103	22006	10	1093
104	22007	10	1093
105	22009	10	11
106	22038	10	62
107	22052	10	39
108	22068	10	166
109	22071	10	11
110	22079	10	108
111	22081	10	86
112	22096	10	11
113	22106	10	11
114	22107	10	86
115	22109	10	11
116	22110	10	11
117	22115	10	11
118	22116	10	11
119	22117	10	108
120	22123	10	148
121	22131	10	129
122	22132	10	11
123	22135	10	11
124	22138	10	148
125	22141	10	86
126	22142	10	39
127	23004	10	129
128	23008	10	39
129	23012	10	1093
130	23013	10	39
131	23014	10	108
132	23015	10	86
133	23017	10	166
134	23019	10	39
135	23020	10	39
136	23024	10	129
137	23025	10	86
138	23035	10	11
139	23036	10	129
140	23039	10	129
141	23041	10	148
142	23045	10	39
143	23062	10	39
144	23064	10	86
145	23065	10	166
146	23077	10	11
147	23083	10	11
148	23084	10	11
149	24001	10	62
150	24004	10	39
151	24014	10	39
152	24017	10	166
153	24018	10	166
154	25003	10	166
155	25004	10	166
156	25005	10	166
157	25006	10	166
158	25008	10	166
159	25009	10	166
160	25010	10	166
161	25011	10	108
162	25012	10	108
163	25013	10	108
164	25014	10	108
165	25018	10	108
166	25019	10	108
167	25020	10	108
168	25021	10	86
169	25022	10	86
170	25023	10	86
171	25024	10	86
172	25025	10	86
173	25027	10	129
174	25028	10	129
175	25030	10	129
176	25031	10	129
177	25033	10	11
178	25034	10	11
179	25035	10	11
180	25036	10	11
181	25037	10	11
182	25038	10	11
183	25039	10	11
184	25040	10	11
185	25041	10	11
186	25042	10	11
187	25045	10	11
188	25046	10	11
189	25047	10	11
190	25048	10	11
191	25049	10	11
192	25050	10	11
193	25051	10	11
194	25052	10	11
195	25053	10	11
196	25054	10	11
197	25055	10	11
198	25056	10	11
199	25057	10	11
200	25058	10	11
201	25060	10	1093
202	25061	10	1093
203	25062	10	1093
204	25063	10	1093
205	25066	10	1093
206	25067	10	1093
207	25068	10	1093
208	25069	10	1093
209	25070	10	62
210	25073	10	62
211	25075	10	62
212	25076	10	62
213	25077	10	62
214	25078	10	62
215	25079	10	62
216	25080	10	62
217	25081	10	62
218	25082	10	62
219	25083	10	39
220	25084	10	39
221	25085	10	39
222	25086	10	39
223	25087	10	39
224	25088	10	39
225	25089	10	39
226	25090	10	39
227	25091	10	39
228	25092	10	39
229	25093	10	39
230	25094	10	39
231	25095	10	62
232	25096	10	62
233	25097	10	62
234	25098	10	62
235	25099	10	62
236	25102	10	148
237	25103	10	148
238	25104	10	148
239	25107	10	148
240	25108	10	148
241	25112	10	62
242	25113	10	62
243	25115	10	108
244	25116	10	11
245	25117	10	62
246	25119	10	1093
247	25120	10	62
248	25121	10	148
249	853	10	1
250	854	10	1
251	144	10	38
252	45	10	1
253	69	10	1
254	70	10	1
255	76	10	1
256	195	10	11
257	560	10	1
258	593	10	1
259	607	10	1
260	676	10	1
261	855	10	1
262	868	10	1
263	877	10	1
264	882	10	1
265	884	10	1
266	891	10	1
267	901	10	1
268	914	10	1
269	920	10	38
270	945	10	1
271	970	10	38
272	21006	10	1
273	21020	10	1
274	21040	10	1093
275	21116	10	1
276	22094	10	1
277	22144	10	10
278	22146	10	1
279	25002	10	1
280	598	10	1
281	894	10	1
282	22001	10	1
283	24025	10	1
284	25118	10	1
285	24020	10	1
286	22130	10	1
287	26001	10	1
288	26002	10	1
289	26003	10	1
290	26005	10	1
291	26006	10	1
292	26007	10	1
293	26008	10	1
294	26009	10	1
295	26010	10	1
296	26011	10	1
297	13	10	1
298	109	10	779
299	136	10	39
300	701	10	166
301	911	10	1056
302	921	10	712
303	969	10	712
304	21111	10	39
305	22040	10	166
306	22134	10	779
307	21120	10	984
308	26013	10	1056
309	26014	10	984
310	21045	10	196
311	22041	10	345
312	333793	10	29
313	333102	10	506
314	333792	10	29
315	333872	10	29
316	333392	10	567
317	333902	10	567
318	333802	10	345
319	333389	10	567
320	333769	10	59
321	333373	10	506
322	333804	10	345
323	333860	10	393
324	333370	10	567
325	333083	10	393
326	334013	10	59
327	333752	10	59
328	333339	10	345
329	333816	10	393
330	334016	10	59
331	333374	10	345
332	333617	10	29
333	333620	10	29
334	22157	10	345
335	333757	10	59
336	333832	10	506
337	333416	10	506
338	333020	10	196
339	333764	10	59
340	333917	10	567
341	333173	10	1034
342	333612	10	1034
343	22010	10	59
344	333259	10	345
345	333086	10	1034
346	333123	10	393
347	333868	10	59
348	333811	10	345
349	333659	10	196
350	333382	10	345
351	333660	10	196
352	333578	10	196
353	333567	10	196
354	333794	10	29
355	333736	10	59
356	333315	10	345
357	333268	10	61
358	333429	10	59
359	333756	10	59
360	333453	10	345
361	333539	10	393
362	333939	10	29
363	333293	10	61
364	333378	10	567
365	333425	10	345
366	333989	10	506
367	333729	10	59
368	333994	10	393
369	333141	10	393
370	333243	10	506
371	333305	10	61
372	99000	10	363
373	333941	10	29
374	333565	10	196
375	333961	10	506
376	333574	10	196
377	333791	10	29
378	333302	10	567
379	333257	10	345
380	333272	10	567
381	333796	10	29
382	333721	10	29
383	333144	10	393
384	893	10	59
385	333292	10	61
386	333394	10	345
387	333012	10	506
388	333284	10	61
389	333441	10	61
390	333304	10	567
391	334002	10	59
392	333953	10	196
393	333753	10	59
394	333449	10	506
395	333987	10	1034
396	333702	10	29
397	333827	10	393
398	333889	10	567
399	333749	10	59
400	333004	10	567
401	333786	10	29
402	333964	10	506
403	22077	10	1034
404	333754	10	59
405	333985	10	29
406	333957	10	506
407	333841	10	59
408	333876	10	29
409	333188	10	196
410	333398	10	345
411	333138	10	1034
412	333627	10	29
413	333487	10	1034
414	333448	10	506
415	333414	10	345
416	333253	10	345
417	333450	10	61
418	22051	10	567
419	596	10	506
420	333316	10	61
421	23044	10	506
422	333943	10	29
423	333724	10	29
424	333175	10	1034
425	333892	10	345
426	22095	10	61
427	992	10	554
428	333411	10	345
429	333731	10	59
430	333935	10	393
431	333168	10	393
432	333137	10	1034
433	334006	10	393
434	333766	10	59
435	333968	10	345
436	333192	10	345
437	333913	10	1034
438	333948	10	29
439	333682	10	29
440	333806	10	345
441	333003	10	567
442	333895	10	345
443	333442	10	61
444	333247	10	506
445	333438	10	59
446	333649	10	29
447	333936	10	1034
448	333366	10	61
449	333750	10	59
450	333662	10	506
451	333992	10	196
452	333864	10	393
453	333746	10	59
454	333684	10	29
455	333310	10	61
456	333568	10	196
457	333743	10	59
458	333417	10	506
459	333693	10	506
460	333415	10	567
461	333771	10	59
462	333451	10	61
463	333278	10	345
464	333858	10	506
465	333734	10	59
466	21016	10	1034
467	333562	10	567
468	333556	10	567
469	333814	10	59
470	333404	10	345
471	333988	10	506
472	333563	10	393
473	333439	10	61
474	333263	10	393
475	333264	10	59
476	333833	10	506
477	333372	10	345
478	333532	10	393
479	333283	10	61
480	333176	10	1034
481	333931	10	393
482	333205	10	345
483	334014	10	59
484	333608	10	1034
485	333467	10	345
486	333363	10	61
487	333971	10	345
488	333571	10	1034
489	333267	10	567
490	333424	10	393
491	333812	10	345
492	333525	10	393
493	333481	10	1034
494	333730	10	59
495	333867	10	393
496	333759	10	59
497	333418	10	567
498	22060	10	29
499	333748	10	59
500	333933	10	506
501	23076	10	567
502	23003	10	61
503	22137	10	506
504	22098	10	567
505	333286	10	61
506	333546	10	393
507	333432	10	61
508	334009	10	393
509	333704	10	29
510	333990	10	506
511	333544	10	393
512	895	10	345
513	489	10	61
514	333491	10	1034
515	333395	10	567
516	333463	10	345
517	333266	10	61
518	333993	10	393
519	333886	10	567
520	333986	10	567
521	333437	10	61
522	990001	10	363
523	98	10	1
524	83	10	1
525	81	10	1
526	22146	50	1
527	22146	70	1
\.


--
-- TOC entry 3826 (class 0 OID 466516)
-- Dependencies: 236
-- Data for Name: stations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stations (id, station_code, station_name, latitude, longitude, level) FROM stdin;
1	/Z9zOAr1dQ8K	Central Office	\N	\N	1
2	/Z9zOAr1dQ8K/AP0oByfeNOO	Mashonaland East	\N	\N	2
3	/Z9zOAr1dQ8K/AP0oByfeNOO/A1qfbn7GkEj	Chikomba 	\N	\N	3
4	/Z9zOAr1dQ8K/AP0oByfeNOO/A1qfbn7GkEj/GVp3L9G62Gc	Gokomere Clinic	\N	\N	4
5	/Z9zOAr1dQ8K/AP0oByfeNOO/At0CT70yl34	Hwedza 	\N	\N	3
6	/Z9zOAr1dQ8K/AP0oByfeNOO/At0CT70yl34/mbDBz6MSz7W	Mt. St Marys Mission Hospital	\N	\N	4
7	/Z9zOAr1dQ8K/dqA5ZJs7S5m	Mashonaland West	\N	\N	2
8	/Z9zOAr1dQ8K/dqA5ZJs7S5m/EdrwoNn5vSY	Hurungwe 	\N	\N	3
9	/Z9zOAr1dQ8K/dqA5ZJs7S5m/EdrwoNn5vSY/OLRUUHnqxid	Wellness Centre Road Site Clinic	\N	\N	4
11	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT	Bulawayo	\N	\N	3
12	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/AQUWX00pVHC	Cowdray Park Clinic	\N	\N	4
13	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/AU3HqiX44Iu	Tshabalala Clinic	\N	\N	4
14	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/BNmgLUTqvi9	United Bulawayo Hospital Central Hospital	\N	\N	4
15	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/bTFUZdQpl2O	Pumula Clinic	\N	\N	4
16	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/cIHo19pHPnw	Emakhandeni Clinic	\N	\N	4
17	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/en6HLtwW3sN	Northern Suburbs Clinic	\N	\N	4
18	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/ETnCTKuzUNg	Emganwini Clinic	\N	\N	4
19	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/FEdl2EBiTBV	Magwegwe Clinic	\N	\N	4
20	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/GLh9L9T8kCh	Mahatshula Clinic	\N	\N	4
21	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/gpJEjabIuP7	Nketa Clinic	\N	\N	4
22	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/gs4v5i69tux	Dr. Shennan Clinic	\N	\N	4
23	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/HTOW8SwHLtO	Khami Clinic	\N	\N	4
24	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/ikrpWZKIaxV	Maqhawe Clinic	\N	\N	4
25	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/jYoTBp4PIJa	Ingutsheni Central Hospital	\N	\N	4
26	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/jYoTBp4PIJa/CMfdOI3UAkF	CRFIngutsheni  Hospital	\N	\N	5
27	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/KIAW84qSifO	Entumbane Clinic	\N	\N	4
28	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/l3sa1esKB5N	Cowdry Park Health Centre	\N	\N	4
29	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/LzPod6UX2mA	Mzilikazi Clinic	\N	\N	4
30	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/OnysnioygHR	Pelandaba Clinic	\N	\N	4
31	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/oZk9I1XeSu9	E.F. Watson Clinic	\N	\N	4
32	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/Sss3M30PqRD	Luveve Clinic	\N	\N	4
33	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/sTQ6BFy94pp	Princess Margaret Clinic	\N	\N	4
34	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/Sv1eXLkWUya	Nkulumane Clinic	\N	\N	4
35	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/UCKxgQFp862	Njube Clinic	\N	\N	4
36	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/UNvppQDgoqJ	Mpilo Central Hospital	\N	\N	4
37	/Z9zOAr1dQ8K/gLRkKaY6yuS/DlE6bBnEvJT/zhkFyAbgMc2	Pumula South Clinic	\N	\N	4
38	/Z9zOAr1dQ8K/kUS61oPWPF9	Matabeleland South	\N	\N	2
39	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3	Beitbridge	\N	\N	3
40	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/cLOvKUEH5RN	Dulibadzimu Clinic	\N	\N	4
41	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/EOeDi6taCLr	Beitbridge District Hospital	\N	\N	4
42	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/FHW8J9cVHxt	Tongwe Clinic	\N	\N	4
43	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/G6nmGfnklSb	Dite Rural Health Centre	\N	\N	4
44	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/HLtonOYJwWn	Majini Rural Health Centre	\N	\N	4
45	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/JLZubuHTJDP	Chikwarakwara Rural Health Centre	\N	\N	4
46	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/mzisptcnWiW	Chasvingo Clinic	\N	\N	4
47	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/NAmW5KR5wQx	Masera Clinic	\N	\N	4
48	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/OAq1i8fDht3	Makombe Clinic 	\N	\N	4
49	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/oDmbYIOSipy	Makakabule Rural Health Centre	\N	\N	4
50	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/OF8acIjcyKQ	Chamunangana Clinic	\N	\N	4
51	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/ooCbPaLKfGV	Mtetengwe Clinic	\N	\N	4
52	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/pNbIgW9kn5C	Chituripasi Rural Health Centre	\N	\N	4
53	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/qusMEMLJjQi	Tshabili clinic	\N	\N	4
54	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/RHrm9PxyBYg	Malabe Health Post	\N	\N	4
55	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/rpej7yiXTfc	Beitbridge Wellness Clinic Private Clinic	\N	\N	4
56	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/RvZ2KNZoPql	Shabwe Rural Health Centre	\N	\N	4
57	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/T9MjXsATFab	Zezane Clinic	\N	\N	4
58	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/tPS02lV0yjF	Swereki Clinic	\N	\N	4
60	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/xg2duO1UjSL	Shashe Clinic	\N	\N	4
61	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/Z7Wzn53893G	Nottingham Rural Health Centre	\N	\N	4
62	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr	Gwanda	\N	\N	3
63	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/A4cvoTFnkVd	Sitezi clinic	\N	\N	4
64	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/B7i3EGdTPnj	Buvuma Clinic	\N	\N	4
65	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/bB4csCSIDEn	Garanyemba Clinic	\N	\N	4
66	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/CPy6XjJD08i	Nhwali Rural Health Centre	\N	\N	4
67	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/cUPFcuov2Fc	West Nicolson Clinic	\N	\N	4
68	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/fqYJ8EfOnTe	Manama Mission Hospital	\N	\N	4
69	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/IVZFwtiwLgU	Mtshabezi Mission Hospital	\N	\N	4
70	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/KlVFxBUmMPa	Gungwe Rural Health Centre	\N	\N	4
71	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/KOtS4LirnJo	Mzimuni Clinic	\N	\N	4
72	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/lq1a53Zl3Gn	Silkwe Rural Health centre	\N	\N	4
73	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/Lv590WIYBnO	Simbumbumbu Rural Health Centre	\N	\N	4
74	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/M2LcdnNLboq	Mapate Cliniclinic	\N	\N	4
75	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/MfChw9iO4MQ	Makwe Rural Health Centre	\N	\N	4
76	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/mm2j4nL6ha9	Ntalale Clinic	\N	\N	4
10	/Z9zOAr1dQ8K/gLRkKaY6yuS	Bulawayo Provincial Office	\N	\N	2
77	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/mQbanvNia3z	Selonga Rural Health Centre	\N	\N	4
78	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/N26tcya5qNw	Kafusi Clinic	\N	\N	4
79	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/nWY5DVISxvp	Lushongwe Clinic	\N	\N	4
80	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/OAYfFKYAty5	Stanmore Clinic	\N	\N	4
81	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/PvpAI8GMs3i	Mandihongola RHC	\N	\N	4
82	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/Sq0OXYtsjYO	Sengwezani Rural Health Centre	\N	\N	4
83	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/XssBk2TpOIJ	Mashaba Clinic	\N	\N	4
84	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/zrlHTputbK4	Pakama Clinic	\N	\N	4
85	/Z9zOAr1dQ8K/kUS61oPWPF9/LHy36wzzZSr/zxAtMDQ2Qqc	Gwanda Provincial Hospital	\N	\N	4
86	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ	Bulilima	\N	\N	3
87	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/D79NwzzVJYp	Dombodema Clinic	\N	\N	4
88	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/dSsH9yE0duM	Village 13 Rural Health Centre	\N	\N	4
89	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/fQFZqhixGvs	Gambu Clinic	\N	\N	4
90	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/hNWAEAb2Nhd	Nyabane Clinic	\N	\N	4
91	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/KYBy3FfZcPu	Bezu Clinic	\N	\N	4
92	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/L0BhteRCV93	Solusi Clinic	\N	\N	4
93	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/mb8xNkQoiuv	Sikhatini Clinic	\N	\N	4
94	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/mCKQlE4o0Yr	Ndiweni Clinic	\N	\N	4
95	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/mJIpxNdl2QY	Madlambuzi Clinic	\N	\N	4
96	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/O4kX8ajY1Lp	Tokwana Clinic	\N	\N	4
97	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/ofDSu93XYEs	Matjinge Rural Health Centre	\N	\N	4
98	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/Orr1ircj1n9	Lady Stanley Mission Hospital	\N	\N	4
99	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/pAUXg8FfZlS	Hingwe Clinic	\N	\N	4
100	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/QPHAMe5GEWA	Makhuleka Clinic	\N	\N	4
101	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/r3OGNRrJ82z	Nswazwi Rural Health Centre	\N	\N	4
102	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/rkQa7RnEWDS	Huwana Clinic	\N	\N	4
103	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/sqWVRgo6BjX	Malalume RHC	\N	\N	4
104	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/twOU9Qka6Hm	Masendu Clinic	\N	\N	4
105	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/txZAALJZy6S	Temateme Clinic	\N	\N	4
106	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/XdWdQRJn9Py	Lady Barring Mission Hospital	\N	\N	4
107	/Z9zOAr1dQ8K/kUS61oPWPF9/nUBLdaaGcbJ/y98J2AtbZsT	Mbimba Clinic	\N	\N	4
108	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG	Matobo	\N	\N	3
109	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/B5YF4fUJEVU	Bazha Clinic	\N	\N	4
110	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/BT9ERqzG21A	Natisa Rural Health Centre	\N	\N	4
111	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/f3mLKel2gIx	Matobo Rural Rural Hospital	\N	\N	4
112	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/FDm9hBNYb99	Kezi Rural Hospital	\N	\N	4
113	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/gri4bmtWbqG	Matobo Mission Clinic	\N	\N	4
114	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/gygPTU6Jrgx	Mlugulu Clinic	\N	\N	4
115	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/jxSgfvRa1kd	Cyrene Mission Clinic	\N	\N	4
116	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/kEC31WjP2wR	Gulati Rural Health Centre	\N	\N	4
117	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/khHSytZaECG	Sankonjana Rural Health Centre	\N	\N	4
118	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/lXWXq7pvXNr	Mbembeswana Rural Health Centre	\N	\N	4
119	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/mgxlglCseF4	Masiye Camp Clinic	\N	\N	4
120	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/pE7JIVQTAax	Silozwi Clinic	\N	\N	4
121	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/pzIEDyvh4SS	Ndabankulu Clinic	\N	\N	4
122	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/QBWN4VDaKc9	Fumugwe Clinic	\N	\N	4
123	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/qwnyqPsOoCT	Maphisa District Hospital	\N	\N	4
124	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/RsSbNZR2lnR	Ekukanyeni Clinic	\N	\N	4
125	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/TBrKYpmE8ys	Beula Rural Health Centre	\N	\N	4
126	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/wa7S2vIGgVg	Tshelanyemba Mission Hospital	\N	\N	4
127	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/XVUGfE4rVxG	St. Josephs Rural Hospital	\N	\N	4
128	/Z9zOAr1dQ8K/kUS61oPWPF9/pKhWt8ZkncG/Zjgwzp0iPau	Homestead Rural Health Centre	\N	\N	4
129	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn	Mangwe	\N	\N	3
130	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/AxbWlACKfun	Maninji Clinic	\N	\N	4
131	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/Bk03KuutZss	SANZUKWI Clinic	\N	\N	4
132	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/CoCGCYaDyfm	Mambale Clinic	\N	\N	4
133	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/csZvGNTFp2K	Embakwe Mission Hospital	\N	\N	4
134	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/FjN22JqEC4D	Tshitshi Clinic	\N	\N	4
135	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/HWtwaa3MidK	St. Annes Brunapeg Mission Hospital	\N	\N	4
136	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/HYNPD4P3JyV	Marula Clinic	\N	\N	4
137	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/ImEOeEnBhCe	Ingwizi Clinic	\N	\N	4
138	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/JOr33aW1Qul	Empandeni Clinic	\N	\N	4
139	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/jPcuTzdshv2	Madabe Clinic	\N	\N	4
140	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/m3xf7bSFUsi	Izimnyama Clinic	\N	\N	4
141	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/qKa0cqfK6cB	Macingwana RHC	\N	\N	4
142	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/RFTwaeEoUqu	Plumtree District Hospital	\N	\N	4
143	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/RJnzhQ3jWs2	Mayobodo Rural Health Centre	\N	\N	4
144	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/ut7vZn6zqdQ	Nguwanyana	\N	\N	4
145	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/vccaicHoiyB	Plumtree Border Post Clinic	\N	\N	4
146	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/vNLrnKgUtPc	Bango Clinic	\N	\N	4
147	/Z9zOAr1dQ8K/kUS61oPWPF9/tYiMfzPnISn/YaLsThHfLT9	Dingumuzi Clinic	\N	\N	4
148	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz	Umzingwane	\N	\N	3
149	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/B9HL312kFTS	Dula Clinic	\N	\N	4
150	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/BryKgdfmnnU	Mawabeni Clinic	\N	\N	4
151	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/cMnfYLDG3wb	Zimbili Clinic	\N	\N	4
152	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/DD4GJqpcTRS	Nswazi Clinic	\N	\N	4
153	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/e4A1s0LVXW8	How Mine Mine Clinic	\N	\N	4
154	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/EJIkhGYlQVb	Esigodini District Hospital	\N	\N	4
155	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/JfjyEPK4x5b	Mhlahlandlela Clinic	\N	\N	4
156	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/JHAlEGeE4Cl	Irisvale Rural Health Centre	\N	\N	4
157	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/MJItwbZps26	Habani Clinic	\N	\N	4
158	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/NYyR0XgxhQr	Umzingwane Clinic	\N	\N	4
159	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/QF8O7qAp5NJ	Mpisini Clinic	\N	\N	4
160	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/RbPl86Ek1pJ	Kumbuzi Rural Health Centre	\N	\N	4
161	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/SjvPWQ5l2gT	Esibobvu Clinic	\N	\N	4
162	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/tN6rOnRMwmB	Nhlangano Clinic	\N	\N	4
163	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/WRQDsk1fI1Z	Mbizingwe Rural Health Centre	\N	\N	4
164	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/xKCmMnOpkq8	Ntshamathe Clinic	\N	\N	4
165	/Z9zOAr1dQ8K/kUS61oPWPF9/tzUGOJR9KMz/ZskGFI5lTex	Shale Clinic	\N	\N	4
166	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr	Insiza	\N	\N	3
167	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/Adc2S4HRzAf	Sanale Rural Health Centre	\N	\N	4
168	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/b3PU8AeeaQC	Wanezi Rural Hospital	\N	\N	4
169	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/Ct34hgdcaQf	Kombo Clinic	\N	\N	4
170	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/dopFToosDbC	Montrose 7 Clinic 	\N	\N	4
171	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/ec12kvcjS7E	Singwambizi Clinic	\N	\N	4
172	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/gu6QjBK15Rz	Nkankezi Rural Health Centre	\N	\N	4
173	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/IzjQ0ClMwFr	Mbondo Clinic	\N	\N	4
174	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/krUJBXgxsij	Zhulube Clinic	\N	\N	4
175	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/LAGfgfyUDwT	Nyamime Rural Health Centre	\N	\N	4
176	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/nTq5H4A7Lyc	Filabusi District Hospital	\N	\N	4
177	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/ohXsGJeKhB4	Shangani Mine Clinic	\N	\N	4
178	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/qmtMQzRoH0H	Avoca Rural Hospital	\N	\N	4
179	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/Qx7IPzhtG69	GSU Clinic	\N	\N	4
180	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/WX4iuiyQmwV	Amazon Clinic	\N	\N	4
181	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/wzZvw0u6fe2	Saphila Council Clinic	\N	\N	4
182	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/xGshYPXKdF6	Shangani Rural Hospital	\N	\N	4
183	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/y6M9rtUuWa9	Gwatemba Rural Health Centre	\N	\N	4
184	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/YAoTF1MIrjU	Singwango Clinic	\N	\N	4
185	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/ZaWOfFs5CGk	Insiza PBS Clinic	\N	\N	4
186	/Z9zOAr1dQ8K/kUS61oPWPF9/Umg8MchY5Yr/ZzNvcMVOVP3	Mabuze Rural Health Centre	\N	\N	4
187	/Z9zOAr1dQ8K/MVEckxDrWZS	Midlands	\N	\N	2
188	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs	Kwekwe	\N	\N	3
189	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/A2VmYuwHVAw	Malisa Josefa Clinic	\N	\N	4
190	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/A4XNUkiCCCp	Jackson Clinic	\N	\N	4
191	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/ANNzC8MbOqF	Donga Clinic	\N	\N	4
192	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/blbFyrowZRf	Munyati Clinic	\N	\N	4
193	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/ciA1z5O6JiF	Kwekwe ZRP Clinic 	\N	\N	4
194	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/cNMEcj2lCN3	Mbizo 1 Clinic	\N	\N	4
195	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/DFCkzGef5fF	Nyoni Rural Health Centre	\N	\N	4
196	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/dMwOTm1TWlM	Dambridge Clinic	\N	\N	4
197	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/EVPUA0tsGJm	Kwekwe Prision Clinic	\N	\N	4
198	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/F2rElAKbgv8	Dendera Rural Hospital	\N	\N	4
199	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/fBCkowl14OR	Sidakeni Clinic	\N	\N	4
200	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/GicGwiouuoj	Sherwood Clinic	\N	\N	4
201	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/h5siIA7lQfx	Ntabeni Clinic	\N	\N	4
202	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/H9fZA1uaQOi	Neighbourhood Surgery 	\N	\N	4
203	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/hDnFtSieSV6	Gaika Clinic 	\N	\N	4
204	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/hZNgOzXAjrf	Mbizo 2 Clinic	\N	\N	4
205	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/IJFe4swzr4G	Amaveni Clinic	\N	\N	4
206	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/JbefFk6huNS	Cambridge Clinic	\N	\N	4
207	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/k4sThzc4zIy	Don Juan Clinic	\N	\N	4
208	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/lr8nRgvCs8m	Redcliff Clinic	\N	\N	4
209	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/MsixjXiip6A	Connemara Prison	\N	\N	4
210	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/n8fSBgAncxp	Samambwa Clinic	\N	\N	4
211	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/N9VWu2Kppre	Torwood Hospital	\N	\N	4
212	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/nCBpV7ktT9y	Rutendo Clinic	\N	\N	4
213	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/nFw1qqq3OEx	Sigezububi Clinic	\N	\N	4
214	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/NGyX8ov4BLC	Exchange Clinic	\N	\N	4
215	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/nHD84jaIlra	Melisa Zhombe Clinic	\N	\N	4
216	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/nThW8r8MZtE	Kwekwe District Hospital	\N	\N	4
217	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/ozA3NlEUYDi	Simana Clinic	\N	\N	4
218	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/q2PCmYuFLcy	Mayoka Rural Health Centre	\N	\N	4
219	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/QwFhomr6Alo	Mazebe Rural Health Centre	\N	\N	4
220	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/RgkNZppVRq4	Zhombe Mission Clinic	\N	\N	4
221	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/RIBxxUnvvQD	Rio Tinto Mine Clinic	\N	\N	4
222	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/rUINnsV4knE	Silobela 101871 - Clinic	\N	\N	4
223	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/s33kOOe8v54	Msilahove Rural Hospital	\N	\N	4
224	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/tFiCFVJ3KLP	Donsa Clinic	\N	\N	4
225	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/Thu4CNtiulz	ZRP Kwekwe clinic 	\N	\N	4
226	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/tmh3MNEV8eO	Jena Mine Mine Clinic	\N	\N	4
227	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/tnlz7dGBqL9	Al Davies Clinic	\N	\N	4
228	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/tSdwPF3mcEX	Mpinda Clinic	\N	\N	4
229	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/uRMnnJCuNip	IP  ZUVA ILANGA	\N	\N	4
230	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/uZE16ljHypJ	Sebakwe Clinic	\N	\N	4
231	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/V9SM8e6sFIW	Silobela District Hospital	\N	\N	4
232	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/VZxPjFpaeGG	Senkwasi Clinic	\N	\N	4
233	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/wc8aKMtV9c6	Mbizo16 Clinic	\N	\N	4
234	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/WscRtpmKh2V	Mlezu College Clinic	\N	\N	4
235	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/wZ7hEF8GrRX	Community Polyclinic 	\N	\N	4
236	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/xaczn8FKa6F	Globe and Phoenix Clinic	\N	\N	4
237	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/yAnOckdjmVz	Zibagwe Clinic	\N	\N	4
238	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/yOm4gMuq9Hu	IP  KUFA KUDA	\N	\N	4
239	/Z9zOAr1dQ8K/MVEckxDrWZS/a6KxeLEZSxs/yuQafsH22Bi	Gomola Clinic	\N	\N	4
240	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q	Chirumhanzu	\N	\N	3
241	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/AG0AInbPjbR	Siyahokwe Rural Health Centre	\N	\N	4
242	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/BI7Domoboqc	Lalapanzi Clinic	\N	\N	4
243	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/bOtIKKLgzrL	Lynwood Rural Health Centre	\N	\N	4
244	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/F98KYFl0JZK	Chilimanzi RHC Clinic	\N	\N	4
245	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/fYT4uwYX7bR	Musena Clinic	\N	\N	4
246	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/i8SDWohtjJe	Driefontein Hospital	\N	\N	4
247	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/K7RUlLabEOr	Chizhou Rural Health Centre	\N	\N	4
248	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/nyRhQzZTMgL	Mapiravana Clinic	\N	\N	4
249	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/oMURIy2awFC	Tokwe 4 Clinic	\N	\N	4
250	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/PkIW54COBR3	ZIMASCO Lalapanzi Private Clinic	\N	\N	4
251	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/q7CsC5gKzVu	Hama Clinic	\N	\N	4
252	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/rtu1rrjHMxx	St. Theresa Mission Hospital	\N	\N	4
253	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/T43BsZkYC8w	Guramatunhu Clinic	\N	\N	4
254	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/t893O92bmkm	Denhere Rural Health Centre	\N	\N	4
255	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/uK2AXbSDp9c	Chengwena Clinic	\N	\N	4
256	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/v2dDQACnriT	Nyautonga Rural Health Centre	\N	\N	4
257	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/Vc71NvyZxMc	Muwonde Mission Hospital	\N	\N	4
258	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/VvXKQuTq6Ob	Nyikavanhu Rural Health Centre	\N	\N	4
259	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/wq5A0P7NE7q	Mvuma District Hospital	\N	\N	4
260	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/XB7nROXhlv4	Central Estates Clinic	\N	\N	4
261	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/yIvHq6axMFE	Mtao Clinic	\N	\N	4
262	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/ziEwv7j7AuE	Holy Cross Mission Hospital	\N	\N	4
263	/Z9zOAr1dQ8K/MVEckxDrWZS/c38pTGryV5q/zooTt6xUGVe	Chaka Clinic	\N	\N	4
264	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK	Gokwe South	\N	\N	3
265	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/arOSpdbJ7jw	Nyaje Rural Health Centre	\N	\N	4
266	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/BDBlD72O55s	Nyaradza	\N	\N	4
267	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/c1mSK9ChOGv	Ganye clinic	\N	\N	4
268	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/cBe8uJrLNGC	Gwanyika Rural Health Centre	\N	\N	4
269	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/CbhVTBWPjFE	Nyamunga Clinic	\N	\N	4
270	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/DatBlAwahyx	Manyoni Clinic	\N	\N	4
271	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/EwHQN1F5qHJ	Mateta Rural Health Centre	\N	\N	4
272	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/fH3XHnD9BCh	Manoti Clinic	\N	\N	4
273	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/g6MwwPKIddS	Mkoka Rural Health Centre	\N	\N	4
274	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/g7fNiqyS7WV	Cheziya Clinic	\N	\N	4
275	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/ge97aHzWbju	Msala Clinic	\N	\N	4
276	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/HFr9g4kazyr	Gokwe South ZRP Camp Clinic 	\N	\N	4
277	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/HOkDsYNkFWL	Huchu Clinic	\N	\N	4
278	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/iIJY7AzDu3b	Krima Clinic	\N	\N	4
279	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/JBqKjqAG2ir	Jiri Clinic	\N	\N	4
280	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/Jt1CGWaXQsq	Mangidi Clinic	\N	\N	4
281	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/k0ZyBtS4wZT	Sesame Clinic	\N	\N	4
282	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/kalt3ukfjNw	Chitapo Clinic	\N	\N	4
283	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/kM0ROOTX0qh	Ndhlalambi	\N	\N	4
284	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/M8BCidxIPZM	Musita Clinic	\N	\N	4
285	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/O4s37nmNxxd	Masuka Clinic	\N	\N	4
286	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/OkK9ixbSp7W	Zhamba Clinic	\N	\N	4
287	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/OrydhbKFg8H	Gokwe District Hospital	\N	\N	4
288	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/qKPPhaui7JF	Kana Mission Hospitals	\N	\N	4
289	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/Qryp4Or7gFU	Mapfungautsi clinic	\N	\N	4
290	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/S2bq66BaqLc	Sai Clinic	\N	\N	4
291	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/tzl7tNuGHRa	Mateme Clinic	\N	\N	4
292	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/v3XtUlhTAEv	Chitave Clinic	\N	\N	4
293	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/V3ZLerPguLB	Svisvi Rural Health Centre	\N	\N	4
294	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/vXnel4MlOIT	Njelele Clinic	\N	\N	4
295	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/w1k2xD78mUR	Tongwe Clinic	\N	\N	4
296	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/XJsn6cGdf0G	Ndabambi Clinic	\N	\N	4
297	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/XSmGmvAT5tj	Gawa Clinic	\N	\N	4
298	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/yhtctd0Cnr6	Katema clinic	\N	\N	4
299	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/Z5JW59dTYkT	Mutange Clinic	\N	\N	4
300	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/zP9QBYI8isU	Gokwe South Population Services Zimbabwe 	\N	\N	4
301	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/ZsERKMysaqk	Chemahororo Clinic	\N	\N	4
302	/Z9zOAr1dQ8K/MVEckxDrWZS/dtSWh4GEflK/zsRDbhBIGQR	Jahana Clinic	\N	\N	4
303	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ	Gokwe North	\N	\N	3
304	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/AItQqOMxOox	Vumba Clinic	\N	\N	4
305	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/aLIaeQLx8B2	Mtora Rural Hospital	\N	\N	4
306	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/CGpH4xxmfZB	Rubatsiro Clinic	\N	\N	4
307	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/dPeHZhhlRGv	Zhomba Clinic	\N	\N	4
308	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/eQS88MPElhc	Nenyunga Clinic	\N	\N	4
309	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/eWmsHCZ8eUb	Nembudziya Hospital	\N	\N	4
310	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/Ez1xUxP13W6	Simchembu Clinic	\N	\N	4
311	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/Fdo72wUF5r0	Goredema Clinic	\N	\N	4
312	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/ftFOxqRJROM	Kuwirirana Clinic	\N	\N	4
313	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/g7ArwKlq8xZ	Sanyati Mine Clinic	\N	\N	4
314	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/GB65BE0uoLA	Mashame Rural Health Centre	\N	\N	4
315	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/gs4o7ahP2MC	Chireya Mission Hospital	\N	\N	4
316	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/jZszukLR7Iy	Burure Clinic	\N	\N	4
317	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/lUbaZpr7l25	Denda Clinic	\N	\N	4
318	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/nTZ9JlkZyBK	Simchembu Rural Health Centre	\N	\N	4
319	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/OGUMmDY7jLs	Kadzidirire Rural Health Centre	\N	\N	4
320	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/QUjtyFAkEez	Nyamhara Clinic	\N	\N	4
321	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/qYCk7o87itz	Tsungai Rural Health Centre	\N	\N	4
322	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/qyIkAwAvuCb	Zumba Clinic	\N	\N	4
323	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/R9cv2jkCehY	Nyamazengwe Clinic	\N	\N	4
324	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/RCpPlLVf75W	Mutora Mission Hospital	\N	\N	4
325	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/RZer5wJQGdq	Kahobo Clinic	\N	\N	4
326	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/uivBreE2eHQ	Mzadzi Rural Health Centre	\N	\N	4
327	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/w0Dyom77Nug	Gandavaroyi Clinic	\N	\N	4
328	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/wAqD43qHQAZ	Madzivazvido Clinic100106	\N	\N	4
329	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/xyDWFkQyu9K	Gumunyu Clinic	\N	\N	4
330	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/YaKDckn1Qrk	Norah Rural Health Centre	\N	\N	4
331	/Z9zOAr1dQ8K/MVEckxDrWZS/L2GCOZE3ZGJ/ZIC6ZIR7PJS	Gokwe North District Hospital	\N	\N	4
332	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9	Mberengwa	\N	\N	3
333	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/b1EmP6cfSji	Musume Mission Hospital	\N	\N	4
334	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/B9tfPt6kbdN	Mponjani Clinic	\N	\N	4
335	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/bAlZzNKhdBr	Makuwerere Clinic	\N	\N	4
336	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/dAuWnsrDRVU	Gaha Clinic	\N	\N	4
337	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/DHlTNsaO7Yr	Matedzi Clinic	\N	\N	4
338	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/dL7QsbOygia	Mnene Outreach 	\N	\N	4
339	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/dySKWJvcCwO	Chiedza Clinic	\N	\N	4
340	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/E0ZtvGWVlYJ	Chaza Clinic	\N	\N	4
341	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/Ffe71rF6iVh	Vurasha Rural Health Centre	\N	\N	4
342	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/g4dlEEnd7hO	Bonda Clinic 	\N	\N	4
343	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/HQMqEmIOVzv	Ngungumbane Clinic	\N	\N	4
344	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/iSTR4XRC1dk	Sandawana Clinic	\N	\N	4
345	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/iTw40m40wuw	Mataga Rural Health Centre	\N	\N	4
346	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/j97TJ4Hxidj	Bonda Mission Hospital	\N	\N	4
347	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/kZNamfgj28K	Neta Clinic 	\N	\N	4
348	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/l41qggZoaFK	Gwarava Rural Health Centre	\N	\N	4
349	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/MQblsJGrTBd	Mazivofa Clinic	\N	\N	4
350	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/n7JrJFbZSSY	Chedembeko Clinic	\N	\N	4
351	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/nyYPQGMntMU	Vutsanana Clinic	\N	\N	4
352	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/Ocwsmwt9N25	Imbahuru Clinic	\N	\N	4
353	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/OrU0ovRBTxi	Marirazhombe Clinic	\N	\N	4
354	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/PoguCXsvJZj	Wanezi Clinic	\N	\N	4
355	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/pZIckeagBf7	Murongwe Rural Health Centre	\N	\N	4
356	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/Q307hGeLwHq	Mnene Mission Hospital	\N	\N	4
357	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/Q8Btfg2jxPv	Negobe Clinic	\N	\N	4
358	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/R1CcS5Hxd1k	Mposi Clinic	\N	\N	4
359	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/rbE4iLAquiP	Mberengwa District Hospital	\N	\N	4
360	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/rhEss5YJ0lt	Chingezi Clinic	\N	\N	4
361	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/RXaYWmsAjhs	Masase Mission Hospital	\N	\N	4
362	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/sBdgbB2fR3S	Kotokwe Clinic	\N	\N	4
363	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/sMfRb7ilqPz	Muketi Clinic	\N	\N	4
364	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/soB2Lgw5gnB	Ingezi Clinic	\N	\N	4
365	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/TdlbemyPNd1	Chabwira Clinic	\N	\N	4
366	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/Tuja7aMuhP7	Neta Clinic	\N	\N	4
367	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/V1UPlYfZT1D	Svita Clinic	\N	\N	4
368	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/YtbICY59p63	Jeka Rural Hospital	\N	\N	4
369	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/YvS8idqg8Ly	Buchwa Clinic	\N	\N	4
370	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/yWRCzwtdVqp	Bonda Clinic	\N	\N	4
371	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/yzbqtmKSajN	Mavorovondo Rural Health Centre	\N	\N	4
372	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/ZKI10jvmQ9W	Wanezi Rural Hospital 	\N	\N	4
373	/Z9zOAr1dQ8K/MVEckxDrWZS/SfKFsufoKy9/ZWwFAVck5em	Mwenezi Rural Health Centre	\N	\N	4
374	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD	Gweru	\N	\N	3
375	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/a8GphVKSr2H	Connemara Clinic	\N	\N	4
376	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/aGWqGhV3ang	Monomutapa Clinic	\N	\N	4
377	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/aihGnf5U3JA	Nyama Clinic	\N	\N	4
378	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/aJhsccht7WS	Tumbire Clinic	\N	\N	4
379	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/B1ZFRN0RAMC	Mkoba Poly Clinic	\N	\N	4
380	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/BCGrLFAapBT	Vungu Mobile Clinic	\N	\N	4
381	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/BiLbWhqc5wO	Maboleni Clinic	\N	\N	4
382	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/c2KtIo5qOxJ	Gatawa Clinic	\N	\N	4
383	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/cy8e1swz1c4	Harben Clinic	\N	\N	4
384	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/cY93Nr1gwjo	Somabula Clinic	\N	\N	4
385	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/FDmiILjP1eD	Impala Clinic	\N	\N	4
386	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/GCjrq7GWU3O	Makepesi Clinic	\N	\N	4
387	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/hAWCopu9V38	Nkululeko Rural Health Centre	\N	\N	4
388	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/hRFRshSksyR	Ruby Clinic	\N	\N	4
389	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/HY9D6A9Y6yI	Kabanga Clinic	\N	\N	4
390	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/iEaTUEi6wdx	Senga Poly Clinic	\N	\N	4
391	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/iGoaM56EbBM	Madhikani Clinic	\N	\N	4
392	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/ixtnyj9buiO	Ivene Clinic	\N	\N	4
393	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/JRHi4DxHO3h	Child Welfare Clinic	\N	\N	4
394	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/jtWtzBZSo3X	Hozheri Clinic	\N	\N	4
395	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/kaTOd9MJSSE	Mkoba 1 Clinic	\N	\N	4
396	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/KMIq1ZmHSv8	Vungu Clinic	\N	\N	4
397	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/M0WPf48urCw	Totonga Clinic	\N	\N	4
398	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/oqwpCmwpRQM	ZPS Whawha Prison Young Offenders Clinic 	\N	\N	4
399	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/pQhsTO2zXMS	Gweru Provincial Hospital	\N	\N	4
400	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/PTsDqlRpf06	Chikwingwizha Mission Clinic	\N	\N	4
401	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/q60Ib7StJ1S	Riverdale Clinic	\N	\N	4
402	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/R0AbzHF3tB6	Gweru District Hospital	\N	\N	4
403	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/RHxCTgkiU56	Thornhill Airbase Hospital 	\N	\N	4
404	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/T7JmHwb645M	Gweru Provincial Hospital	\N	\N	4
405	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/tdC1z2GmRLr	Lower Gweru Mission Clinic	\N	\N	4
406	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/TqCxTt2cnSm	Chinamasa Clinic	\N	\N	4
407	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/UcsFwpVoOEX	Chiundura Clinic	\N	\N	4
408	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/UJXZfglDy6U	Vungu Mobile Clinic	\N	\N	4
409	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/VbSjaVx4t0f	Gunde Clinic	\N	\N	4
410	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/XdDKGCXjiWo	Mangwande Clinic	\N	\N	4
411	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/XJoYREEPF4o	Masvori Clinic	\N	\N	4
412	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/XS3MartMYZY	Kariba Clinic	\N	\N	4
413	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/yG0rQVBjb5a	Medical Centre Private Clinic	\N	\N	4
414	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/yy7YQ1Iak4s	St. Patricks Mission Clinic	\N	\N	4
415	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/ZPOJK6AT4IP	Ntabamhlope Rural Health Centre	\N	\N	4
416	/Z9zOAr1dQ8K/MVEckxDrWZS/T80WDj2iahD/zZXWPXydW2S	ZPS Whawha Prison DEL	\N	\N	4
417	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA	Zvishavane	\N	\N	3
418	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/ASSntKFP1Ns	Zvishavane ZRP Clinic	\N	\N	4
419	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/bnZSVkbpSBX	Drinkwater Nursing Home	\N	\N	4
420	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/CJJQdq1o0Rt	Medical Centre Private Clinic	\N	\N	4
421	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/CN5hSez1FZH	Shabanie Mine Mine Hospital	\N	\N	4
422	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/CvqWEbuINjk	Weleza Rural Health Centre	\N	\N	4
423	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/D9ut3NEHhGX	Mapanzure Clinic	\N	\N	4
424	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/eiunn2MoKsC	MSU Clinic	\N	\N	4
425	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/Hi6wNttAdd8	Kandodo Clinic	\N	\N	4
426	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/huxj4MJyhKc	Maglas Clinic	\N	\N	4
427	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/KuyZ6kj3XTb	Dadaya Mission Hospital	\N	\N	4
428	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/L0rNZcH9Z5A	Maketo Rural Health Centre	\N	\N	4
429	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/MNUxL1SRlNy	Sabi Mine Clinic	\N	\N	4
430	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/NT6iUEF2uVS	Mabasa Clinic	\N	\N	4
431	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/Ox0ydqSNkgB	ZIMASCO Shurungwi Private Clinic	\N	\N	4
432	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/p8KL5Fuog5s	Mimosa Clinic	\N	\N	4
433	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/QdIiE0YViIT	Dambudzo Clinic	\N	\N	4
434	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/qe0LBjtqQap	Lundi Rural Hospital	\N	\N	4
435	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/qkMuVw4MQEE	Rutendo Polyclinic	\N	\N	4
436	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/QnMzPBGLmQ1	Mtambi Clinic	\N	\N	4
437	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/STiWupVJidD	Mandava Rural Health Centre	\N	\N	4
438	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/T4GXtObhlOJ	Highlands Clinic	\N	\N	4
439	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/TUZt7mTC18H	Mhondongori clinic	\N	\N	4
440	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/U9YejzJibuv	ZPS Zvishavane Prison Clinic	\N	\N	4
441	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/UIBkjBWyuZ4	Nyanga Council Clinic	\N	\N	4
442	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/ukkS2l3nv5k	Dayataya RHC Clinic	\N	\N	4
443	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/vbppi9iFRlX	Vugwi Rural Health Centre	\N	\N	4
444	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/VyrlfkMfooL	Gudo Clinic	\N	\N	4
445	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/waZ68sJCJtf	Vukuzenzele Rural Health Centre	\N	\N	4
446	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/wKuggNiqd4f	Cellmed Private Clinic	\N	\N	4
447	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/X3DFLGTbrbV	Murowa Clinic	\N	\N	4
448	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/xFBkyhr9rIH	Bannockburn Clinic	\N	\N	4
449	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/xsM6MHhUD0w	Matenda Rural Health Centre	\N	\N	4
450	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/yEJabXRhurV	Zvishavane District Hospital	\N	\N	4
451	/Z9zOAr1dQ8K/MVEckxDrWZS/W4O6XMG1LlA/ZSmg6Wqhwv5	Mapate Clinic	\N	\N	4
452	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg	Shurugwi	\N	\N	3
453	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/an1Pd09xktD	Tana Rural Health Centre	\N	\N	4
454	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/bhrTNmQLvAI	Unki Clinic	\N	\N	4
455	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/D1FyPUDQYi2	Zvamabande Rural Hospital	\N	\N	4
456	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/DCU5QjMbbKz	Chikato Rural Health Centre	\N	\N	4
457	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/DfMa1nOjEFp	Chironde Clinic	\N	\N	4
458	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/F8F8X9L0sOV	Jobolinko Clinic	\N	\N	4
459	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/FP1lRJ2sMlz	Zviumwa RDC clinic	\N	\N	4
460	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/gYwM1oInq05	Peak Mine Mine Clinic	\N	\N	4
461	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/H20P6B4Yluo	Marishongwe Rural Health Centre	\N	\N	4
462	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/H8HToxLoWjA	Nhema Clinic	\N	\N	4
463	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/hEMexb2wBNZ	Falcon 100460 - Mine Clinic	\N	\N	4
464	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/hOfZBmVIXq4	Ruchanyu Clinic	\N	\N	4
465	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/HQZFXzUSEUY	Rusike Clinic	\N	\N	4
466	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/hTd6mJv5irD	Shurugwi District Hospital	\N	\N	4
467	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/JwthRkrvn2g	Chitora Rural Health Centre	\N	\N	4
468	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/K3eLjTWR7Ua	Tongogara Clinic	\N	\N	4
469	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/ksGEyiL6VHK	Pakame Clinic	\N	\N	4
470	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/L6HMMjCf2em	ZPS Shurugwi Prison Clinic	\N	\N	4
471	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/lWzWzj8eDod	Hanke Clinic	\N	\N	4
472	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/lypiu5vVvu0	Chrome Mines Shurugwi Mine Hospital	\N	\N	4
473	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/PIZUU3RLWHG	Tokwe Clinic	\N	\N	4
474	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/PydZayKOsQV	Zhaugwe Clinic	\N	\N	4
475	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/qkFQzufmpjb	Dorset Clinic	\N	\N	4
476	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/QW93hki8ayp	Rockford Clinic	\N	\N	4
477	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/rtLLKsPVFcX	Mazibisa Clinic	\N	\N	4
478	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/TenG4vHgD9p	Svika Clinic	\N	\N	4
479	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/tg8XvvZ7SvM	Banga Clinic	\N	\N	4
480	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/uI2DSCwZKUa	Golden Quarry Mine Clinic	\N	\N	4
481	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/wmQIKWoVMfG	Gundura Clinic	\N	\N	4
482	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/xg2YCfwetVR	Makusha Clinic	\N	\N	4
483	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/xjIYZptpvVW	Gwanza Rural Health Centre	\N	\N	4
484	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/yGSzG29MJxg	Ironsides Clinic	\N	\N	4
485	/Z9zOAr1dQ8K/MVEckxDrWZS/XQwyooJ2rFg/ZTPdE7JnPrm	Zvarota Rural Health Centre	\N	\N	4
486	/Z9zOAr1dQ8K/ngqYrheLIDD	Manicaland	\N	\N	2
487	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R	Nyanga	\N	\N	3
488	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/a4kWVQubF2X	Nyafaru Council Clinic	\N	\N	4
489	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/aeF4KhBTPQI	Aberfoyle Clinic	\N	\N	4
490	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/Aju73vTX3QS	Kambudzi Conucil Not Open	\N	\N	4
491	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/ar0uDdfnZLj	Matize Rural Health Centre	\N	\N	4
492	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/bbV3evgWChh	Mt. Mellary Mission Hospital	\N	\N	4
493	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/CjgYvsSWY6Z	Fombe Council Clinic	\N	\N	4
494	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/dDQvfr1J1WF	Nyangui Private Forestry Clinic	\N	\N	4
495	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/E3dKaO9EVLG	Nyamaropa Council Clinic	\N	\N	4
496	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/f2s3q3hpt2Y	Dombo Rural Health Centre	\N	\N	4
497	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/Fb1Fnblxple	Nyanga Mobile Clinic	\N	\N	4
498	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/fl6hx1uY9Eb	Nyarumvurwe Rural Health Centre	\N	\N	4
499	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/fPNA1SRHldG	Mutarazi Clinic	\N	\N	4
500	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/GbG0Da4p4Hc	Chitindo Council Clinic	\N	\N	4
501	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/grCzCZ5MKey	Erin Forestry-Private	\N	\N	4
502	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/H0EuZW5U6z0	Gairezi Council Clinic	\N	\N	4
503	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/h7OMUB2Ob3i	Elim Mission Hospital	\N	\N	4
504	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/i5llB2NrDWw	Nyamombe Rural Health Centre	\N	\N	4
505	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/IgZY1FyiSSB	Samvure Council Clinic	\N	\N	4
506	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/muBXBus5Chx	Bende Clinic	\N	\N	4
507	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/nkf2rrmAkzP	Nyadowa Council Clinic	\N	\N	4
508	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/NLhSRRNT8F4	Chiwarira Council Clinic	\N	\N	4
509	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/NQBKBdfT0YJ	Nyanga District Hospital	\N	\N	4
510	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/o8EDoGj6HD4	Nyajezi Clinic	\N	\N	4
511	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/oALHRSyP6i2	Chatindo Clinic	\N	\N	4
512	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/oqI2jr2KAz2	Nyamombe Camp Rural Health Centre	\N	\N	4
513	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/OXSDJw3J1Zl	Tombo Council Clinic	\N	\N	4
514	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/PVpAdwNSnq3	Nyatate Council Clinic	\N	\N	4
515	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/qcGHhCLYnKa	Ruchera Rural Health Centre	\N	\N	4
516	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/sVeHRWVdzTM	Nyautate Rural Health Centre	\N	\N	4
517	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/UGYRNb8466w	Nyanguai Clinic	\N	\N	4
518	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/v5Mf8W0aulE	Avilla Mission Hospital	\N	\N	4
519	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/vwb72K515yt	Spring Valley Clinic	\N	\N	4
520	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/WCu1aJrsw0l	Gotekote Rural Health Centre	\N	\N	4
521	/Z9zOAr1dQ8K/ngqYrheLIDD/dEbgc2xNR7R/wxKvq2qiszm	Regina Coeli Mission Hospital	\N	\N	4
522	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc	Chimanimani	\N	\N	3
523	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/AjBwPCDCukg	Chakohwa Clinic	\N	\N	4
524	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/AW4wxesSF8S	Cashel Clinic	\N	\N	4
525	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/BlkmcgIR2dz	Gudyanga Clinic	\N	\N	4
526	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/CCzFofFOoMT	Nhedziwa Clinic	\N	\N	4
527	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/E5CaoaX1605	Gwindingwe Clinic	\N	\N	4
528	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/F6P4PtvHaZw	Chisengu Clinic	\N	\N	4
529	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/GCMKQ32EWZU	Biriwiri Mission Hospital	\N	\N	4
530	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/gvH9aEu9LFy	Nyanyadzi Rural Hospital	\N	\N	4
531	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/hD3vfY5bAdi	Bumba Rural Health Centre	\N	\N	4
532	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/hYSc6wvfcWG	Tilbury Clinic	\N	\N	4
533	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/Ia12Df0aJyf	Chayamiti Clinic	\N	\N	4
534	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/JAMuNO9sAlF	Muchadziya Clinic	\N	\N	4
535	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/JijpjzeCPrb	Chimanimani Urban Clinic	\N	\N	4
536	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/k0PmvWDldMm	Changazi Rural Health Centre	\N	\N	4
537	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/kEGZiKotSKs	Mutsvangwa Clinic	\N	\N	4
538	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/LrjXNgGMFo1	Chimanimani Hospital Rural Hosp	\N	\N	4
539	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/M6S5SNi4qi5	ARDA Rusitu Clinic	\N	\N	4
540	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/mq701zWt16S	Roscommon Clinic	\N	\N	4
541	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/N3Ue3Ale4Mn	Charter Clinic	\N	\N	4
542	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/PmHlHdYH6Yd	Tarka Clinic	\N	\N	4
543	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/Szr0eoJtKNc	Shinja Clinic	\N	\N	4
544	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/TFFSBxnsxMH	Martin Clinic	\N	\N	4
545	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/TMfrBXHeLne	Nyahode Clinic	\N	\N	4
546	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/tNrG9RqjXep	Mutambara District Hospital	\N	\N	4
547	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/uJl69M3WiCL	Ngorima Clinic	\N	\N	4
548	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/Us2ufZ2IjZC	Rusitu Mission Hospital	\N	\N	4
549	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/vG0B1OTBL7l	Chikukwa Rural Health Centre	\N	\N	4
550	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/VPHZ5xI0ci8	Mhakwe Clinic	\N	\N	4
551	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/WLsZeN6rP6O	Nyabamba Satellite Clinic	\N	\N	4
552	/Z9zOAr1dQ8K/ngqYrheLIDD/Lhyoz3R6Ajc/YM73O6RSoJt	Chikwakwa Clinic	\N	\N	4
553	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht	Mutare	\N	\N	3
555	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/AsdXd0AoGXL	Chitaka Clinic	\N	\N	4
556	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/Aw9meXkMQYK	Nyamazura Rural Health Centre	\N	\N	4
557	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/AwcwYEbSQCl	ARDA Odzi Clinic	\N	\N	4
558	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/BtCysCBfnDp	Nyagundi Rural Health Centre	\N	\N	4
559	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/cAEJQYoN26N	Mukwada Clinic	\N	\N	4
560	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/cr9XgOrqJwk	Dangamvura Clinic	\N	\N	4
561	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/CzT0kz8uz7m	Chishingwi Clinic	\N	\N	4
562	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/DApAIch75BK	Mutare Provincial Hospital	\N	\N	4
563	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/dhvrhq8mLae	ARDA Transau Clinic	\N	\N	4
564	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/DnVqMdfhU8F	Chinyamazizi	\N	\N	4
565	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/eGJAGwnxFSZ	Sakubva Health Centre Hospital	\N	\N	4
566	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/eN6ckU5zhfE	Chiadzwa Rural Health Centre	\N	\N	4
567	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/fen7qRnHupP	Mutare Provincial Hospital	\N	\N	4
568	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/fPVUTHduV6g	Umguza Infectious Diseases Hospital 	\N	\N	4
569	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/FTXaJPvQwkN	Odzi Rural Hospital	\N	\N	4
570	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/GmBfBIZu0RH	Florida Clinic	\N	\N	4
571	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/gukxzjQHdEA	Chipendeke Rural Health Centre	\N	\N	4
572	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/gzDYRQZm5rr	Nzvenga Clinic	\N	\N	4
573	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/h22FuA9Lid3	Chiwere Rural Health Centre	\N	\N	4
574	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/HQbYgzkaUjw	Berzerly Bridge Clinic	\N	\N	4
575	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/icwINxeOGNY	Zvipiripiri Clinic	\N	\N	4
576	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/IVF9iD8sboV	Sakubva District Hospital	\N	\N	4
577	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/JS42B8mFEYI	Muromo Rural Health Centre	\N	\N	4
578	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/Ju7yjwNpnZc	Chikwariro Mission Hospital	\N	\N	4
579	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/KL8n0WXGgGS	Vumba Clinic	\N	\N	4
580	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/KwpBAMKX07m	Bwizi Clinic	\N	\N	4
581	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/L1KD15RCB3o	Mt. Zuma Rural Health Centre	\N	\N	4
582	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/LLYfRU87KVr	Munyarari Clinic	\N	\N	4
583	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/mMyO9i8yO9f	Rowa Clinic	\N	\N	4
584	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/nFJhU0rVPlH	Mushunje Clinic	\N	\N	4
585	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/OcGPckc3QEu	Fernvalley Clinic	\N	\N	4
586	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/OdVIpeFRpxI	Dora Clinic	\N	\N	4
587	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/ooBctEFShCo	Madanga	\N	\N	4
588	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/pE1MgQBvhP2	Bakorenhema Clinic	\N	\N	4
589	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/PMjhk9KezDp	Mambwere Clinic	\N	\N	4
590	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/Q9uDyfOwrdT	Gutaurare Rural Health Centre	\N	\N	4
591	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/QBQZTIv1lrz	Burma Valley Clinic	\N	\N	4
592	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/QE02qC7QVJL	St. Josephs T.B Hospital	\N	\N	4
593	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/QkfHdRxjphj	St. Welburgh Mission Clinic	\N	\N	4
594	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/QMHTxq1jwsv	Masasi Clinic	\N	\N	4
595	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/rotRV33ogHc	Zumbare Clinic	\N	\N	4
596	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/RrRf8znKPaf	Matanda Rural Health Centre	\N	\N	4
597	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/rRZdfRZ2VAu	ARDA Transau Clinic 	\N	\N	4
598	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/rU8ccMdaYVq	St Josephs T.B Hospital	\N	\N	4
599	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/RXChmJ29yIG	St. Andrews Mission Hospital	\N	\N	4
600	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/RyINk05jngO	Chitakatira Clinic	\N	\N	4
601	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/s3eJe4WBzCB	Fobbes Boarder Wellness Centre Private Clinic	\N	\N	4
602	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/s4fE8Jt1g4L	Lee Kul Clinic	\N	\N	4
603	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/s5QteHELIvJ	Zimunya Clinic	\N	\N	4
604	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/savcKy76svm	Bvumba Private Clinic	\N	\N	4
605	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/sySIljgDD4k	Chipfatsura Clinic	\N	\N	4
606	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/tFn1RnL4Q1a	Hob House Clinic	\N	\N	4
607	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/Tj9XAHdTx71	Chikanga Clinic	\N	\N	4
608	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/uqcF5EYPpIZ	Mutare Council Clinic	\N	\N	4
609	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/vuEfRSfa6e3	Gimboque Clinic	\N	\N	4
610	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/wXnCifW3qRh	Chitora Clinic	\N	\N	4
611	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/X7Tj1WoSu8a	Gwindingwi Rural Health Centre	\N	\N	4
612	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/YaxwrjxwqJy	Chatora Clinic 	\N	\N	4
613	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/Yb75x5mU1gC	Marange Rural Hospital	\N	\N	4
614	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/Zif0pyzPbp5	Murambi Gardens Private Clinic	\N	\N	4
615	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/zUEyrYaMPsk	Hob House Clinic	\N	\N	4
616	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr	Mutasa	\N	\N	3
617	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/adTkHyR4BvG	Gatsi Mission Clinic	\N	\N	4
618	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/arVJbD2Phv8	Sachisuko Clinic	\N	\N	4
619	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/B6T4mymKXpD	St. Augustines Mission Clinic	\N	\N	4
620	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/bY4JUbYxhAI	St. Peters Mandeya Mission Hospital	\N	\N	4
621	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/BYeo2WTlTbW	Sadziwa Council Clinic	\N	\N	4
622	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/cJvWwH3FJLR	Premier Clinic	\N	\N	4
623	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/CnknUJ5B5JT	Katiyo Private-Tanganda	\N	\N	4
624	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/CxoOWvWIIw7	Chinangwe Clinic	\N	\N	4
625	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/d6UW4bgGKi7	Sakupwanya Council Clinic	\N	\N	4
626	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/dbl9tfa7QdC	Eastern Highlands 1 Private Tanganda	\N	\N	4
627	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/eqxYAQqMAGm	Mupotedzi Gvt Clinic	\N	\N	4
628	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/ETgdoZ3NO4b	Tsvingwe Clinic	\N	\N	4
629	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/EzdyWsiwd8t	Chitombo Council Clinic	\N	\N	4
630	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/f3nMyAIch9x	Samaringa Council clinic	\N	\N	4
631	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/FOnficOMOxV	Samanga Council clinic	\N	\N	4
632	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/hecbb09WesM	Mundeya Clinic	\N	\N	4
633	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/ivSpKPosBuc	Hauna District Hospital	\N	\N	4
634	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/iZoxQ2mltpe	Mt. Jenya Council Clinic	\N	\N	4
635	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/jUWF0Gd5yAZ	Ngarura Council Clinic	\N	\N	4
636	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/jZaPZgPWb5B	Drenane Timbers Private Clinic	\N	\N	4
637	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/llNspZj777F	Chinaka Health Post	\N	\N	4
638	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/mKPIOr2x9fm	Rupinda Rural Health Centre	\N	\N	4
639	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/N4oXqGfFso8	Sagambe Council Clinic	\N	\N	4
640	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/NOfUwvwI2PP	Sherukuru Rural Health Centre	\N	\N	4
641	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/O4iWNzTwIyQ	Sahumani Council Clinic	\N	\N	4
642	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/P9DDMEU84HO	Chisuko Council Clinic	\N	\N	4
643	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/Pj2cnKKkXFf	EHPL 1 Clinic	\N	\N	4
644	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/PscJCWrhzka	Old Mutare Mission Hospital	\N	\N	4
645	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/PSTaVtwddQ4	Honde Mission Hospital	\N	\N	4
646	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/pXNHetKSqH5	Imbeza Clinic	\N	\N	4
647	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/qeqXIu3KfO0	Premier Medical Centre Private Clinic 	\N	\N	4
648	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/QtsGPbZ9kIR	Guta Council Clinic	\N	\N	4
649	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/QXqZoFfrO5f	EHPL 6 Clinic	\N	\N	4
650	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/r97ObjsRhxc	Mapara Clinic	\N	\N	4
651	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/rDAJbe52fOS	Bonda Mission Hospital	\N	\N	4
652	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/reNojL4HxU8	Mandeya 11 Clinic	\N	\N	4
653	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/S9ItwIxzitL	Hauna Clinic	\N	\N	4
654	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/seMV6QMcbYn	Zongoro Council Clinic	\N	\N	4
655	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/T46Sw2id6WV	Red Wing Private-Mine	\N	\N	4
656	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/TqSLd6OiLlz	Sheba Border Timbers Private Clinic	\N	\N	4
657	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/uE3RH5mk84U	Nyamukwarara Clinic	\N	\N	4
658	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/UT3jZU0B8NY	Triashill Mission Hospitals	\N	\N	4
659	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/vrfWESP2bX6	Moyoweshumba Council Clinic	\N	\N	4
660	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/vtJMwcFafnS	Haparare Council Clinic	\N	\N	4
661	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/WfLnM2upfzo	Chinaka Health Post 	\N	\N	4
662	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/XarjiDpWpIl	Nyanga Pines Clinic	\N	\N	4
663	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/xBQLT1WFHR7	Tsonzo Rural Hospital	\N	\N	4
664	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/XMvFrrVQBbh	Dunsinane Clinic	\N	\N	4
665	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/xRiIyDXPWV5	Zindi Clinic	\N	\N	4
666	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/XRKLDnHvYFJ	Chavhanga Rural Health Centre	\N	\N	4
667	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/XZkKJ2ARldu	ARDA Katiyo Clinic 	\N	\N	4
668	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/y0JY0ye8q3J	Jombe Clinic	\N	\N	4
669	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/YQvLvebHo4d	Chinamasa Rural Health Centre	\N	\N	4
670	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/ZCHDN6RCLiA	Mutasa Council Clinic	\N	\N	4
671	/Z9zOAr1dQ8K/ngqYrheLIDD/n47r6kdRLGr/zP8n2YUWifz	St. Barbaras Mission Hospitals	\N	\N	4
672	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC	Buhera	\N	\N	3
673	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/BDEmqp90JTA	Mutepfe Clinic	\N	\N	4
674	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/bqBYwNAxlo1	Gunura Clinic	\N	\N	4
675	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/cBlAU3Ex35B	Murwira Rural Health Centre	\N	\N	4
676	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/Di7OHhpjIr2	Chapanduka Clinic	\N	\N	4
677	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/e0BxlFLWuKQ	Mudanda Clinic	\N	\N	4
678	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/ExkPrlU2JL0	Birchenough Rural Hospital	\N	\N	4
679	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/FRb74ACeEZB	Buhera Rural Hospital	\N	\N	4
680	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/fSJy9rjmBSB	Bangure Clinic	\N	\N	4
681	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/g9SCxKLS1Rl	Garamwera Clinic	\N	\N	4
682	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/GRnO7AgEsEI	Mombeyarara Rural Health Centre	\N	\N	4
683	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/GsL0s0RILmu	Zangama Rural Health Centre	\N	\N	4
684	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/hcUbMLN50UW	Betera Rural Health Centre	\N	\N	4
685	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/hzwVAOS3w2R	Mudawose Clinic	\N	\N	4
686	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/I34x7M32C2r	Chawatama Rural Health Centre	\N	\N	4
687	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/i8H1mPyK3Fm	Chabata Clinic	\N	\N	4
688	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/IfQGMZN0HcM	Murambinda District Hospital	\N	\N	4
689	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/jFqSHbG59uf	Muzokomba Clinic	\N	\N	4
690	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/JXKy9DJE3gm	Chiweshe Clinic	\N	\N	4
691	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/MUyHOXjfS9i	Mbundire clinic  010142	\N	\N	4
692	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/O3Eqk96OQ4D	Nyashanu Rural Hospital	\N	\N	4
693	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/PWF0NkIV5ry	Berenyazvidzi Clinic	\N	\N	4
694	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/QcWGAc2BBkH	Chimbudzi Clinic	\N	\N	4
695	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/rRYyzyfhDzN	Chiwenga Clinic	\N	\N	4
696	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/RylLQnL36Fi	Rambanapasi Clinic	\N	\N	4
697	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/RZQzoM8gIgm	Mutiusinazita Clinic	\N	\N	4
698	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/snbgbGRWH3K	Madzimbashuro Rural Health Centre	\N	\N	4
699	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/sOJ2bmldRlG	Chipondamidzi  010141	\N	\N	4
700	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/tgvfmhl76EX	Mukubu  Clinic	\N	\N	4
701	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/TmsVAKEii26	Moses clinic  010144	\N	\N	4
702	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/tovyRP4oXFQ	Chirozva Clinic	\N	\N	4
703	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/vdDCCb7mOh7	Ndyarima Clinic	\N	\N	4
704	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/VxyFvXmfKoZ	Gombe Clinic	\N	\N	4
705	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/we1xrcSbSU4	NSC  Murambinda	\N	\N	4
706	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/WKyg79FMK1g	Munyanyi Clinic	\N	\N	4
707	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/WqWubHGJiuf	Mutasa  Clinic	\N	\N	4
708	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/XWTWzUKR92m	Chapwanya Clinic	\N	\N	4
709	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/XXkxbdoBx3n	Nerutanga Clinic	\N	\N	4
710	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/yivxyODFPUB	Maburutse  Clinic	\N	\N	4
711	/Z9zOAr1dQ8K/ngqYrheLIDD/tdTAQuQ1cyC/YlbaMtnwj8s	Msasa RDC Clinic	\N	\N	4
712	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw	Makoni	\N	\N	3
713	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/Adoq6MHcOB7	Bingaguru Rural Health Centre	\N	\N	4
714	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/avJBKspv9hU	Tsanzaguru Clinic	\N	\N	4
715	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/bkpJdhMUWKf	Vengere Clinic	\N	\N	4
716	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/BTZXAPMERV4	Nedevedzo Rural Hospital	\N	\N	4
717	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/C6U9KXkP1LK	Nasmie Clinic	\N	\N	4
718	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/CDJGz6wu5lf	Nyazura Clinic	\N	\N	4
719	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/ciscgPAvSgq	Katsenga Rural Health Centre	\N	\N	4
720	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/D7ozNJrRYT5	Mubvurungwa Clinic	\N	\N	4
721	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/DVLOKsqb4Zl	Maparura Rural Health Centre	\N	\N	4
722	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/eqUVN5CpzeZ	Rukweza Clinic	\N	\N	4
723	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/ESGACA5ofKz	Nzvimbe clinic 0104101	\N	\N	4
724	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/etft9xU7U6U	Dumbamwe Clinic	\N	\N	4
725	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/FNqqNK8uxkj	Nyamukamani Rural Health Centre	\N	\N	4
726	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/gcxqxWPw1ZC	Chinyika 1 Rural Health Centre	\N	\N	4
727	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/gmCfw2czWHi	Masvosva Rural Health Centre	\N	\N	4
728	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/GPHfKajtX5M	Little Kraal Clinic	\N	\N	4
729	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/gYjSfULDFyV	Chiduku Clinic	\N	\N	4
730	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/hcyuAxmkOqu	Maurice Nyagumbo Clinic	\N	\N	4
731	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/Hu31HxP4pnG	Era Mine Mine Clinic	\N	\N	4
732	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/i1304rA978N	Tsikada Rural Health Center 	\N	\N	4
733	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/igDHRzTsJrp	Chinyadza Clinic	\N	\N	4
734	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/IS9RJYi881o	Tsikada Rural Health Center 	\N	\N	4
735	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/jfvugcbgBLD	Chikobvore Rural Health Centre	\N	\N	4
736	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/JRx4DirjNEn	Chitungwiza Clinic	\N	\N	4
737	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/k1c19Mj2YZJ	Zunidza Clinic	\N	\N	4
738	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/ldxZ72IIbir	St. Michaels Mission Hospital	\N	\N	4
739	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/NMWRzVxqJBp	Tsikada Rural Health Center	\N	\N	4
740	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/nrMK5a1kkjl	Weya Rural Hospital	\N	\N	4
741	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/Oc6aa9el706	Mukamba Clinic	\N	\N	4
742	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/ocBmfh8IMry	Little Kraal Clinic 	\N	\N	4
743	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/OEmeKmvagQm	Mufusire Clinic	\N	\N	4
744	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/OJpvLVgZmR0	Mayo 1 Rural Health Centre	\N	\N	4
745	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/onNuwP6Pfw4	Nyamidzi Clinic	\N	\N	4
746	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/pcXd2hwfzZV	Headlands Clinic	\N	\N	4
747	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/Q5czETNKIUx	FACT Clinic Clinic	\N	\N	4
748	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/Q821gRmBnL3	Dowa Clinic	\N	\N	4
749	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/QHVCAkeXCog	Tandi Clinic	\N	\N	4
750	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/qqyUMe7zgsr	Little Kraal Nyazura Farm Prison	\N	\N	4
751	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/ritN087xLCM	Ringanayi Clinic	\N	\N	4
752	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/RWivvGgnk5S	Chinhenga Rural Health Centre	\N	\N	4
753	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/SISBOCPkjkv	Tariro Clinic	\N	\N	4
754	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/sR5qFlyKfxO	Nyahowe Rural Health Centre	\N	\N	4
755	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/SyzlxdgIEUo	Mukuwapasi Clinic	\N	\N	4
756	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/T663SER6C7W	Nyahukwe Rural Health Centre	\N	\N	4
757	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/tALfbumNAOT	Mayo 2 Rural Health Centre	\N	\N	4
758	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/tjtRpuZkP15	Chiome Clinic	\N	\N	4
759	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/TQqJCd3vopo	Nedziwa Clinic	\N	\N	4
760	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/Txi298JjnJB	Chinyudze Rural Health Centre	\N	\N	4
761	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/Uh7O39laKjv	Gowakowa Rural Health Centre	\N	\N	4
762	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/uWhfHwNDemw	Makoni Rural Hospital	\N	\N	4
763	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/V1bA6zIKJdr	Mabvaziva clinic 0104102	\N	\N	4
764	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/VKhKIdCsAHA	Nyazura Mission Clinic	\N	\N	4
765	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/VUl74f1phMs	Rusape District Hospital	\N	\N	4
766	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/VWsEtgX9I8R	Nyamusosa Clinic	\N	\N	4
767	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/VxybGJwWgEV	Gorubi Springs Rural Health Centre	\N	\N	4
768	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/wHqZbOi222z	Nyazura Clinic	\N	\N	4
769	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/wo9el2iugOq	Matotwe Clinic	\N	\N	4
770	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/X8eNcHrqP3q	St. Theresa Mission Hospital	\N	\N	4
771	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/X8PgJiXb9dh	Mavhudzi Clinic	\N	\N	4
772	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/Xn3QvNdNdVf	Chinyika 2 Rural Health Centre	\N	\N	4
773	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/XxVznC08Dqf	Bamba Rural Health Centre	\N	\N	4
774	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/xydbCkcaUfL	Chikore Clinic	\N	\N	4
775	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/YXs6Sw0yceC	Sangano Clinic	\N	\N	4
776	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/z3QmTgqAP04	Matsika Clinic	\N	\N	4
777	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/zbiLLHQRvvr	Rusape ZRP Clinic 	\N	\N	4
778	/Z9zOAr1dQ8K/ngqYrheLIDD/yJFlOa4npWw/ZP6AUxsoZDz	Anorldine Clinic	\N	\N	4
779	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc	Chipinge	\N	\N	3
780	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/amsyTo6Om22	Tongogara Clinic	\N	\N	4
781	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/Ay1YSvb4KQR	Changazi clinic 	\N	\N	4
782	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/B4RFb8m7IUg	Zona Clinic	\N	\N	4
783	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/BSTfx1ktZet	Chipinge New Start Centre/New Life Cent 	\N	\N	4
784	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/cQ6zS5sLoW0	Gwenzi Clinic	\N	\N	4
785	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/d6NhWP6vRNF	Musirwizi Clinic	\N	\N	4
786	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/dmG5Nog6eNq	Musani Clinic	\N	\N	4
787	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/E5TbMMc7bA3	Kondo Clinic	\N	\N	4
788	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/ElZc8VF2oSA	Tanganda Clinic	\N	\N	4
789	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/eM48tOmb5ex	Kopera Clinic	\N	\N	4
790	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/ggRzUEiEnO3	Avontour Tingamire Clinic	\N	\N	4
791	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/GoVLABLOLs3	Ngaome Clinic	\N	\N	4
792	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/hC6cct2Jj4T	Chipinge New Start Centre/New Life Centre	\N	\N	4
793	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/HlCM9K3wEBr	Chipangayi Clinic	\N	\N	4
794	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/IAxIHwuKmli	Rimbi Clinic	\N	\N	4
795	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/IfKqyKB6VCQ	Zamchiya Clinic	\N	\N	4
796	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/IGGZELojXLu	Manzvire Clinic	\N	\N	4
797	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/JrkEzV0EXrw	Paidamoyo Clinic	\N	\N	4
798	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/JSZvh2eCSTO	Midsave Clinic 	\N	\N	4
799	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/keLg1H27wuQ	Junction Gate Clinic	\N	\N	4
800	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/KTR82HGVqGM	Mabeye Clinic	\N	\N	4
801	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/llEZFtnjIuw	Chiriga Rural Health Centre	\N	\N	4
802	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/LQPbeSx2vyk	Gumira Clinic	\N	\N	4
803	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/LXXmlgvXDJk	ARDA Mid 100023 - Clinic	\N	\N	4
804	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/LY5YYd3NGVB	Jersey Clinic	\N	\N	4
805	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/LyRjn3QDVEk	Takwirira Clinic	\N	\N	4
806	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/m9X5oVENSzf	Silverstream Clinic	\N	\N	4
807	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/MBZYJhiMWW9	Tamandai Clinic	\N	\N	4
808	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/MKTghrOSky3	Chiringa Clinic	\N	\N	4
809	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/n4Ie2UOMdnJ	Lamont Clinic	\N	\N	4
810	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/nlmsitPL9Iu	Mt. Selinda Mission Hospital	\N	\N	4
811	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/nNmjZD0Xkbi	Vheneka Clinic	\N	\N	4
812	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/nnTF3x2k1Nj	Chikore Mission Hospital	\N	\N	4
813	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/ONLXKfU6kMU	Mahenye Clinic 	\N	\N	4
814	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/pv8AC8uKyqP	Gaza Council Clinic	\N	\N	4
815	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/q8w6UsNPbMG	Chibuwe Clinic	\N	\N	4
816	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/QGNk0xwCPLp	Southdowns Clinic	\N	\N	4
817	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/qGRNNxCRE9F	Hwakata Clinic	\N	\N	4
818	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/qjwyEub0gWL	Chipinge District Hospital	\N	\N	4
819	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/QxmfRcsbHhH	Muswera Clinic	\N	\N	4
820	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/REgkS89loxc	Chichichi Clinic	\N	\N	4
821	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/tJL4F34QLHI	Ngaome Clinic 	\N	\N	4
822	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/tsaaH8cN0EY	Ratelshoek Clinic	\N	\N	4
823	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/TT234FizJFS	Nyunga Clinic	\N	\N	4
824	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/uj8ctjqnN8U	St. Peters Mission Hospital	\N	\N	4
825	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/vGKeDpIYJOG	Muparadze Clinic	\N	\N	4
826	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/W0Ppo7ae6a9	Mahenye Clinic	\N	\N	4
827	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/W9p1h4w64te	Mutandahwe Clinic	\N	\N	4
828	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/W9ZONCEDDsl	Chisuma Clinic	\N	\N	4
829	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/XPMMDcY8BuB	Chinyamukwaka Clinic	\N	\N	4
830	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/xvTQ8nB5Mvj	Madhuka Rural Health Centre	\N	\N	4
831	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/y2zdUiQO4He	Mutema Clinic	\N	\N	4
832	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/Y7iKPeu2gzq	New Year Gift Clinic	\N	\N	4
833	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/YETAaWuPz4X	Tuzuka Rural Health Centre	\N	\N	4
834	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/Z3mLXNOy7eM	Chipinge Town Clinic	\N	\N	4
835	/Z9zOAr1dQ8K/ngqYrheLIDD/ZBDSjKKpYBc/ZCIZz6WLNmo	ARDA Estates Clinic	\N	\N	4
836	/Z9zOAr1dQ8K/S9JaZTjqDf0	Mashonaland Central	\N	\N	2
837	/Z9zOAr1dQ8K/S9JaZTjqDf0/IqKdDLmC19q	Centenary 	\N	\N	3
838	/Z9zOAr1dQ8K/S9JaZTjqDf0/VipQY4RTgL8	Mazowe 	\N	\N	3
839	/Z9zOAr1dQ8K/Swcfysry1GK	Masvingo	\N	\N	2
840	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5	Zaka	\N	\N	3
841	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/Dsxy9OYWGra	Mushaya Clinic	\N	\N	4
842	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/dVYZfmaQlZu	Gumbo Clinic	\N	\N	4
843	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/EJ8AWcWntZC	Ndanga Clinic	\N	\N	4
844	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/enmkxbYDcf1	Madhloro Clinic 	\N	\N	4
845	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/FIVfQy6uvyY	Jichidza Council Clinic	\N	\N	4
846	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/g9tFVjxzZDT	Veza Clinic	\N	\N	4
847	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/icfOvgEjvBc	Benzi Clinic	\N	\N	4
848	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/ifRp2NyE9bf	Fuve Clinic	\N	\N	4
849	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/IZd8YJZuStE	Siyawareva Clinic	\N	\N	4
850	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/j242MePofT5	Mageza Rural Health Centre	\N	\N	4
851	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/JAnao9byjMH	Nhema Clinic	\N	\N	4
852	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/JmCXC6C7rrq	Njiva Clinic 	\N	\N	4
853	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/ky8LXqc6FT7	Njiva Clinic	\N	\N	4
854	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/lV9XsdZFQJO	Machiva Clinic	\N	\N	4
855	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/m1d3Az0zvDK	Chiredzana Clinic	\N	\N	4
856	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/mJ9eUB3If4W	Musiso Mission Hospital	\N	\N	4
857	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/MN5sIO2VqYH	Jichidza Mission Clinic	\N	\N	4
858	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/Ns9TN1yfjMZ	Bota Clinic	\N	\N	4
859	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/pkT7Hpy8KXy	Machiva Clinic 	\N	\N	4
860	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/PMfFMZIrZm5	Jerera Satelite Clinic	\N	\N	4
861	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/s0NGujuznMj	Harava Rural Health Centre	\N	\N	4
862	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/S6noqN7rl9N	Bvukururu Clinic	\N	\N	4
863	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/TnFsY7jz1e9	Nyakunhuwa Clinic	\N	\N	4
864	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/uilLHWBmgKT	Mandhloro Clinic	\N	\N	4
865	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/UjPKTFDVqUE	Chipinda Rural Health Centre	\N	\N	4
866	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/USZm9peQXTh	Svuvure Rural Health Hospital	\N	\N	4
867	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/uuD4wwSkIeT	Chinyabako Clinic	\N	\N	4
868	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/VTBMaKUuMpQ	Murerekwa Clinic	\N	\N	4
869	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/w4buke8xk7w	Zibwowa Private Clinic	\N	\N	4
870	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/WGJRn7abY4N	Nemauku Clinic	\N	\N	4
871	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/Z5J3cdh6yMb	Zinguwo Clinic	\N	\N	4
872	/Z9zOAr1dQ8K/Swcfysry1GK/cmSn9zK9Tn5/ZlQRjkoXG9b	Ndanga Hospital	\N	\N	4
873	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R	Bikita	\N	\N	3
874	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/crSUbi6i5F5	Gava Rural Health Centre	\N	\N	4
875	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/eyzAFcfSQEX	Mkanga Rural Hospital	\N	\N	4
876	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/fo8DmvW4GD4	Bikita Minerals Clinic	\N	\N	4
877	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/G5jQ0PgLBmE	Nyika Rural Health Centre	\N	\N	4
878	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/i9PX3wtF6cy	Muvava Satelite Clinic	\N	\N	4
879	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/iSsPDmuYqMy	Marozva Clinic	\N	\N	4
880	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/j70GjIlGs0j	Pfupajena Clinic	\N	\N	4
881	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/jTHXPdvfmvE	Gangare Rural Health Centre	\N	\N	4
882	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/M3fHp1fXm4C	Hozvi Clinic	\N	\N	4
883	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/NaO74LLddM5	Chitasa Clinic	\N	\N	4
884	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/NUbvkDjF8gR	Chikuku Clinic	\N	\N	4
885	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/O3syMqZH5bx	Bikita Epi Mobile	\N	\N	4
886	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/ObJD78iiFpH	Deure II Clinic	\N	\N	4
887	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/oKF4ghEdf2q	Ngorima Clinic	\N	\N	4
888	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/P7RIEu3l0cg	Odzi Rural Hospital	\N	\N	4
889	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/rkqZQFjc9on	Murwira Clinic	\N	\N	4
890	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/RRoxTlWt5OO	Mashoko Hospital	\N	\N	4
891	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/sk68oHctZOt	ZRP Bikita Clinic	\N	\N	4
892	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/SsH6OoS1V9b	Bikita Rural Hospital	\N	\N	4
893	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/steehc0leFc	Masarasa Clinic	\N	\N	4
894	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/SVnZJjfH3bd	Mungezi Rural Health Centre	\N	\N	4
895	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/v3oBPHTfkPf	Silveira Mission Hospital	\N	\N	4
896	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/v49gHHSg0ql	Mandara Clinic	\N	\N	4
897	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/w2OET5yQcEH	Mutikizizi Rural Health Centre	\N	\N	4
898	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/WImVX85YsWu	Ruponeso Clinic	\N	\N	4
899	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/WKvlACWxQJa	Mukore Rural Health Centre	\N	\N	4
900	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/x6KqZuVLib1	Odzi Clinic	\N	\N	4
901	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/y1AymbEJYoE	Devure 1 Clinic	\N	\N	4
902	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/YQpWsAxwrFd	Chirorwe Clinic	\N	\N	4
903	/Z9zOAr1dQ8K/Swcfysry1GK/dMQxp7sPj1R/zygIXPCfI2m	Negovano Rural Health Centre	\N	\N	4
904	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4	Mwenezi	\N	\N	3
905	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/AarDXWOHk2L	Munyamani Rural Health Centre 	\N	\N	4
906	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/AfnXx27tQ4L	Mwenezi Council Clinic 	\N	\N	4
907	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/bA0TiXkTzDI	Chimbudzi Clinic	\N	\N	4
908	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/cryqOuYCTo9	Mazetese Clinic	\N	\N	4
909	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/eNq2hEBUbBx	Mwenezana Clinic	\N	\N	4
910	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/fil4aqGSpkM	Chizumba Clinic	\N	\N	4
911	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/gkGXl8Nh29p	Manyuchi Clinic2	\N	\N	4
912	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/GUyrKhGPkmB	Chingwizi Satelite Clinic	\N	\N	4
913	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/iBtiSFIva5U	Murove Clinic	\N	\N	4
914	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/ihx0kEPhDMu	Munyamani Clinic	\N	\N	4
915	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/JwYM3bMuGN8	Manyuchi Clinic	\N	\N	4
916	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/KaZSdnHLBYC	Munyamani Rural Health Centre	\N	\N	4
917	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/KGODrJyUU0d	Chirindi Clinic	\N	\N	4
918	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/KSeMcOy1Blg	Rutenga Clinic	\N	\N	4
919	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/L1NXyIXr4Xi	Neshuro District Hospital	\N	\N	4
920	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/mtHydPyChpG	Maranda Sub-Clinic	\N	\N	4
921	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/nNRxlONErnx	Mwenezi Council Clinic	\N	\N	4
922	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/NWTeFnEAJnq	Petronella Rural Health Centre 	\N	\N	4
923	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/OEtit4CZpza	Mwenezana Clinic 	\N	\N	4
924	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/QawCcirF9wM	Maryvale Rural Health Centre	\N	\N	4
925	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/QqmegtpUcnx	Maranda Mission Hospital	\N	\N	4
926	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/rGj6vwocIr0	Matibi Mission Hospital	\N	\N	4
927	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/RrnkwgdtPCM	Ruzambu Clinic	\N	\N	4
928	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/RutCBJv2FDw	Bubi River Ranch Clinic	\N	\N	4
929	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/Sd1voKwxJhS	Mushava Clinic	\N	\N	4
930	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/t2cfj97U17r	Mwenezi Council Clinic	\N	\N	4
931	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/twnngm080PW	Mwenezi Council Clinic 	\N	\N	4
932	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/U6uRzVh0RSW	NRZ Clinic	\N	\N	4
933	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/uZxyGTs0zwb	Lundi Clinic	\N	\N	4
934	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/VQBNHdBY781	Mulelesi Clinic	\N	\N	4
935	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/XIv6Q7a9F0J	Boterere Rural Health Centre	\N	\N	4
936	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/XJsvcIzmT1E	Rutenga Railways Clinic	\N	\N	4
937	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/xXvAFa6LVPB	G&N Clinic Clinic	\N	\N	4
938	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/YY58oZC8vq5	Marinda Rural Health Centre	\N	\N	4
939	/Z9zOAr1dQ8K/Swcfysry1GK/iTHhUYtNnL4/yzw2HRX9Prn	Nehanda Clinic	\N	\N	4
940	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF	Masvingo	\N	\N	3
941	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/AMIatgPm3xb	Stanmore Rural Health Centre	\N	\N	4
942	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/AUU2Za6iKUr	Mukosi Clinic	\N	\N	4
943	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/baRAS8w9gmR	Summerton Clinic	\N	\N	4
944	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/bfcqsUA785y	Zvamahande Rural Health Centre	\N	\N	4
945	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/bGVZqTZYySb	Mushandike Clinic	\N	\N	4
946	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/BQphG56vN2b	Zimuto Clinic	\N	\N	4
947	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/BYmITScQJL8	Nemwanwa Clinic	\N	\N	4
948	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/DthvHWxwhl8	Chatikobo Clinic	\N	\N	4
949	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/epPROUCXfAX	Rukovo Clinic	\N	\N	4
950	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/EQMIsSwYCJE	Nyikavanhu Rural Health Centre	\N	\N	4
951	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/FUoqhbrAxqB	Bere Clinic	\N	\N	4
952	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/gEEJqV8kQoU	Ngomahuru Psychiatric Hospital 	\N	\N	4
953	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/Hc4fFQhQIgR	Hwendedzo Clinic	\N	\N	4
954	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/hIQLu7ZOrfq	Gundura Clinic	\N	\N	4
955	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/HyiupeyROhN	Gaths Mine Hospital	\N	\N	4
956	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/j0Sp4T1CCZR	Runyararo Clinic	\N	\N	4
957	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/J4lnaGjZpej	Mogenester Mission Hospital	\N	\N	4
958	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/Ktj9CxKCM5h	Shonganiso Clinic	\N	\N	4
959	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/l3E01g797F0	Zimuto BC Clinic	\N	\N	4
960	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/mAVZzsETxl1	4.1 Barracks Camp Hospital	\N	\N	4
961	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/O7ozICEgzWS	Ngomahuru Rural Health Centre	\N	\N	4
962	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/Oqk09GQNE6K	Gurajena Hospital	\N	\N	4
963	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/OwDR7D9U5Iq	Masvingo General Hospital	\N	\N	4
964	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/P6v8ImHzR3c	Shumba Clinic	\N	\N	4
965	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/PPyDaHmqOoL	Mucheke Clinic	\N	\N	4
966	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/qU8ZCeQVNaR	Renco Mine Clinic	\N	\N	4
967	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/qWZgejuypcm	Musvovi Clinic	\N	\N	4
968	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/RPaFuf61WaI	Zano Clinic	\N	\N	4
969	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/RTubzXUovqL	Nyajena Rural Hospital	\N	\N	4
970	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/shU0JKeINLz	Bondolfi Rural Hospital	\N	\N	4
971	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/sRPZyqImKVc	PSG Renco clinic Mine Clinic	\N	\N	4
972	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/swgwGmtq9YH	Guwa Clinic	\N	\N	4
973	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/TmpVq0GSnlG	Charumbira Clinic	\N	\N	4
974	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/uYEnUHn5H1C	Murinye Clinic	\N	\N	4
975	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/v5kcc0wO1Rj	Nyamande Clinic	\N	\N	4
976	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/VgXt1sUEhBq	Alvod Clinic	\N	\N	4
977	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/VKwux4TM7D1	Mavizhu Clinic	\N	\N	4
978	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/vQIAHTp5Tc7	Gokomere Clinic	\N	\N	4
979	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/vTuEqoISlEa	Runyararo South West Council Clinic	\N	\N	4
980	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/wQ9HjnprvIf	Rujeko Clinic	\N	\N	4
981	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/Xr97xbx0yb9	Zimuto Mission Hospital	\N	\N	4
982	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/ycRz5OfK66h	Chisase Clinic	\N	\N	4
983	/Z9zOAr1dQ8K/Swcfysry1GK/UrkEr9fULhF/yPQXMrWCQ8C	Mapanzure Clinic	\N	\N	4
984	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE	Chiredzi	\N	\N	3
985	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/Ah71A5p6U9l	Chambuta Clinic	\N	\N	4
986	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/bUgKeujjHs0	Mkwasine Clinic	\N	\N	4
987	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/bYajIrtO7BJ	Gudo Clinic	\N	\N	4
988	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/c4XotWaksY0	Chizvirizvi Clinic	\N	\N	4
989	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/cnqg74tvFv1	Chiredzi Hospital	\N	\N	4
990	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/ezd2O5cLGKR	Chikombedzi Hospital	\N	\N	4
991	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/fHlFvOJjEZa	Faversham Clinic	\N	\N	4
992	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/FZFi6UbvoAK	Gezani Clinic	\N	\N	4
993	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/g7P5iJOCBdW	Tsovani Clinic	\N	\N	4
994	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/Gve7jwYBtm7	Masivamele SDA Clinic	\N	\N	4
995	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/HeZbUZjnuhb	Pahlela Clinic	\N	\N	4
996	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/ITtrofNJXsa	Rutandare Clinic	\N	\N	4
997	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/jRF48ebIi8o	Dumisa Clinic	\N	\N	4
998	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/JSfdVXhCx93	Triangle New Start Centre/New Life Cent 	\N	\N	4
999	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/kOc9rm7UnpQ	Chilonga Clinic	\N	\N	4
1000	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/kp1ChvzDVdl	Chimbwedziva Clinic	\N	\N	4
1001	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/lgDPtblnWoX	Chipiwa Clinic	\N	\N	4
1002	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/mAFrIy4VwQg	Chiredzi New Start Centre/New Life Centre	\N	\N	4
1003	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/olto9KrCczo	Neromwe Clinic	\N	\N	4
1004	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/pjRsLtIEfFO	Turkey Heart Clinic	\N	\N	4
1005	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/pnbUOG9jvyE	Malipati Rural Health Centre	\N	\N	4
1006	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/ps6ALhKY4N1	Old Boli Clinic	\N	\N	4
1007	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/PwO2lU5SrxH	Rusununguko Clinic	\N	\N	4
1008	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/q3b5EkPCQLi	St. Joseph Clinic	\N	\N	4
1009	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/Q3ugvdCRvpY	Chingele Clinic	\N	\N	4
1010	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/qFUR51Ms9q0	Chiredzi New Start Centre/New Life Cent 	\N	\N	4
1011	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/qvDZsNpDxFc	Nyangambe Clinic	\N	\N	4
1012	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/rBSC8oca3nk	Makambe Clinic	\N	\N	4
1013	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/sbkQMAzfGDC	Chikwirire Clinic	\N	\N	4
1014	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/swOU5pflWXo	Chiredzi ZSA Clinic 	\N	\N	4
1015	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/T5GUOFScrzV	Mahlanguleni Clinic	\N	\N	4
1016	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/TWQYlcVIUbh	Davata Clinic	\N	\N	4
1017	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/u33AB2pSZpc	Colin Saunders Hospital1	\N	\N	4
1018	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/u5Jvb683DTu	Matedzi Clinic	\N	\N	4
1019	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/uh35NSt2dAR	Rapanguwana Clinic	\N	\N	4
1020	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/UM1EEsLNksq	Hippo Valley Clinic	\N	\N	4
1021	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/uQ25d2VfGtd	Porepore Clinic	\N	\N	4
1022	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/UxHXfAoScYm	Sango Health Post	\N	\N	4
1023	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/V7g1YWWJjww	Chomopani Clinic	\N	\N	4
1024	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/waM3lzKr2NR	Colin Saunders Hospital	\N	\N	4
1025	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/X2s4IkAsMAk	Crown Range Clinic	\N	\N	4
1026	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/YCwmksrQv9l	Muteyo Clinic	\N	\N	4
1027	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/YZNLtCPMaHT	Samu Clinic	\N	\N	4
1028	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/Z2jeuNuhkJQ	Chitsa Clinic	\N	\N	4
1029	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/zEztqtVfvls	Damarakanaka Clinic	\N	\N	4
1030	/Z9zOAr1dQ8K/Swcfysry1GK/XvbYZilN1PE/zxqlLRCxD3M	Gwaseche Clinic 	\N	\N	4
1031	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz	Chivi	\N	\N	3
1032	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/aGhPTFxnILJ	Davira Clinic	\N	\N	4
1033	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/BbcsNsBiQJM	Chivi Rural Hospital	\N	\N	4
1034	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/d507u4dhfug	Mhandamabwe Rural Health Centre	\N	\N	4
1035	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/d7ci3o1HtZD	Chasiyatende Clinic	\N	\N	4
1036	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/hqEu71WoaVR	Chifedza Clinic	\N	\N	4
1037	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/HT2y1s8pLHX	Masinire Clinic	\N	\N	4
1038	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/IwB4D1rHsl6	Madamombe Rural Health Centre	\N	\N	4
1039	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/laeJBf3k7tI	Chivi District Hospital	\N	\N	4
1040	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/LnBI34VkdXc	Utete Clinic	\N	\N	4
1041	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/n4tZ9FiLuGP	Razi Rural Health Centre	\N	\N	4
1042	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/PwTUs91whQ3	Chirongwe Clinic	\N	\N	4
1043	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/qlF46STsFVq	Ziviku Clinic	\N	\N	4
1044	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/t0FJDGAu6fL	Chidyamakono Clinic	\N	\N	4
1045	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/TEsXYdnUcfu	Ngundu Rural Health Centre	\N	\N	4
1046	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/TKcNzGxZmGw	Berejena Mission Clinic	\N	\N	4
1047	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/tnAAI1FRv9X	Takavarasha Rural Health Centre	\N	\N	4
1048	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/uCEsnsec9SL	Chigwikwi Rural Health Centre	\N	\N	4
1049	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/ujZ2RN5rk6c	Gororo Clinic	\N	\N	4
1050	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/Wvse2gr2oTW	Nyahombe Clinic	\N	\N	4
1051	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/x6Odi9BQi29	Varanda Rural Health Centre	\N	\N	4
1052	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/XxCEgT27X8h	Madzivadondo Clinic	\N	\N	4
1053	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/ZjbT0mVOxhT	Shindi Clinic	\N	\N	4
1054	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/ZPy0zZuQJHc	Chivi Mission Clinic	\N	\N	4
1055	/Z9zOAr1dQ8K/Swcfysry1GK/YrreUKmRZTz/zW00y6AUxdv	Bwanya Clinic	\N	\N	4
1056	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI	Gutu	\N	\N	3
1057	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/AGkV135CYcT	Mazura Clinic	\N	\N	4
1058	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/bNtcLJVMOwP	Magombedze Chitsa Rural Health Centre	\N	\N	4
1059	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/BqwYIsKviQT	Mutero Rural Health Centre 	\N	\N	4
1060	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/BXwx8ekYJ5Z	Cheshuro Clinic	\N	\N	4
1061	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/CSJhvKnvviY	Nyazvidzi Clinic	\N	\N	4
1062	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/D5ZtSR2xBki	Chipiri Clinic	\N	\N	4
1063	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/diROooYxyaE	Zvavahera Clinic	\N	\N	4
1064	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/E2KrijxLbKp	Denhere Clinic	\N	\N	4
1065	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/gQu3bUzI3bn	Chinyika Rural Health Centre	\N	\N	4
1066	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/hhrSCqMznTy	Gutu Rural Clinic	\N	\N	4
1067	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/iDHtR8nseVL	Chitsa Rural Health Centre	\N	\N	4
1068	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/jXnqxdI0Xk4	Magombedze Clinic	\N	\N	4
1069	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/kaYiMIvMi6q	Chimombe Rural Hospital	\N	\N	4
1070	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/LaR6odJIgbC	Mutema Clinic	\N	\N	4
1071	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/lMPbb0M4NRu	Gutu Mission Hospital	\N	\N	4
1072	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/lO6DFAvjICL	Chitando Rural Health Centre	\N	\N	4
1073	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/onzEz7OrfEc	Matizha Clinic	\N	\N	4
1074	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/oPm3qJ83j76	Guni Clinic	\N	\N	4
1075	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/oqJB2RrFjGD	Chiwore Clinic	\N	\N	4
1076	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/rAsVeklMvZ9	Mutero Mission Clinic	\N	\N	4
1079	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/TIc3xF352lD	Muchekayaora Clinic	\N	\N	4
1080	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/tJksCYMUYHm	Mushaviri Clinic	\N	\N	4
1081	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/TzcYG8P3r5t	Serima Mission Hospital	\N	\N	4
1082	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/vJvZoHHCXoL	Nemashakwe Clinic	\N	\N	4
1083	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/VYPAMdNSEQf	Devure Mission Clinic	\N	\N	4
1084	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/whCKffBHhqi	Soti Source Clinic	\N	\N	4
1085	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/WXuXiKIOPTi	Mataruse Clinic	\N	\N	4
1086	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/xaCB2mHuw5r	Mukaro Mission Clinic	\N	\N	4
1087	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/xclPYKg6TTi	Munyikwa Rural Health Centre	\N	\N	4
1088	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/ys2RKCMd2KW	Majarada Rural Health Centre	\N	\N	4
1089	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/zDO70UxzQ52	Chepiri Clinic	\N	\N	4
1090	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/zlK0QVfBy4S	Zinhata Clinic	\N	\N	4
1091	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/zwiSn9vDwc6	Matomuse clinic	\N	\N	4
1092	/Z9zOAr1dQ8K/WJLP1MSmiS7	Harare	\N	\N	2
1093	/Z9zOAr1dQ8K/WJLP1MSmiS7/f0hCCPTK8WJ	Chitungwiza	\N	\N	3
1094	/Z9zOAr1dQ8K/WJLP1MSmiS7/f0hCCPTK8WJ/cswicu2amtm	Seke South Clinic	\N	\N	4
1095	/Z9zOAr1dQ8K/WJLP1MSmiS7/f0hCCPTK8WJ/dgPACqSJZIT	Zengeza Clinic Council Clinic	\N	\N	4
1096	/Z9zOAr1dQ8K/WJLP1MSmiS7/f0hCCPTK8WJ/Ev5Zpi0xxRx	Chitungwiza General Hospital	\N	\N	4
1097	/Z9zOAr1dQ8K/WJLP1MSmiS7/f0hCCPTK8WJ/iapmQ1i1Z6B	Chitungwiza Central Hospital 045]	\N	\N	4
1098	/Z9zOAr1dQ8K/WJLP1MSmiS7/f0hCCPTK8WJ/oSAzHWDLSzY	Zengeza 3 Clinic	\N	\N	4
1099	/Z9zOAr1dQ8K/WJLP1MSmiS7/f0hCCPTK8WJ/xjDifmwK0wG	Seke North Clinic	\N	\N	4
1100	/Z9zOAr1dQ8K/WJLP1MSmiS7/f0hCCPTK8WJ/z5w07xHWxPG	St. Marys Clinic	\N	\N	4
1101	/Z9zOAr1dQ8K/WJLP1MSmiS7/vpP5EC4QmhK	Harare	\N	\N	3
1102	/Z9zOAr1dQ8K/WJLP1MSmiS7/vpP5EC4QmhK/JoPZPhpHoo1	West End Hospital 	\N	\N	4
59	/Z9zOAr1dQ8K/kUS61oPWPF9/E6B1ltaZQm3/XDYoiA4av89	Dulibadzimu Satelite Clinic	\N	\N	4
554	/Z9zOAr1dQ8K/ngqYrheLIDD/MMEL64OWUht/arab3YkysoL	Mavhiza Clinic	\N	\N	4
1077	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/RxO8k3zae2W	Tirizi Clinic	\N	\N	4
1078	/Z9zOAr1dQ8K/Swcfysry1GK/YXXZ4CkOzvI/TBPY2CXSDF6	Dambara Clinic	\N	\N	4
\.


--
-- TOC entry 3839 (class 0 OID 466627)
-- Dependencies: 249
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (id, supplier_name) FROM stdin;
1	Liquid
11	Solution Centre
12	OPHID (Other Pjcts)
13	Byco
14	Flexline Investments
15	Rockright Traders
16	Pineland Technology
17	Baldon Furniture (Pvt) Ltd
18	Office Life/ Teecherz Furniture
19	Power Seven Investments
20	First Pack
21	Mistridge Office Systems (Pvt) Ltd
22	Ok Mart
23	Sai Systems
24	Jj Shopfitters
25	Chair Crazy
26	Indiewealth Investments
27	Innet Technologies
28	Mupray Investment
29	Kdb Holdings
30	Toyota Zimbabwe
31	Electrosales
32	Planet Holdings
33	Rockright Traders (Other Projects)
34	Innovative Technologies Pvt Ltd
35	Mike Harris Toyota
36	Donfoss
37	Wem Harmburg
38	Croco Motors
39	Tv Sales & Home
40	Litacon Investments
41	Nashua
42	Unihold Investments
43	Mistridge
44	Innovative Technologies (Overheads)
45	Atom Systems Pvt Ltd
46	The Copier Parts
47	First Pack Services (Other Pjcts)
48	Elishmax Enterprises
49	Oramark Enterprise
50	Daeta International
51	Vertice Healthcare
52	Earth-Kind Enterprises
53	Kingsport Investments
54	Blutek Generators Sales & Services
55	Heinz Tuabe Electronics
56	Heylinks Africa
57	Elite Collection
58	Laptops Direct (Tasqc)
59	Allied Safe
60	Uniglobe Zimbabwe
61	Real Sounds
62	Indiewealth (Other Pjcts)
63	Aquacoolers
64	Aquacoolers (Overheads)
65	Starlink
66	Honda Center Twenty Ten Pvt Ltd
67	Currys Business
\.


--
-- TOC entry 3871 (class 0 OID 467092)
-- Dependencies: 281
-- Data for Name: updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.updates (id, notes, staff_id, seen, stamp) FROM stdin;
\.


--
-- TOC entry 3816 (class 0 OID 466466)
-- Dependencies: 226
-- Data for Name: verification_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.verification_types (id, name) FROM stdin;
1	Routine Verification
2	Adhoc Verification
3	Pre-Transfer/Issuance Verification
4	Disposal Verification
5	Other
\.


--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 217
-- Name: acquisition_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.acquisition_types_id_seq', 5, true);


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 237
-- Name: asset_brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_brands_id_seq', 68, true);


--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 276
-- Name: asset_disposals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_disposals_id_seq', 1, true);


--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 266
-- Name: asset_evaluations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_evaluations_id_seq', 1, true);


--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 268
-- Name: asset_incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_incidents_id_seq', 3, true);


--
-- TOC entry 3918 (class 0 OID 0)
-- Dependencies: 262
-- Name: asset_issuance_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_issuance_items_id_seq', 2422, true);


--
-- TOC entry 3919 (class 0 OID 0)
-- Dependencies: 260
-- Name: asset_issuances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_issuances_id_seq', 387, true);


--
-- TOC entry 3920 (class 0 OID 0)
-- Dependencies: 239
-- Name: asset_models_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_models_id_seq', 144, true);


--
-- TOC entry 3921 (class 0 OID 0)
-- Dependencies: 274
-- Name: asset_placements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_placements_id_seq', 1, false);


--
-- TOC entry 3922 (class 0 OID 0)
-- Dependencies: 252
-- Name: asset_registrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_registrations_id_seq', 197, true);


--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 272
-- Name: asset_request_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_request_items_id_seq', 2, true);


--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 270
-- Name: asset_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_requests_id_seq', 1, true);


--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 258
-- Name: asset_transfer_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_transfer_items_id_seq', 1881, true);


--
-- TOC entry 3926 (class 0 OID 0)
-- Dependencies: 256
-- Name: asset_transfers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_transfers_id_seq', 16, true);


--
-- TOC entry 3927 (class 0 OID 0)
-- Dependencies: 211
-- Name: asset_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_types_id_seq', 93, true);


--
-- TOC entry 3928 (class 0 OID 0)
-- Dependencies: 264
-- Name: asset_verifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.asset_verifications_id_seq', 1, true);


--
-- TOC entry 3929 (class 0 OID 0)
-- Dependencies: 213
-- Name: brand_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brand_types_id_seq', 18, true);


--
-- TOC entry 3930 (class 0 OID 0)
-- Dependencies: 221
-- Name: condition_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.condition_types_id_seq', 8, true);


--
-- TOC entry 3931 (class 0 OID 0)
-- Dependencies: 233
-- Name: disposal_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.disposal_types_id_seq', 6, true);


--
-- TOC entry 3932 (class 0 OID 0)
-- Dependencies: 223
-- Name: evaluation_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evaluation_types_id_seq', 6, true);


--
-- TOC entry 3933 (class 0 OID 0)
-- Dependencies: 278
-- Name: event_approvals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_approvals_id_seq', 1207, true);


--
-- TOC entry 3934 (class 0 OID 0)
-- Dependencies: 250
-- Name: event_register_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_register_id_seq', 606, true);


--
-- TOC entry 3935 (class 0 OID 0)
-- Dependencies: 227
-- Name: incident_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incident_types_id_seq', 7, true);


--
-- TOC entry 3936 (class 0 OID 0)
-- Dependencies: 215
-- Name: model_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.model_types_id_seq', 147, true);


--
-- TOC entry 3937 (class 0 OID 0)
-- Dependencies: 230
-- Name: placement_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.placement_types_id_seq', 5, true);


--
-- TOC entry 3938 (class 0 OID 0)
-- Dependencies: 246
-- Name: programs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.programs_id_seq', 13, true);


--
-- TOC entry 3939 (class 0 OID 0)
-- Dependencies: 219
-- Name: reference_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reference_types_id_seq', 5, true);


--
-- TOC entry 3940 (class 0 OID 0)
-- Dependencies: 254
-- Name: registered_assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registered_assets_id_seq', 2426, true);


--
-- TOC entry 3941 (class 0 OID 0)
-- Dependencies: 242
-- Name: staff_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_accounts_id_seq', 516, true);


--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 244
-- Name: staff_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_roles_id_seq', 527, true);


--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 235
-- Name: stations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stations_id_seq', 1106, true);


--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 248
-- Name: suppliers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.suppliers_id_seq', 67, true);


--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 280
-- Name: updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.updates_id_seq', 1, false);


--
-- TOC entry 3946 (class 0 OID 0)
-- Dependencies: 225
-- Name: verification_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.verification_types_id_seq', 5, true);


--
-- TOC entry 3457 (class 2606 OID 466437)
-- Name: acquisition_types acquisition_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acquisition_types
    ADD CONSTRAINT acquisition_types_name_key UNIQUE (name);


--
-- TOC entry 3459 (class 2606 OID 466435)
-- Name: acquisition_types acquisition_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acquisition_types
    ADD CONSTRAINT acquisition_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3489 (class 2606 OID 466505)
-- Name: approval_types approval_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_types
    ADD CONSTRAINT approval_types_name_key UNIQUE (name);


--
-- TOC entry 3491 (class 2606 OID 466503)
-- Name: approval_types approval_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.approval_types
    ADD CONSTRAINT approval_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3501 (class 2606 OID 466534)
-- Name: asset_brands asset_brands_asset_type_id_brand_type_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_brands
    ADD CONSTRAINT asset_brands_asset_type_id_brand_type_id_key UNIQUE (asset_type_id, brand_type_id);


--
-- TOC entry 3503 (class 2606 OID 466532)
-- Name: asset_brands asset_brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_brands
    ADD CONSTRAINT asset_brands_pkey PRIMARY KEY (id);


--
-- TOC entry 3583 (class 2606 OID 467038)
-- Name: asset_disposals asset_disposals_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_disposals
    ADD CONSTRAINT asset_disposals_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3585 (class 2606 OID 467036)
-- Name: asset_disposals asset_disposals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_disposals
    ADD CONSTRAINT asset_disposals_pkey PRIMARY KEY (id);


--
-- TOC entry 3563 (class 2606 OID 466875)
-- Name: asset_evaluations asset_evaluations_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_evaluations
    ADD CONSTRAINT asset_evaluations_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3565 (class 2606 OID 466873)
-- Name: asset_evaluations asset_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_evaluations
    ADD CONSTRAINT asset_evaluations_pkey PRIMARY KEY (id);


--
-- TOC entry 3567 (class 2606 OID 466912)
-- Name: asset_incidents asset_incidents_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_incidents
    ADD CONSTRAINT asset_incidents_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3569 (class 2606 OID 466910)
-- Name: asset_incidents asset_incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_incidents
    ADD CONSTRAINT asset_incidents_pkey PRIMARY KEY (id);


--
-- TOC entry 3555 (class 2606 OID 466805)
-- Name: asset_issuance_items asset_issuance_items_asset_issuance_id_registered_asset_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuance_items
    ADD CONSTRAINT asset_issuance_items_asset_issuance_id_registered_asset_id_key UNIQUE (asset_issuance_id, registered_asset_id);


--
-- TOC entry 3557 (class 2606 OID 466803)
-- Name: asset_issuance_items asset_issuance_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuance_items
    ADD CONSTRAINT asset_issuance_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3551 (class 2606 OID 466776)
-- Name: asset_issuances asset_issuances_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuances
    ADD CONSTRAINT asset_issuances_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3553 (class 2606 OID 466774)
-- Name: asset_issuances asset_issuances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuances
    ADD CONSTRAINT asset_issuances_pkey PRIMARY KEY (id);


--
-- TOC entry 3505 (class 2606 OID 466553)
-- Name: asset_models asset_models_asset_brand_id_model_type_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_models
    ADD CONSTRAINT asset_models_asset_brand_id_model_type_id_key UNIQUE (asset_brand_id, model_type_id);


--
-- TOC entry 3507 (class 2606 OID 466551)
-- Name: asset_models asset_models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_models
    ADD CONSTRAINT asset_models_pkey PRIMARY KEY (id);


--
-- TOC entry 3579 (class 2606 OID 467001)
-- Name: asset_placements asset_placements_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_placements
    ADD CONSTRAINT asset_placements_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3581 (class 2606 OID 466999)
-- Name: asset_placements asset_placements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_placements
    ADD CONSTRAINT asset_placements_pkey PRIMARY KEY (id);


--
-- TOC entry 3533 (class 2606 OID 466653)
-- Name: asset_registrations asset_registrations_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3535 (class 2606 OID 466651)
-- Name: asset_registrations asset_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3575 (class 2606 OID 466979)
-- Name: asset_request_items asset_request_items_asset_request_id_requested_asset_type_i_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_request_items
    ADD CONSTRAINT asset_request_items_asset_request_id_requested_asset_type_i_key UNIQUE (asset_request_id, requested_asset_type_id);


--
-- TOC entry 3577 (class 2606 OID 466977)
-- Name: asset_request_items asset_request_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_request_items
    ADD CONSTRAINT asset_request_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3571 (class 2606 OID 466949)
-- Name: asset_requests asset_requests_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3573 (class 2606 OID 466947)
-- Name: asset_requests asset_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 3547 (class 2606 OID 466754)
-- Name: asset_transfer_items asset_transfer_items_asset_transfer_id_registered_asset_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfer_items
    ADD CONSTRAINT asset_transfer_items_asset_transfer_id_registered_asset_id_key UNIQUE (asset_transfer_id, registered_asset_id);


--
-- TOC entry 3549 (class 2606 OID 466752)
-- Name: asset_transfer_items asset_transfer_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfer_items
    ADD CONSTRAINT asset_transfer_items_pkey PRIMARY KEY (id);


--
-- TOC entry 3543 (class 2606 OID 466725)
-- Name: asset_transfers asset_transfers_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3545 (class 2606 OID 466723)
-- Name: asset_transfers asset_transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_pkey PRIMARY KEY (id);


--
-- TOC entry 3445 (class 2606 OID 466410)
-- Name: asset_types asset_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_types
    ADD CONSTRAINT asset_types_name_key UNIQUE (name);


--
-- TOC entry 3447 (class 2606 OID 466408)
-- Name: asset_types asset_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_types
    ADD CONSTRAINT asset_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3559 (class 2606 OID 466832)
-- Name: asset_verifications asset_verifications_event_register_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications
    ADD CONSTRAINT asset_verifications_event_register_id_key UNIQUE (event_register_id);


--
-- TOC entry 3561 (class 2606 OID 466830)
-- Name: asset_verifications asset_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications
    ADD CONSTRAINT asset_verifications_pkey PRIMARY KEY (id);


--
-- TOC entry 3449 (class 2606 OID 466419)
-- Name: brand_types brand_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand_types
    ADD CONSTRAINT brand_types_name_key UNIQUE (name);


--
-- TOC entry 3451 (class 2606 OID 466417)
-- Name: brand_types brand_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand_types
    ADD CONSTRAINT brand_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3465 (class 2606 OID 466455)
-- Name: condition_types condition_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condition_types
    ADD CONSTRAINT condition_types_name_key UNIQUE (name);


--
-- TOC entry 3467 (class 2606 OID 466453)
-- Name: condition_types condition_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.condition_types
    ADD CONSTRAINT condition_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3493 (class 2606 OID 466514)
-- Name: disposal_types disposal_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disposal_types
    ADD CONSTRAINT disposal_types_name_key UNIQUE (name);


--
-- TOC entry 3495 (class 2606 OID 466512)
-- Name: disposal_types disposal_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.disposal_types
    ADD CONSTRAINT disposal_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3469 (class 2606 OID 466464)
-- Name: evaluation_types evaluation_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_types
    ADD CONSTRAINT evaluation_types_name_key UNIQUE (name);


--
-- TOC entry 3471 (class 2606 OID 466462)
-- Name: evaluation_types evaluation_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_types
    ADD CONSTRAINT evaluation_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3587 (class 2606 OID 467075)
-- Name: event_approvals event_approvals_event_register_id_approval_type_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_approvals
    ADD CONSTRAINT event_approvals_event_register_id_approval_type_id_key UNIQUE (event_register_id, approval_type_id);


--
-- TOC entry 3589 (class 2606 OID 467073)
-- Name: event_approvals event_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_approvals
    ADD CONSTRAINT event_approvals_pkey PRIMARY KEY (id);


--
-- TOC entry 3531 (class 2606 OID 466641)
-- Name: event_register event_register_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_register
    ADD CONSTRAINT event_register_pkey PRIMARY KEY (id);


--
-- TOC entry 3477 (class 2606 OID 466482)
-- Name: incident_types incident_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_name_key UNIQUE (name);


--
-- TOC entry 3479 (class 2606 OID 466480)
-- Name: incident_types incident_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incident_types
    ADD CONSTRAINT incident_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3481 (class 2606 OID 466489)
-- Name: issuance_types issuance_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issuance_types
    ADD CONSTRAINT issuance_types_name_key UNIQUE (name);


--
-- TOC entry 3483 (class 2606 OID 466487)
-- Name: issuance_types issuance_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issuance_types
    ADD CONSTRAINT issuance_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3453 (class 2606 OID 466428)
-- Name: model_types model_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_types
    ADD CONSTRAINT model_types_name_key UNIQUE (name);


--
-- TOC entry 3455 (class 2606 OID 466426)
-- Name: model_types model_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.model_types
    ADD CONSTRAINT model_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3485 (class 2606 OID 466498)
-- Name: placement_types placement_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placement_types
    ADD CONSTRAINT placement_types_name_key UNIQUE (name);


--
-- TOC entry 3487 (class 2606 OID 466496)
-- Name: placement_types placement_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placement_types
    ADD CONSTRAINT placement_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3523 (class 2606 OID 466623)
-- Name: programs programs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- TOC entry 3525 (class 2606 OID 466625)
-- Name: programs programs_program_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_program_code_key UNIQUE (program_code);


--
-- TOC entry 3461 (class 2606 OID 466446)
-- Name: reference_types reference_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reference_types
    ADD CONSTRAINT reference_types_name_key UNIQUE (name);


--
-- TOC entry 3463 (class 2606 OID 466444)
-- Name: reference_types reference_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reference_types
    ADD CONSTRAINT reference_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3537 (class 2606 OID 466697)
-- Name: registered_assets registered_assets_asset_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registered_assets
    ADD CONSTRAINT registered_assets_asset_number_key UNIQUE (asset_number);


--
-- TOC entry 3539 (class 2606 OID 466693)
-- Name: registered_assets registered_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registered_assets
    ADD CONSTRAINT registered_assets_pkey PRIMARY KEY (id);


--
-- TOC entry 3541 (class 2606 OID 466695)
-- Name: registered_assets registered_assets_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registered_assets
    ADD CONSTRAINT registered_assets_serial_number_key UNIQUE (serial_number);


--
-- TOC entry 3441 (class 2606 OID 466401)
-- Name: role_types role_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_types
    ADD CONSTRAINT role_types_name_key UNIQUE (name);


--
-- TOC entry 3443 (class 2606 OID 466399)
-- Name: role_types role_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_types
    ADD CONSTRAINT role_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3515 (class 2606 OID 466583)
-- Name: staff_accounts staff_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_accounts
    ADD CONSTRAINT staff_accounts_pkey PRIMARY KEY (id);


--
-- TOC entry 3517 (class 2606 OID 466585)
-- Name: staff_accounts staff_accounts_staff_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_accounts
    ADD CONSTRAINT staff_accounts_staff_profile_id_key UNIQUE (staff_profile_id);


--
-- TOC entry 3509 (class 2606 OID 466570)
-- Name: staff_profiles staff_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_profiles
    ADD CONSTRAINT staff_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 3511 (class 2606 OID 466572)
-- Name: staff_profiles staff_profiles_staff_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_profiles
    ADD CONSTRAINT staff_profiles_staff_email_key UNIQUE (staff_email);


--
-- TOC entry 3513 (class 2606 OID 466574)
-- Name: staff_profiles staff_profiles_staff_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_profiles
    ADD CONSTRAINT staff_profiles_staff_phone_key UNIQUE (staff_phone);


--
-- TOC entry 3519 (class 2606 OID 466597)
-- Name: staff_roles staff_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_roles
    ADD CONSTRAINT staff_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3521 (class 2606 OID 466599)
-- Name: staff_roles staff_roles_staff_profile_id_role_type_id_role_station_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_roles
    ADD CONSTRAINT staff_roles_staff_profile_id_role_type_id_role_station_id_key UNIQUE (staff_profile_id, role_type_id, role_station_id);


--
-- TOC entry 3497 (class 2606 OID 466525)
-- Name: stations stations_hierarchy_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_hierarchy_code_key UNIQUE (station_code);


--
-- TOC entry 3499 (class 2606 OID 466523)
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- TOC entry 3527 (class 2606 OID 466632)
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- TOC entry 3529 (class 2606 OID 466634)
-- Name: suppliers suppliers_supplier_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_supplier_name_key UNIQUE (supplier_name);


--
-- TOC entry 3591 (class 2606 OID 467101)
-- Name: updates updates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.updates
    ADD CONSTRAINT updates_pkey PRIMARY KEY (id);


--
-- TOC entry 3473 (class 2606 OID 466473)
-- Name: verification_types verification_types_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_types
    ADD CONSTRAINT verification_types_name_key UNIQUE (name);


--
-- TOC entry 3475 (class 2606 OID 466471)
-- Name: verification_types verification_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.verification_types
    ADD CONSTRAINT verification_types_pkey PRIMARY KEY (id);


--
-- TOC entry 3592 (class 2606 OID 466535)
-- Name: asset_brands asset_brands_asset_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_brands
    ADD CONSTRAINT asset_brands_asset_type_id_fkey FOREIGN KEY (asset_type_id) REFERENCES public.asset_types(id);


--
-- TOC entry 3593 (class 2606 OID 466540)
-- Name: asset_brands asset_brands_brand_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_brands
    ADD CONSTRAINT asset_brands_brand_type_id_fkey FOREIGN KEY (brand_type_id) REFERENCES public.brand_types(id);


--
-- TOC entry 3650 (class 2606 OID 467044)
-- Name: asset_disposals asset_disposals_disposal_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_disposals
    ADD CONSTRAINT asset_disposals_disposal_type_id_fkey FOREIGN KEY (disposal_type_id) REFERENCES public.disposal_types(id);


--
-- TOC entry 3651 (class 2606 OID 467059)
-- Name: asset_disposals asset_disposals_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_disposals
    ADD CONSTRAINT asset_disposals_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3652 (class 2606 OID 467049)
-- Name: asset_disposals asset_disposals_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_disposals
    ADD CONSTRAINT asset_disposals_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3653 (class 2606 OID 467054)
-- Name: asset_disposals asset_disposals_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_disposals
    ADD CONSTRAINT asset_disposals_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3654 (class 2606 OID 467039)
-- Name: asset_disposals asset_disposals_registered_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_disposals
    ADD CONSTRAINT asset_disposals_registered_asset_id_fkey FOREIGN KEY (registered_asset_id) REFERENCES public.registered_assets(id);


--
-- TOC entry 3629 (class 2606 OID 466881)
-- Name: asset_evaluations asset_evaluations_evaluation_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_evaluations
    ADD CONSTRAINT asset_evaluations_evaluation_type_id_fkey FOREIGN KEY (evaluation_type_id) REFERENCES public.evaluation_types(id);


--
-- TOC entry 3630 (class 2606 OID 466896)
-- Name: asset_evaluations asset_evaluations_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_evaluations
    ADD CONSTRAINT asset_evaluations_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3631 (class 2606 OID 466886)
-- Name: asset_evaluations asset_evaluations_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_evaluations
    ADD CONSTRAINT asset_evaluations_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3632 (class 2606 OID 466891)
-- Name: asset_evaluations asset_evaluations_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_evaluations
    ADD CONSTRAINT asset_evaluations_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3633 (class 2606 OID 466876)
-- Name: asset_evaluations asset_evaluations_registered_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_evaluations
    ADD CONSTRAINT asset_evaluations_registered_asset_id_fkey FOREIGN KEY (registered_asset_id) REFERENCES public.registered_assets(id);


--
-- TOC entry 3634 (class 2606 OID 466933)
-- Name: asset_incidents asset_incidents_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_incidents
    ADD CONSTRAINT asset_incidents_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3635 (class 2606 OID 466923)
-- Name: asset_incidents asset_incidents_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_incidents
    ADD CONSTRAINT asset_incidents_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3636 (class 2606 OID 466928)
-- Name: asset_incidents asset_incidents_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_incidents
    ADD CONSTRAINT asset_incidents_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3637 (class 2606 OID 466918)
-- Name: asset_incidents asset_incidents_incident_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_incidents
    ADD CONSTRAINT asset_incidents_incident_type_id_fkey FOREIGN KEY (incident_type_id) REFERENCES public.incident_types(id);


--
-- TOC entry 3638 (class 2606 OID 466913)
-- Name: asset_incidents asset_incidents_registered_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_incidents
    ADD CONSTRAINT asset_incidents_registered_asset_id_fkey FOREIGN KEY (registered_asset_id) REFERENCES public.registered_assets(id);


--
-- TOC entry 3621 (class 2606 OID 466811)
-- Name: asset_issuance_items asset_issuance_items_asset_issuance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuance_items
    ADD CONSTRAINT asset_issuance_items_asset_issuance_id_fkey FOREIGN KEY (asset_issuance_id) REFERENCES public.asset_issuances(id);


--
-- TOC entry 3622 (class 2606 OID 466806)
-- Name: asset_issuance_items asset_issuance_items_registered_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuance_items
    ADD CONSTRAINT asset_issuance_items_registered_asset_id_fkey FOREIGN KEY (registered_asset_id) REFERENCES public.registered_assets(id);


--
-- TOC entry 3616 (class 2606 OID 466792)
-- Name: asset_issuances asset_issuances_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuances
    ADD CONSTRAINT asset_issuances_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3617 (class 2606 OID 466782)
-- Name: asset_issuances asset_issuances_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuances
    ADD CONSTRAINT asset_issuances_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3618 (class 2606 OID 466787)
-- Name: asset_issuances asset_issuances_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuances
    ADD CONSTRAINT asset_issuances_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3619 (class 2606 OID 490553)
-- Name: asset_issuances asset_issuances_issuance_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuances
    ADD CONSTRAINT asset_issuances_issuance_type_id_fkey FOREIGN KEY (issuance_type_id) REFERENCES public.issuance_types(id);


--
-- TOC entry 3620 (class 2606 OID 466777)
-- Name: asset_issuances asset_issuances_receiving_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_issuances
    ADD CONSTRAINT asset_issuances_receiving_staff_id_fkey FOREIGN KEY (receiving_staff_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3594 (class 2606 OID 466554)
-- Name: asset_models asset_models_asset_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_models
    ADD CONSTRAINT asset_models_asset_brand_id_fkey FOREIGN KEY (asset_brand_id) REFERENCES public.asset_brands(id);


--
-- TOC entry 3595 (class 2606 OID 466559)
-- Name: asset_models asset_models_model_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_models
    ADD CONSTRAINT asset_models_model_type_id_fkey FOREIGN KEY (model_type_id) REFERENCES public.model_types(id);


--
-- TOC entry 3645 (class 2606 OID 467022)
-- Name: asset_placements asset_placements_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_placements
    ADD CONSTRAINT asset_placements_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3646 (class 2606 OID 467012)
-- Name: asset_placements asset_placements_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_placements
    ADD CONSTRAINT asset_placements_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3647 (class 2606 OID 467017)
-- Name: asset_placements asset_placements_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_placements
    ADD CONSTRAINT asset_placements_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3648 (class 2606 OID 467007)
-- Name: asset_placements asset_placements_placement_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_placements
    ADD CONSTRAINT asset_placements_placement_type_id_fkey FOREIGN KEY (placement_type_id) REFERENCES public.placement_types(id);


--
-- TOC entry 3649 (class 2606 OID 467002)
-- Name: asset_placements asset_placements_registered_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_placements
    ADD CONSTRAINT asset_placements_registered_asset_id_fkey FOREIGN KEY (registered_asset_id) REFERENCES public.registered_assets(id);


--
-- TOC entry 3600 (class 2606 OID 466654)
-- Name: asset_registrations asset_registrations_acquisition_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_acquisition_type_id_fkey FOREIGN KEY (acquisition_type_id) REFERENCES public.acquisition_types(id);


--
-- TOC entry 3601 (class 2606 OID 466679)
-- Name: asset_registrations asset_registrations_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3602 (class 2606 OID 466669)
-- Name: asset_registrations asset_registrations_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3603 (class 2606 OID 466674)
-- Name: asset_registrations asset_registrations_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3604 (class 2606 OID 474134)
-- Name: asset_registrations asset_registrations_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id);


--
-- TOC entry 3605 (class 2606 OID 466659)
-- Name: asset_registrations asset_registrations_reference_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_reference_type_id_fkey FOREIGN KEY (reference_type_id) REFERENCES public.reference_types(id);


--
-- TOC entry 3606 (class 2606 OID 466664)
-- Name: asset_registrations asset_registrations_supplier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_registrations
    ADD CONSTRAINT asset_registrations_supplier_id_fkey FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id);


--
-- TOC entry 3643 (class 2606 OID 466980)
-- Name: asset_request_items asset_request_items_asset_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_request_items
    ADD CONSTRAINT asset_request_items_asset_request_id_fkey FOREIGN KEY (asset_request_id) REFERENCES public.asset_requests(id);


--
-- TOC entry 3644 (class 2606 OID 466985)
-- Name: asset_request_items asset_request_items_requested_asset_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_request_items
    ADD CONSTRAINT asset_request_items_requested_asset_type_id_fkey FOREIGN KEY (requested_asset_type_id) REFERENCES public.asset_types(id);


--
-- TOC entry 3639 (class 2606 OID 466965)
-- Name: asset_requests asset_requests_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3640 (class 2606 OID 466950)
-- Name: asset_requests asset_requests_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3641 (class 2606 OID 466960)
-- Name: asset_requests asset_requests_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3642 (class 2606 OID 466955)
-- Name: asset_requests asset_requests_request_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_requests
    ADD CONSTRAINT asset_requests_request_program_id_fkey FOREIGN KEY (request_program_id) REFERENCES public.programs(id);


--
-- TOC entry 3614 (class 2606 OID 466755)
-- Name: asset_transfer_items asset_transfer_items_asset_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfer_items
    ADD CONSTRAINT asset_transfer_items_asset_transfer_id_fkey FOREIGN KEY (asset_transfer_id) REFERENCES public.asset_transfers(id);


--
-- TOC entry 3615 (class 2606 OID 466760)
-- Name: asset_transfer_items asset_transfer_items_registered_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfer_items
    ADD CONSTRAINT asset_transfer_items_registered_asset_id_fkey FOREIGN KEY (registered_asset_id) REFERENCES public.registered_assets(id);


--
-- TOC entry 3610 (class 2606 OID 466741)
-- Name: asset_transfers asset_transfers_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3611 (class 2606 OID 466731)
-- Name: asset_transfers asset_transfers_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3612 (class 2606 OID 466736)
-- Name: asset_transfers asset_transfers_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3613 (class 2606 OID 466726)
-- Name: asset_transfers asset_transfers_receiving_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_transfers
    ADD CONSTRAINT asset_transfers_receiving_station_id_fkey FOREIGN KEY (receiving_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3623 (class 2606 OID 466858)
-- Name: asset_verifications asset_verifications_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications
    ADD CONSTRAINT asset_verifications_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3624 (class 2606 OID 466848)
-- Name: asset_verifications asset_verifications_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications
    ADD CONSTRAINT asset_verifications_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3625 (class 2606 OID 466853)
-- Name: asset_verifications asset_verifications_event_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications
    ADD CONSTRAINT asset_verifications_event_station_id_fkey FOREIGN KEY (event_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3626 (class 2606 OID 466833)
-- Name: asset_verifications asset_verifications_registered_asset_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications
    ADD CONSTRAINT asset_verifications_registered_asset_id_fkey FOREIGN KEY (registered_asset_id) REFERENCES public.registered_assets(id);


--
-- TOC entry 3627 (class 2606 OID 466838)
-- Name: asset_verifications asset_verifications_verification_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications
    ADD CONSTRAINT asset_verifications_verification_type_id_fkey FOREIGN KEY (verification_type_id) REFERENCES public.verification_types(id);


--
-- TOC entry 3628 (class 2606 OID 466843)
-- Name: asset_verifications asset_verifications_verified_condition_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.asset_verifications
    ADD CONSTRAINT asset_verifications_verified_condition_type_id_fkey FOREIGN KEY (verified_condition_type_id) REFERENCES public.condition_types(id);


--
-- TOC entry 3655 (class 2606 OID 467081)
-- Name: event_approvals event_approvals_approval_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_approvals
    ADD CONSTRAINT event_approvals_approval_type_id_fkey FOREIGN KEY (approval_type_id) REFERENCES public.approval_types(id);


--
-- TOC entry 3656 (class 2606 OID 467086)
-- Name: event_approvals event_approvals_event_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_approvals
    ADD CONSTRAINT event_approvals_event_admin_id_fkey FOREIGN KEY (event_admin_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3657 (class 2606 OID 467076)
-- Name: event_approvals event_approvals_event_register_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.event_approvals
    ADD CONSTRAINT event_approvals_event_register_id_fkey FOREIGN KEY (event_register_id) REFERENCES public.event_register(id);


--
-- TOC entry 3607 (class 2606 OID 466703)
-- Name: registered_assets registered_assets_asset_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registered_assets
    ADD CONSTRAINT registered_assets_asset_model_id_fkey FOREIGN KEY (asset_model_id) REFERENCES public.asset_models(id);


--
-- TOC entry 3608 (class 2606 OID 466698)
-- Name: registered_assets registered_assets_asset_registration_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registered_assets
    ADD CONSTRAINT registered_assets_asset_registration_id_fkey FOREIGN KEY (asset_registration_id) REFERENCES public.asset_registrations(id);


--
-- TOC entry 3609 (class 2606 OID 466708)
-- Name: registered_assets registered_assets_condition_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registered_assets
    ADD CONSTRAINT registered_assets_condition_type_id_fkey FOREIGN KEY (condition_type_id) REFERENCES public.condition_types(id);


--
-- TOC entry 3596 (class 2606 OID 466586)
-- Name: staff_accounts staff_accounts_staff_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_accounts
    ADD CONSTRAINT staff_accounts_staff_profile_id_fkey FOREIGN KEY (staff_profile_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3597 (class 2606 OID 466610)
-- Name: staff_roles staff_roles_role_station_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_roles
    ADD CONSTRAINT staff_roles_role_station_id_fkey FOREIGN KEY (role_station_id) REFERENCES public.stations(id);


--
-- TOC entry 3598 (class 2606 OID 466605)
-- Name: staff_roles staff_roles_role_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_roles
    ADD CONSTRAINT staff_roles_role_type_id_fkey FOREIGN KEY (role_type_id) REFERENCES public.role_types(id);


--
-- TOC entry 3599 (class 2606 OID 466600)
-- Name: staff_roles staff_roles_staff_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_roles
    ADD CONSTRAINT staff_roles_staff_profile_id_fkey FOREIGN KEY (staff_profile_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3658 (class 2606 OID 467102)
-- Name: updates updates_staff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.updates
    ADD CONSTRAINT updates_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES public.staff_profiles(id);


--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-07-25 09:41:02

--
-- PostgreSQL database dump complete
--

\unrestrict 8y62lZX8MmAoWBu1LPVaEMXEPQPgvw4cRffgLwWA2uIa3IfQ63pYAnulc6stxdX


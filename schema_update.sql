--
-- PostgreSQL database dump
--

\restrict PBq6jV6aBnqomhFxteY4SABaFL4M2X0RS8YsgPbeL7g0gAU2JmxIQo2NPb5xaie

-- Dumped from database version 14.17
-- Dumped by pg_dump version 17.6

-- Started on 2026-07-22 17:21:40

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
-- TOC entry 3806 (class 0 OID 0)
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
-- TOC entry 3807 (class 0 OID 0)
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
-- TOC entry 3808 (class 0 OID 0)
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
-- TOC entry 3809 (class 0 OID 0)
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
-- TOC entry 3810 (class 0 OID 0)
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
-- TOC entry 3811 (class 0 OID 0)
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
-- TOC entry 3812 (class 0 OID 0)
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
-- TOC entry 3813 (class 0 OID 0)
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
-- TOC entry 3814 (class 0 OID 0)
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
-- TOC entry 3815 (class 0 OID 0)
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
-- TOC entry 3816 (class 0 OID 0)
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
-- TOC entry 3817 (class 0 OID 0)
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
-- TOC entry 3818 (class 0 OID 0)
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
-- TOC entry 3819 (class 0 OID 0)
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
-- TOC entry 3820 (class 0 OID 0)
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
-- TOC entry 3821 (class 0 OID 0)
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
-- TOC entry 3822 (class 0 OID 0)
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
    longitude numeric(11,8)
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
-- TOC entry 3823 (class 0 OID 0)
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
-- TOC entry 3824 (class 0 OID 0)
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
-- TOC entry 3825 (class 0 OID 0)
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
-- TOC entry 3826 (class 0 OID 0)
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
-- TOC entry 3827 (class 0 OID 0)
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
-- TOC entry 3828 (class 0 OID 0)
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
-- TOC entry 3829 (class 0 OID 0)
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
-- TOC entry 3830 (class 0 OID 0)
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
-- TOC entry 3831 (class 0 OID 0)
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
-- TOC entry 3832 (class 0 OID 0)
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
-- TOC entry 3833 (class 0 OID 0)
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
-- TOC entry 3834 (class 0 OID 0)
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
-- TOC entry 3835 (class 0 OID 0)
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
-- TOC entry 3836 (class 0 OID 0)
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
-- TOC entry 3837 (class 0 OID 0)
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
-- TOC entry 3838 (class 0 OID 0)
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
-- TOC entry 3839 (class 0 OID 0)
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
-- TOC entry 3840 (class 0 OID 0)
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
-- TOC entry 3805 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2026-07-22 17:21:40

--
-- PostgreSQL database dump complete
--

\unrestrict PBq6jV6aBnqomhFxteY4SABaFL4M2X0RS8YsgPbeL7g0gAU2JmxIQo2NPb5xaie


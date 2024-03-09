--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

-- Started on 2024-02-05 15:39:35

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16384)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 218 (class 1259 OID 16448)
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    id text,
    vessel_id text,
    t timestamp(0) without time zone,
    lon double precision,
    lat double precision,
    heading integer,
    course double precision,
    speed double precision
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16943)
-- Name: positions_partitioned; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions_partitioned (
    CONSTRAINT positions_partitioned_t_check CHECK (((t > '2019-08-14 00:00:00'::timestamp without time zone) AND (t < '2019-08-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.positions);


ALTER TABLE public.positions_partitioned OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16962)
-- Name: positions_partitioned_2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions_partitioned_2 (
    CONSTRAINT positions_partitioned_2_speed_check CHECK ((speed = (0)::double precision)),
    CONSTRAINT positions_partitioned_2_t_check CHECK (((t > '2019-08-15 00:00:00'::timestamp without time zone) AND (t < '2019-08-19 00:00:00'::timestamp without time zone)))
)
INHERITS (public.positions);


ALTER TABLE public.positions_partitioned_2 OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16831)
-- Name: positions_partitioned_speed_high; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions_partitioned_speed_high (
    CONSTRAINT positions_partitioned_speed_high_speed_check CHECK ((speed > (30)::double precision))
)
INHERITS (public.positions);


ALTER TABLE public.positions_partitioned_speed_high OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16433)
-- Name: vessels; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vessels (
    id text NOT NULL,
    type integer,
    flag text
);


ALTER TABLE public.vessels OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16905)
-- Name: vessels_partitioned; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vessels_partitioned (
    CONSTRAINT vessels_partitioned_flag_check CHECK ((flag = 'Greece'::text))
)
INHERITS (public.vessels);


ALTER TABLE public.vessels_partitioned OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16441)
-- Name: vesseltypes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vesseltypes (
    code integer NOT NULL,
    description text
);


ALTER TABLE public.vesseltypes OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16937)
-- Name: vesseltypes_partitioned; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vesseltypes_partitioned (
    CONSTRAINT vesseltypes_partitioned_description_check CHECK ((description ~~ 'Passenger%'::text))
)
INHERITS (public.vesseltypes);


ALTER TABLE public.vesseltypes_partitioned OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16887)
-- Name: vesseltypes_partitioned_2; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vesseltypes_partitioned_2 (
    CONSTRAINT vesseltypes_partitioned_2_description_check CHECK ((description ~~ 'Cargo%'::text))
)
INHERITS (public.vesseltypes);


ALTER TABLE public.vesseltypes_partitioned_2 OWNER TO postgres;

--
-- TOC entry 4732 (class 2606 OID 16439)
-- Name: vessels vessels_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vessels
    ADD CONSTRAINT vessels_pkey PRIMARY KEY (id);


--
-- TOC entry 4734 (class 2606 OID 16447)
-- Name: vesseltypes vesseltypes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vesseltypes
    ADD CONSTRAINT vesseltypes_pkey PRIMARY KEY (code);


--
-- TOC entry 4727 (class 1259 OID 16612)
-- Name: idx_flag; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_flag ON public.vessels USING hash (flag);


--
-- TOC entry 4735 (class 1259 OID 16590)
-- Name: idx_positions_day; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_positions_day ON public.positions USING btree (date_trunc('day'::text, t));


--
-- TOC entry 4741 (class 1259 OID 16950)
-- Name: idx_positions_partitioned_t; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_positions_partitioned_t ON public.positions_partitioned USING btree (t);


--
-- TOC entry 4736 (class 1259 OID 16471)
-- Name: idx_positions_speed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_positions_speed ON public.positions USING btree (speed);


--
-- TOC entry 4737 (class 1259 OID 16469)
-- Name: idx_positions_t; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_positions_t ON public.positions USING btree (t);


--
-- TOC entry 4738 (class 1259 OID 16467)
-- Name: idx_time_speed; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_time_speed ON public.positions USING btree (t, speed);


--
-- TOC entry 4728 (class 1259 OID 16468)
-- Name: idx_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_type ON public.vessels USING btree (type);


--
-- TOC entry 4729 (class 1259 OID 16470)
-- Name: idx_vessel_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vessel_type ON public.vessels USING btree (type);


--
-- TOC entry 4730 (class 1259 OID 16472)
-- Name: idx_vessels_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vessels_id ON public.vessels USING btree (type);


--
-- TOC entry 4740 (class 1259 OID 16949)
-- Name: idx_vesseltypes_partitioned_description; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vesseltypes_partitioned_description ON public.vesseltypes_partitioned USING btree (description);


--
-- TOC entry 4739 (class 1259 OID 16894)
-- Name: idx_vesseltypes_partitioned_description2; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_vesseltypes_partitioned_description2 ON public.vesseltypes_partitioned_2 USING btree (description);


--
-- TOC entry 4742 (class 2606 OID 16462)
-- Name: vessels fk_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vessels
    ADD CONSTRAINT fk_type FOREIGN KEY (type) REFERENCES public.vesseltypes(code);


--
-- TOC entry 4743 (class 2606 OID 16457)
-- Name: positions fk_vessel; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT fk_vessel FOREIGN KEY (vessel_id) REFERENCES public.vessels(id);


-- Completed on 2024-02-05 15:39:35

--
-- PostgreSQL database dump complete
--


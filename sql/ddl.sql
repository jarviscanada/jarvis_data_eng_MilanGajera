--create host_info table
CREATE TABLE PUBLIC.host_info 
  ( 
     id               SERIAL PRIMARY KEY, 
     hostname         VARCHAR NOT NULL UNIQUE, 
     cpu_number       INT2 NOT NULL, 
     cpu_architecture VARCHAR NOT NULL, 
     cpu_model        VARCHAR NOT NULL, 
     cpu_mhz          FLOAT8 NOT NULL, 
     l2_cache         INT4 NOT NULL, 
     "timestamp"      TIMESTAMP NULL, 
     total_mem        INT4 NULL
  );

-- Insert sample data into host_info
INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, "timestamp", total_mem) 
VALUES
('jrvs-remote-desktop-centos7-6.us-central1-a.c.spry-framework-236416.internal', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, '2019-05-29 17:49:53.000', 601324),
('noe1', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, '2019-05-29 17:49:53.000', 601324),
('noe2', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, '2019-05-29 17:49:53.000', 601324);

-- Create host_usage table
CREATE TABLE PUBLIC.host_usage 
  ( 
     "timestamp"    TIMESTAMP NOT NULL, 
     host_id        INT NOT NULL, 
     memory_free    INT4 NOT NULL, 
     cpu_idle       INT2 NOT NULL, 
     cpu_kernel     INT2 NOT NULL, 
     disk_io        INT4 NOT NULL, 
     disk_available INT4 NOT NULL, 
     CONSTRAINT host_usage_pk PRIMARY KEY ("timestamp", host_id),
     CONSTRAINT host_usage_host_info_fk FOREIGN KEY (host_id) REFERENCES host_info(id) 
  );

-- Insert sample data into host_usage
INSERT INTO host_usage ("timestamp", host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available) 
VALUES
('2019-05-29 15:00:00.000', 1, 300000, 90, 4, 2, 3),
('2019-05-29 15:01:00.000', 1, 200000, 90, 4, 2, 3);

-- Verify inserted data in host_info
SELECT * FROM host_info;

-- Verify inserted data in host_usage
SELECT * FROM host_usage;


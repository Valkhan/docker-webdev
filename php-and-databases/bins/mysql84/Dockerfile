FROM mysql:8.4
RUN echo "[mysqld]" > /etc/my.cnf.d/custom.cnf
RUN echo "sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION" >> /etc/my.cnf.d/custom.cnf
RUN echo "max_allowed_packet=1G" >> /etc/my.cnf.d/custom.cnf
RUN echo "innodb_buffer_pool_size=10G" >> /etc/my.cnf.d/custom.cnf
RUN echo "innodb_log_file_size=1G" >> /etc/my.cnf.d/custom.cnf
RUN echo "innodb_io_capacity=2000" >> /etc/my.cnf.d/custom.cnf

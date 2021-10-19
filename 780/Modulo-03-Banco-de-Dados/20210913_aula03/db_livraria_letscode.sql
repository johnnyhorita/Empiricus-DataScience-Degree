
CREATE SEQUENCE public.autor_id_autor_seq;

CREATE TABLE public.Autor (
                id_autor INTEGER NOT NULL DEFAULT nextval('public.autor_id_autor_seq'),
                nm_autor VARCHAR(100) NOT NULL,
                CONSTRAINT pk_id_autor PRIMARY KEY (id_autor)
);
COMMENT ON TABLE public.Autor IS 'Informação de autor';


ALTER SEQUENCE public.autor_id_autor_seq OWNED BY public.Autor.id_autor;

CREATE UNIQUE INDEX iu01_autor
 ON public.Autor
 ( nm_autor );

CREATE SEQUENCE public.editora_id_editora_seq;

CREATE TABLE public.Editora (
                id_editora INTEGER NOT NULL DEFAULT nextval('public.editora_id_editora_seq'),
                nm_editora VARCHAR(255) NOT NULL,
                nm_contato_editora VARCHAR(100) NOT NULL,
                nr_tel1_editora INTEGER,
                nr_tel2_editora INTEGER,
                email_editora VARCHAR(50),
                CONSTRAINT pk_id_editora PRIMARY KEY (id_editora)
);
COMMENT ON TABLE public.Editora IS 'Informação da editora';


ALTER SEQUENCE public.editora_id_editora_seq OWNED BY public.Editora.id_editora;

CREATE SEQUENCE public.categoria_id_categoria_seq;

CREATE TABLE public.Categoria (
                id_categoria INTEGER NOT NULL DEFAULT nextval('public.categoria_id_categoria_seq'),
                nm_categoria VARCHAR(100) NOT NULL,
                CONSTRAINT pk_id_categoria PRIMARY KEY (id_categoria)
);
COMMENT ON TABLE public.Categoria IS 'Informação de categoria';


ALTER SEQUENCE public.categoria_id_categoria_seq OWNED BY public.Categoria.id_categoria;

CREATE UNIQUE INDEX iu01_categoria
 ON public.Categoria
 ( nm_categoria );

CREATE SEQUENCE public.livro_id_livro_seq;

CREATE TABLE public.Livro (
                id_livro INTEGER NOT NULL DEFAULT nextval('public.livro_id_livro_seq'),
                nm_livro VARCHAR(255) NOT NULL,
                id_editora INTEGER NOT NULL,
                id_categoria INTEGER NOT NULL,
                num_isbn_livro INTEGER NOT NULL,
                ano_pub_livro INTEGER NOT NULL,
                vlr_livro NUMERIC(10,2) NOT NULL,
                CONSTRAINT pk_id_livro PRIMARY KEY (id_livro)
);
COMMENT ON TABLE public.Livro IS 'Informação do livro';


ALTER SEQUENCE public.livro_id_livro_seq OWNED BY public.Livro.id_livro;

CREATE UNIQUE INDEX iu01_livro
 ON public.Livro
 ( num_isbn_livro );

CREATE INDEX ix02_livro
 ON public.Livro
 ( id_editora );

CREATE INDEX ix03_livro
 ON public.Livro
 ( id_categoria );

CREATE INDEX ix04_livro
 ON public.Livro
 ( nm_livro );

CREATE TABLE public.Autor_Livro (
                id_autor INTEGER NOT NULL,
                id_livro INTEGER NOT NULL,
                is_co_autor BOOLEAN NOT NULL,
                CONSTRAINT pk_autor_livro PRIMARY KEY (id_autor, id_livro)
);
COMMENT ON TABLE public.Autor_Livro IS 'Relacionamento dos autores que poblicaram os livros';


CREATE SEQUENCE public.cliente_id_cliente_seq;

CREATE TABLE public.Cliente (
                id_cliente INTEGER NOT NULL DEFAULT nextval('public.cliente_id_cliente_seq'),
                cpf_cli INTEGER NOT NULL,
                nm_cli VARCHAR(100) NOT NULL,
                end_cli VARCHAR(255),
                nr_tel_cli INTEGER,
                email_cli VARCHAR(50),
                CONSTRAINT pk_id_cliente PRIMARY KEY (id_cliente)
);
COMMENT ON TABLE public.Cliente IS 'Informação de cliente';


ALTER SEQUENCE public.cliente_id_cliente_seq OWNED BY public.Cliente.id_cliente;

CREATE UNIQUE INDEX iu01_cliente
 ON public.Cliente
 ( cpf_cli );

CREATE INDEX iu02_cliente
 ON public.Cliente
 ( nm_cli );

CREATE INDEX ix03_cliente
 ON public.Cliente
 ( nm_cli );

CREATE INDEX ix04_cliente
 ON public.Cliente
 ( cpf_cli );

CREATE SEQUENCE public.pedido_id_pedido_seq;

CREATE TABLE public.Pedido (
                id_pedido INTEGER NOT NULL DEFAULT nextval('public.pedido_id_pedido_seq'),
                id_cliente INTEGER NOT NULL,
                vlr_tot_pedido NUMERIC(10,2) NOT NULL,
                CONSTRAINT pk_id_pedido PRIMARY KEY (id_pedido)
);
COMMENT ON TABLE public.Pedido IS 'Informação de pedidos de compra de livros';


ALTER SEQUENCE public.pedido_id_pedido_seq OWNED BY public.Pedido.id_pedido;

CREATE INDEX ix01_pedido
 ON public.Pedido
 ( id_cliente );

CREATE TABLE public.Pedido_Item (
                id_pedido INTEGER NOT NULL,
                id_livro INTEGER NOT NULL,
                qtd_item INTEGER DEFAULT 1 NOT NULL,
                vlr_unit_item NUMERIC(10,2) NOT NULL,
                vlr_tot_item NUMERIC(10,2) NOT NULL,
                CONSTRAINT id_pedido_item PRIMARY KEY (id_pedido, id_livro)
);
COMMENT ON TABLE public.Pedido_Item IS 'Informação dos itens que fazem parte do pedido';


ALTER TABLE public.Autor_Livro ADD CONSTRAINT fk_autor_x_autor_livro
FOREIGN KEY (id_autor)
REFERENCES public.Autor (id_autor)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Livro ADD CONSTRAINT fk_editora_x_livro
FOREIGN KEY (id_editora)
REFERENCES public.Editora (id_editora)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Livro ADD CONSTRAINT fk_categoria_x_livro
FOREIGN KEY (id_categoria)
REFERENCES public.Categoria (id_categoria)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Pedido_Item ADD CONSTRAINT fk_livro_x_pedido_item
FOREIGN KEY (id_livro)
REFERENCES public.Livro (id_livro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Autor_Livro ADD CONSTRAINT fk_livro_x_autor_livro
FOREIGN KEY (id_livro)
REFERENCES public.Livro (id_livro)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Pedido ADD CONSTRAINT fk_cliente_x_pedido
FOREIGN KEY (id_cliente)
REFERENCES public.Cliente (id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.Pedido_Item ADD CONSTRAINT fk_pedido_x_pedido_item
FOREIGN KEY (id_pedido)
REFERENCES public.Pedido (id_pedido)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

create table users(
id INT NOT NULL AUTO_INCREMENT, 
birth DATE NOT NULL, 
gender enum('l','p') NOT NULL,
email varchar(100) UNIQUE NOT NULL, 
is_email_verified bool DEFAULT false, 
no_phone varchar(15) NOT NULL UNIQUE, 
is_no_phone_verified bool DEFAULT false, 
password varchar(100) NOT NULL, 
pin char(6), 
image_user varchar(25),
primary key (id)
) Engine=InnoDB;

create table addresses(
id int not null auto_increment,
id_user int not null,
label varchar(100) not null,
name_recipients varchar(100) not null,
no_phone varchar(15) not null,
city varchar(100) not null,
code_pos varchar(10) not null,
address text not null,
pin_location varchar(100),
primary key(id),
foreign key(id_user) 
references users(id)
) engine=InnoDB;

create table rekening_bank(
id int not null auto_increment,
id_user int not null,
name_bank varchar(100),
no_rekening varchar(100),
name varchar(100),
primary key (id),
foreign key (id_user)
references users(id)
) engine=InnoDB;

create table stores (
id int not null auto_increment,
id_user int not null unique,
name_store varchar(100) not null,
name_domain varchar(100),
city varchar(100) not null,
code_pos varchar(10) not null,
slogan varchar(100),
description varchar(100),
is_open bool not null default false,
image_store varchar(100),
primary key(id),
foreign key(id_user) references users(id)
) engine=InnoDB;

create table categories_1(
id int not null auto_increment,
name_category varchar(100) not null,
primary key(id)
) engine=InnoDB;

create table categories_2(
id int not null auto_increment,
id_category_1 int not null,
name_category varchar(100),
primary key (id),
foreign key (id_category_1) references categories_1(id)
) engine=InnoDB;

create table categories_3(
id int not null auto_increment,
id_category_2 int not null,
name_category varchar(100),
primary key (id),
foreign key (id_category_2) references categories_2(id)
) engine=InnoDB;

create table products(
id int not null auto_increment,
id_store int not null,
name_product varchar(100) not null,
id_category int not null,
`condition` enum('baru', 'bekas') not null,
description text,
video_url varchar(100),
price int,
min_order int default 1,
weight int not null,
`long` int not null,
height int not null,
is_insurance bool not null default true,
delivery enum('standar', 'custom'),
is_preorder bool default false,
time_preorder date,
primary key(id),
foreign key (id_store) references stores(id),
foreign key (id_category) references categories_3(id)
) engine=InnoDB;

create table images (
id int not null auto_increment,
image_url varchar(25) not null,
id_product int not null,
primary key(id),
foreign key (id_product) references products(id)
) engine=InnoDB;

create table services (
id int auto_increment not null,
name varchar(100) not null,
description text,
primary key(id)
) engine=InnoDB;

create table couriers(
id int not null auto_increment,
name varchar(100) not null,
is_cod bool not null default false,
is_awb bool not null default false,
is_cashless bool not null default false,
primary key(id)
) engine=InnoDB;

create table service_couries(
id int not null auto_increment,
id_service int not null,
id_courier int not null,
primary key(id)
) engine=InnoDB;

alter table service_couries
add constraint foreign key(id_service) references services(id),
add constraint foreign key(id_courier) references couriers(id);

create table service_courie_stores (
id int not null auto_increment,
id_store int not null,
id_service_courier int not null,
primary key (id),
foreign key(id_store) references stores(id),
foreign key(id_service_courier) references service_couries(id)
) engine=InnoDB;

drop table service_courie_products;

create table service_courie_products(
id_product int not null,
id_service_courier_store int not null,
primary key(id_product, id_service_courier_store),
foreign key(id_product) references products(id),
foreign key(id_service_courier_store) references service_courie_stores(id)
) engine=InnoDB;

create table sizes (
id int not null auto_increment,
name varchar(50),
primary key (id)
) engine=InnoDB;

create table colors (
id int not null auto_increment,
name varchar(100),
`hex` varchar(6),
primary key (id)
) engine=InnoDB;

drop table product_variants;

create table product_variants(
id_product int not null,
price int not null,
stoct int not null,
sku varchar(10) not null,
image_product varchar(100),
is_activate bool,
id_size int,
id_color int,
primary key(id_product, id_size, id_color),
foreign key(id_size) references sizes(id),
foreign key(id_product) references products(id),
foreign key(id_color) references colors(id)
)engine=InnoDB;

create table storefronts (
id int not null auto_increment,
id_store int not null,
name varchar(100),
primary key(id),
foreign key(id_store) references stores(id)
)engine=InnoDB;

drop table wistlist;

create table wistlist(
id_user int not null,
id_product int not null,
primary key(id_user, id_product),
foreign key(id_user) references users(id),
foreign key(id_product) references products(id)
)engine=InnoDB;

create table favorite_store(
id_user int not null,
id_store int not null,
primary key(id_user, id_store),
foreign key(id_user) references users(id),
foreign key(id_store) references stores(id)
)engine=InnoDB;

create table carts(
id int not null auto_increment,
id_user int not null,
primary key (id)
) engine=InnoDB;

alter table carts
add foreign key(id_user) references users(id);

create table cart_details(
id_product int not null,
id_cart int not null,
quantity int not null default 0,
notes text,
primary key (id_product, id_cart),
foreign key(id_product) references products(id),
foreign key(id_cart) references carts(id)
)engine=InnoDB;

create table orders(
id int not null auto_increment,
id_user int not null,
order_date timestamp not null default current_timestamp,
total_price int not null,
primary key(id),
foreign key(id_user) references users(id)
) engine=InnoDB;

create table order_details(
id_order int not null,
id_product int not null,
price int not null,
quantity int not null,
notes text,
primary key(id_order, id_product),
foreign key(id_order) references orders(id),
foreign key(id_product) references products(id)
)engine=InnoDB;

# TODO: Testimoni
drop table testimonis;

create table testimonis (
id int not null auto_increment,
id_product int not null,
id_user int not null,
rating double not null,
primary key(id),
description text
) engine=InnoDB;

alter table testimonis 
add foreign key(id_product) references products(id),
add foreign key(id_user) references users(id);

create table image_testimoni (
id int not null auto_increment,
id_testimoni int not null,
image_url varchar(100),
primary key(id),
foreign key(id_testimoni) references testimonis(id)
) engine=InnoDB;

create table chats(
id int not null auto_increment,
chat_message text,
to_id int not null,
from_id int not null,
is_read int not null,
read_date int not null,
send_date int not null,
primary key(id),
foreign key(to_id) references users(id),
foreign key(from_id) references users(id)
)engine=InnoDB;

create table notification(
id int not null,
is_read bool,
description text,
primary key(id)
) engine=InnoDB;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
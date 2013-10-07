-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tempo de Geração: 
-- Versão do Servidor: 5.5.24-log
-- Versão do PHP: 5.4.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Banco de Dados: `skeleton`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `indicadores`
--

CREATE TABLE IF NOT EXISTS `indicadores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `savegame`
--

CREATE TABLE IF NOT EXISTS `savegame` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` int(11) NOT NULL,
  `data` datetime DEFAULT NULL,
  `dados` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE IF NOT EXISTS `usuario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `cpf` varchar(15) DEFAULT NULL,
  `login` varchar(255) DEFAULT NULL,
  `senha` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=101 ;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`id`, `nome`, `email`, `cpf`, `login`, `senha`) VALUES
(1, 'Nash Durham', 'lacus.Quisque@amet.ca', '11', 'auctor.odio.a@augue.org', 'YKL66OLJ5OM'),
(2, 'Fritz Irwin', 'ac.turpis.egestas@estconguea.net', '11', 'eu.dolor@Integerid.org', 'AZE49JYX7JN'),
(3, 'Herrod Welch', 'lorem.Donec.elementum@enimgravida.com', '11', 'ipsum.Donec.sollicitudin@Pellentesquehabitantmorbi.org', 'QKX87MFU4KH'),
(4, 'Hamilton Richard', 'dis@ligulaeu.co.uk', '11', 'egestas.Sed@pedeacurna.org', 'DWI48EZL5WH'),
(5, 'Flynn Griffin', 'molestie.sodales@semutdolor.org', '11', 'penatibus.et.magnis@egetlacus.com', 'LFU20VPE6XQ'),
(6, 'Jackson Baxter', 'gravida.Aliquam@actellus.com', '11', 'in.faucibus.orci@Cum.ca', 'PXI24OMX7GD'),
(7, 'Quentin Bishop', 'ut.pharetra.sed@Phaselluselitpede.ca', '11', 'ultrices.posuere.cubilia@amet.net', 'KHP14HUA1CH'),
(8, 'Malcolm Murphy', 'Integer.id.magna@sitamet.net', '11', 'bibendum@lacus.edu', 'UCT02BTR3IU'),
(9, 'Quamar Mckenzie', 'In.at@etmagnisdis.edu', '11', 'a.feugiat@elit.net', 'SYX10TFW8ZW'),
(10, 'Brent Arnold', 'risus.at@Nuncsollicitudin.ca', '11', 'sem.Nulla@natoquepenatibuset.co.uk', 'AUF87YSM8PQ'),
(11, 'Zachary Gomez', 'purus.Nullam.scelerisque@augue.net', '11', 'ligula.consectetuer.rhoncus@Mauris.com', 'TJV93DUI9ZF'),
(12, 'Moses Washington', 'dictum.cursus.Nunc@nisiCumsociis.net', '11', 'Nulla.eu.neque@vitaeorciPhasellus.ca', 'KJK75PAG9WE'),
(13, 'Declan Aguilar', 'erat.eget.tincidunt@ipsumdolorsit.co.uk', '11', 'lacinia.Sed.congue@tristiquealiquetPhasellus.com', 'QPD32EVR5GL'),
(14, 'Barclay Slater', 'et.lacinia@volutpatornarefacilisis.ca', '11', 'Quisque@Crasloremlorem.ca', 'OWL26FOH8RP'),
(15, 'Axel Stevens', 'Proin.dolor@magnaa.com', '11', 'magna.Suspendisse@euismodurnaNullam.co.uk', 'KLH91OLS4XA'),
(16, 'Ashton Buckner', 'felis.ullamcorper@perinceptoshymenaeos.co.uk', '11', 'faucibus@hendreritconsectetuercursus.edu', 'YCQ69ZPK4WI'),
(17, 'Lane Henry', 'dis.parturient.montes@penatibusetmagnis.org', '11', 'ante.dictum.mi@Nam.com', 'FSI64XSL0IB'),
(18, 'Akeem Gamble', 'magna.Phasellus@duilectusrutrum.net', '11', 'Sed.eu.nibh@tinciduntcongueturpis.com', 'BPA98SEB4NR'),
(19, 'Upton Holden', 'quis.tristique@Donecvitae.org', '11', 'elementum@mieleifendegestas.ca', 'RFL18EKY7KY'),
(20, 'Levi Cabrera', 'aliquet@leoin.org', '11', 'consectetuer@dolorFuscemi.ca', 'HZP39KWO5HT'),
(21, 'Ivor Hull', 'vel@vestibulum.org', '11', 'auctor.odio.a@perconubia.edu', 'YTC76PGX5VG'),
(22, 'Ivor Dejesus', 'aliquam@turpisNullaaliquet.net', '11', 'a.arcu.Sed@IntegermollisInteger.ca', 'DYF54MQL2SE'),
(23, 'Tanek Garner', 'mi.lacinia@Crasloremlorem.edu', '11', 'massa.Integer@Nunclectus.ca', 'HQJ23MTN3ZC'),
(24, 'Thaddeus Jenkins', 'parturient.montes.nascetur@velesttempor.org', '11', 'risus.Nunc.ac@tortorNunc.edu', 'LCQ55YDV5NB'),
(25, 'Wesley Whitley', 'lectus.convallis.est@variusultrices.ca', '11', 'dictum@magnaCras.net', 'CQM00DEM2VC'),
(26, 'Reece Richmond', 'sociis@lobortisnisi.net', '11', 'Cras.eget.nisi@urnaUttincidunt.org', 'IHR58SGY3SZ'),
(27, 'Gary Stephenson', 'lorem@Fusce.co.uk', '11', 'sodales.Mauris.blandit@malesuadafames.co.uk', 'HJN81OFM8XA'),
(28, 'Norman Mercado', 'auctor@Duisatlacus.ca', '11', 'laoreet.libero.et@aliquam.net', 'FYL35NGU9UQ'),
(29, 'Aquila Giles', 'magnis.dis.parturient@venenatis.ca', '11', 'augue.eu@ullamcorperviverra.co.uk', 'GST09TUE6GN'),
(30, 'Charles Robertson', 'laoreet.posuere.enim@Sednullaante.ca', '11', 'rutrum.eu.ultrices@Fusce.com', 'VZR65BNW7GX'),
(31, 'Neil Alexander', 'ultrices.Duis.volutpat@diamnuncullamcorper.org', '11', 'sem.molestie.sodales@pellentesqueafacilisis.net', 'NEP04RIG6AX'),
(32, 'Curran Bass', 'mollis.non@vestibulumloremsit.edu', '11', 'In.tincidunt.congue@urnaVivamus.net', 'UGK91VQR9GS'),
(33, 'Hamilton Talley', 'amet@egetmetus.ca', '11', 'Fusce@lectuspedeet.ca', 'XKI67SHO9SN'),
(34, 'Brett Little', 'pede@leoCras.ca', '11', 'Mauris@temporerat.ca', 'FQR15OVK9EB'),
(35, 'Phillip Stephenson', 'lacinia.vitae@aliquameuaccumsan.co.uk', '11', 'pede.Nunc@feugiatmetussit.org', 'ICT87PMX2EC'),
(36, 'Otto Preston', 'purus.Maecenas.libero@ametrisusDonec.com', '11', 'cursus.vestibulum.Mauris@eusemPellentesque.ca', 'SUF75IFX4ZU'),
(37, 'Brent Mcdaniel', 'at@accumsanconvallisante.edu', '11', 'et@risusNuncac.edu', 'YKD52YDY7JR'),
(38, 'Ethan Oneil', 'diam.luctus.lobortis@metus.edu', '11', 'metus.Vivamus@tincidunt.net', 'KWA46YQO3UC'),
(39, 'Keefe Potts', 'et@Namligula.com', '11', 'mollis@vitae.co.uk', 'DPK58SIH5IU'),
(40, 'Cairo Farley', 'turpis.In@Aeneaneuismod.net', '11', 'ac.urna.Ut@variusorciin.ca', 'WGW93GXN8IA'),
(41, 'Oleg Armstrong', 'eu.erat@vellectus.net', '11', 'lorem.luctus.ut@erosnon.org', 'GTK24VXI1TH'),
(42, 'Holmes Alexander', 'a@nisiCumsociis.co.uk', '11', 'ultrices.a@duiCras.co.uk', 'LWY63NEO2OW'),
(43, 'Nero Hebert', 'elementum.at.egestas@Quisquefringilla.com', '11', 'ridiculus.mus@NullamnislMaecenas.edu', 'XZO26RFB5DT'),
(44, 'Russell Morris', 'ut.lacus.Nulla@sedduiFusce.com', '11', 'purus.sapien.gravida@placeratvelit.ca', 'ZJC52MOF4DK'),
(45, 'Anthony Sanders', 'est.mollis@sagittisNullam.co.uk', '11', 'Nullam.vitae@auctornon.com', 'VYC85MKP8MC'),
(46, 'Brent Washington', 'dis.parturient@ligulaDonec.net', '11', 'auctor.quis@acmattis.edu', 'KCN16VKN7MJ'),
(47, 'Fitzgerald William', 'interdum.Nunc.sollicitudin@risusquisdiam.edu', '11', 'dis@suscipit.org', 'ABA36ZNA0AE'),
(48, 'Perry Stevens', 'adipiscing.Mauris@sedfacilisis.net', '11', 'luctus@nonquamPellentesque.net', 'ZUX60NCC5DM'),
(49, 'Cadman Bryant', 'nulla.at.sem@sapien.org', '11', 'nisi.sem.semper@sagittis.co.uk', 'XNZ34VBL6YC'),
(50, 'Michael Jacobs', 'Phasellus@a.com', '11', 'lacus.Mauris@venenatislacus.com', 'RPD58ROT1NC'),
(51, 'Mason Hahn', 'ante@Vivamus.com', '11', 'ut.nulla@etmagna.net', 'STH91YDU5HJ'),
(52, 'Fuller Walton', 'mollis.non.cursus@sit.com', '11', 'pede.Cum.sociis@acmieleifend.org', 'ENZ69OLR3SP'),
(53, 'Hector Moss', 'luctus.et.ultrices@adipiscing.ca', '11', 'amet.risus.Donec@egetmetus.co.uk', 'WXU18PPA1PQ'),
(54, 'Austin Chang', 'Suspendisse@ornareelit.com', '11', 'augue.scelerisque@dis.edu', 'UFA28CGS0AX'),
(55, 'Sebastian Mercer', 'Suspendisse.commodo@enimNuncut.ca', '11', 'metus@convallisligula.org', 'WSW99NZR7ZZ'),
(56, 'Lars Boyer', 'nec@cubilia.com', '11', 'dolor.Nulla.semper@rutrumnonhendrerit.co.uk', 'JKD99XKU6HS'),
(57, 'Joel Sampson', 'euismod.mauris.eu@nislNulla.com', '11', 'est.Mauris.eu@facilisisSuspendisse.ca', 'TVM56BJZ4NY'),
(58, 'Fulton Heath', 'vel.vulputate@sapien.co.uk', '11', 'magna.Ut@Aliquamauctorvelit.com', 'YDB36YZK7LX'),
(59, 'Graham Kirk', 'Nulla@Donecluctusaliquet.org', '11', 'Morbi@molestiein.org', 'KTU95UGM9IV'),
(60, 'Kelly Estes', 'ut.mi.Duis@velit.co.uk', '11', 'cursus.a.enim@rhoncusDonecest.co.uk', 'EAC95HGX0AW'),
(61, 'Lamar Sanford', 'Donec@enimnectempus.co.uk', '11', 'Donec.at.arcu@eu.co.uk', 'EFS30KFG4ID'),
(62, 'Vincent Miles', 'elementum.lorem@liberoIntegerin.net', '11', 'malesuada@necleo.com', 'IHB05VAT0TB'),
(63, 'Bert Cash', 'et@egettincidunt.org', '11', 'eros@nonleo.com', 'CGN96MGY7IZ'),
(64, 'Garth Castaneda', 'ipsum@sed.com', '11', 'penatibus.et.magnis@mattissemper.edu', 'DAK03IHM5VK'),
(65, 'Clinton Frank', 'vel.vulputate@Aliquam.com', '11', 'nec@liberonec.co.uk', 'WRV33INM3XM'),
(66, 'Oscar Dillon', 'dui.nec.urna@magnatellusfaucibus.ca', '11', 'tincidunt.tempus.risus@urna.com', 'JNJ51SMA3IJ'),
(67, 'Moses Nash', 'Mauris.blandit.enim@a.ca', '11', 'tempor@ametmetusAliquam.edu', 'PXY81ZDM4MB'),
(68, 'Lance Cooley', 'non.justo@etrisus.co.uk', '11', 'commodo.at@idmagna.net', 'CIT52QOX5NU'),
(69, 'Magee Kaufman', 'elementum.sem.vitae@fringillaestMauris.com', '11', 'aliquet.Phasellus@nulla.ca', 'ELF08TTY0NL'),
(70, 'Garrett Chambers', 'molestie@necmaurisblandit.edu', '11', 'hendrerit@elementumpurus.org', 'SOY47CDX5JY'),
(71, 'Gary Burris', 'pede.Cum.sociis@velit.net', '11', 'pede.Cras@egestasadui.org', 'YMK99KGS9FE'),
(72, 'Murphy Garcia', 'Etiam@dignissimmagnaa.ca', '11', 'conubia.nostra.per@gravidanon.ca', 'JPX14AOL4YI'),
(73, 'Hu Grimes', 'at.sem@ipsum.org', '11', 'sociis@lacusUt.org', 'EGE48EYF8WJ'),
(74, 'Donovan Tillman', 'vitae.erat.vel@lacusvarius.edu', '11', 'velit@ligula.ca', 'JQR02RKK9PV'),
(75, 'Philip Roach', 'ut.mi.Duis@bibendumfermentum.org', '11', 'Mauris.molestie@euismodac.com', 'SVL38AXG6OH'),
(76, 'Tanner Cruz', 'nisl.arcu.iaculis@iaculis.edu', '11', 'ac@Aeneanegetmagna.ca', 'GND51CSV9DF'),
(77, 'Preston Chaney', 'nec@viverraDonectempus.com', '11', 'lacus.Ut.nec@Quisquepurussapien.com', 'DYJ08AQA5TO'),
(78, 'Nash Sparks', 'Nullam@turpisNullaaliquet.net', '11', 'facilisis.Suspendisse@auctorquis.ca', 'WBK80LEE3OF'),
(79, 'Cain Mccoy', 'augue.ac.ipsum@erat.net', '11', 'adipiscing.lacus@litoratorquent.org', 'DVZ03IOG3ZD'),
(80, 'Hashim Hebert', 'at@volutpatNullafacilisis.co.uk', '11', 'massa.lobortis@justo.com', 'WLU88BHZ8GZ'),
(81, 'Davis Marsh', 'Proin.vel@velnislQuisque.ca', '11', 'odio.auctor.vitae@eu.co.uk', 'WPI57XWP3RL'),
(82, 'Charles Perry', 'vel.vulputate.eu@pharetraut.com', '11', 'In.tincidunt@ametorci.com', 'BWE08WWT4EH'),
(83, 'Channing Briggs', 'placerat@imperdieterat.com', '11', 'euismod.ac@feugiatmetussit.co.uk', 'AZL73XZL7DM'),
(84, 'Melvin Alvarado', 'dolor.elit@fringillaeuismod.net', '11', 'fames.ac@nonarcu.ca', 'STE66HOP3AI'),
(85, 'Mohammad Wade', 'semper@telluseuaugue.ca', '11', 'commodo.ipsum@acfermentumvel.org', 'NQC31FBU9FL'),
(86, 'Kamal Leon', 'Praesent@rutrumFuscedolor.org', '11', 'lacinia.mattis.Integer@Donecest.com', 'GCS19RRM3TW'),
(87, 'Harlan Weiss', 'sit.amet.diam@erosNamconsequat.net', '11', 'condimentum.Donec@sagittislobortis.net', 'DAT96LEX5XC'),
(88, 'Hoyt Maynard', 'adipiscing.fringilla.porttitor@ligulaNullamenim.net', '11', 'magna.a@egestasurna.net', 'GWL94YTQ9MO'),
(89, 'Knox Tran', 'risus.Donec.nibh@cursusdiam.ca', '11', 'Mauris@metusInnec.co.uk', 'QKL39VDG7OG'),
(90, 'Charles Koch', 'In.at.pede@telluseu.org', '11', 'Nullam.ut@eratvitae.net', 'ESW55ZME3YM'),
(91, 'Gage Reese', 'dui.augue@Curabiturdictum.co.uk', '11', 'elit.a.feugiat@ipsumleo.com', 'VFQ87LPY1MM'),
(92, 'Melvin Horn', 'egestas.Aliquam.fringilla@atrisusNunc.org', '11', 'ac.fermentum.vel@vitaeodiosagittis.edu', 'RUV52ZUC1LZ'),
(93, 'Victor Stevens', 'Proin.ultrices@metus.org', '11', 'ac.risus@mienim.com', 'XNY83BZB8VO'),
(94, 'Blake Shannon', 'interdum.Curabitur@imperdiet.edu', '11', 'primis.in.faucibus@AliquamnislNulla.net', 'FJG59OVV0TR'),
(95, 'Hashim Shaw', 'Aenean.egestas@felispurusac.edu', '11', 'Cras@urnaNullamlobortis.com', 'EIX81PQJ9XX'),
(96, 'Theodore Howe', 'Nunc.quis.arcu@sagittislobortis.org', '11', 'Fusce@etarcu.ca', 'NVW98FDZ5AW'),
(97, 'Nehru Mendez', 'quis.diam@Maecenasmalesuada.co.uk', '11', 'parturient.montes.nascetur@nisi.edu', 'OIM67MDH3AF'),
(98, 'Brady Donaldson', 'iaculis.odio@porttitorscelerisqueneque.co.uk', '11', 'varius@magnaPraesent.net', 'NBR22AJV3WL'),
(99, 'Carson Glenn', 'lobortis.mauris@nullaDonec.net', '11', 'dapibus.quam.quis@ridiculusmusAenean.org', 'UEL27BBG1SM'),
(100, 'Francis Ratliff', 'semper.auctor.Mauris@nisl.ca', '11', 'et@tortorNunccommodo.co.uk', 'MLS53IAC4LI');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

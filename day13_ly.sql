/*
Navicat MySQL Data Transfer

Source Server         : zhu
Source Server Version : 50524
Source Host           : 172.16.136.11:3306
Source Database       : ly

Target Server Type    : MYSQL
Target Server Version : 50524
File Encoding         : 65001

Date: 2017-06-27 22:45:12
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for gsys_admin_db
-- ----------------------------
DROP TABLE IF EXISTS `gsys_admin_db`;
CREATE TABLE `gsys_admin_db` (
  `sysid` int(11) NOT NULL AUTO_INCREMENT COMMENT '游戏服id',
  `ab_normal` tinyint(2) DEFAULT '0' COMMENT '0.正式服,1非正式服,-1已下架,2送审',
  `ab_gamename` varchar(100) NOT NULL COMMENT '游戏服名',
  `ab_alias` varchar(100) DEFAULT NULL COMMENT '腾讯用别名',
  `ab_transportid` varchar(20) NOT NULL COMMENT '联运商id',
  `ab_opentime` int(11) NOT NULL COMMENT '开服时间',
  `ab_dbname` varchar(50) DEFAULT NULL COMMENT '数据库名称',
  `ab_todbname` varchar(50) DEFAULT '0' COMMENT '合服数据库',
  `ab_fronthost` varchar(50) DEFAULT NULL COMMENT '前端域名',
  `ab_frontip` varchar(50) DEFAULT NULL COMMENT '前端IP',
  `ab_outid` int(10) DEFAULT '0' COMMENT '对外的id,如tencent上的大区id',
  `ab_zoneid` int(10) DEFAULT '0' COMMENT '游戏后端区ID',
  `ab_timezone` varchar(50) DEFAULT '0' COMMENT '时区',
  `ab_busy` tinyint(1) DEFAULT '1' COMMENT '忙碌程度: 1-空闲,2-忙碌,3-爆满',
  `ab_state` tinyint(1) DEFAULT '0' COMMENT '状态:0-没有,1-新服推荐,2-火爆',
  `ab_autoid` int(10) DEFAULT '0' COMMENT '自动ID的前缀,如：100001000000001->100001',
  `ab_adduserid` int(10) DEFAULT NULL COMMENT '添加人id',
  `ab_insertdate` int(11) DEFAULT NULL COMMENT '添加时间',
  `ab_reguserid` int(10) DEFAULT NULL COMMENT '修改人id',
  `ab_regdate` int(11) DEFAULT NULL COMMENT '修改时间',
  `ab_iscombine` int(10) DEFAULT '0' COMMENT '0:无,1:合服中',
  `ab_appip` varchar(32) DEFAULT '' COMMENT '服务器ip',
  `ab_port` smallint(5) unsigned DEFAULT '0' COMMENT '端口',
  `ab_o_tablenameinc` varchar(20) DEFAULT 'm_' COMMENT '数据表前辍',
  `ab_o_mysqlhost` varchar(200) DEFAULT '' COMMENT '数据库主机地址',
  `ab_o_mysqluser` varchar(100) DEFAULT 'develop' COMMENT '数据库用户名',
  `ab_o_mysqlpass` varchar(100) DEFAULT 'develop' COMMENT '数据库密码',
  `ab_o_mysqllog` varchar(200) DEFAULT '' COMMENT '数据库日志地址',
  `ab_o_openstate` int(10) DEFAULT '2' COMMENT '开服状态',
  `ab_o_appip` varchar(20) DEFAULT '' COMMENT '应用程序接口IP',
  `ab_o_appurl` varchar(200) DEFAULT '' COMMENT '应用程序接口URL',
  `ab_o_urlport` int(10) DEFAULT NULL COMMENT 'HTTP端口',
  `ab_o_urlport2` int(10) DEFAULT NULL COMMENT 'HTTP端口2',
  `ab_o_urlport3` int(10) DEFAULT NULL COMMENT 'HTTP端口3',
  `ab_o_payport` int(10) DEFAULT NULL COMMENT '支付或者发货端口',
  `ab_o_socketport` int(10) DEFAULT NULL COMMENT 'SOCKET端口',
  `ab_o_socketport2` int(10) DEFAULT NULL COMMENT 'SOCKET端口2',
  `ab_o_socketport3` int(10) DEFAULT NULL COMMENT 'SOCKET端口3',
  `ab_yunweisys` int(4) unsigned DEFAULT '1' COMMENT '运维系统标示',
  `ab_version` varchar(255) DEFAULT '' COMMENT '游戏engine版本',
  `ab_resource` varchar(255) DEFAULT '' COMMENT '游戏资源路径',
  `ab_scriptversion` varchar(255) DEFAULT '' COMMENT '游戏脚本版本',
  `ab_roomid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '房间id',
  `ab_language` varchar(16) NOT NULL DEFAULT '' COMMENT '服务器语言，默认为空',
  `ab_combine_zoneid` int(10) NOT NULL DEFAULT '0' COMMENT '标识同一合服区区ID',
  `ab_combine_to_zoneid` int(10) NOT NULL DEFAULT '0' COMMENT '准备合服到一起的合服区区ID标识',
  PRIMARY KEY (`sysid`),
  UNIQUE KEY `ab_zoneid` (`ab_zoneid`) USING BTREE,
  KEY `ab_dbname` (`ab_dbname`) USING BTREE,
  KEY `ab_dbname_todbname` (`ab_dbname`,`ab_todbname`),
  KEY `ab_opentime` (`ab_opentime`),
  KEY `ab_fronthost` (`ab_fronthost`),
  KEY `ab_outid` (`ab_outid`),
  KEY `ab_timezone` (`ab_timezone`),
  KEY `ab_combine_zoneid` (`ab_combine_zoneid`),
  KEY `ab_combine_to_zoneid` (`ab_combine_to_zoneid`)
) ENGINE=MyISAM AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COMMENT='游戏服数据表';

-- ----------------------------
-- Records of gsys_admin_db
-- ----------------------------
INSERT INTO `gsys_admin_db` VALUES ('1', '0', '测试服', '测试服', '373770024', '1472227200', 'lyshujian_9998', 'lyshujian_9998', '-', '-', '9998', '9998', '-8', '1', '0', '19998', '12', '1467884773', '12', '1467884773', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('2', '0', '669ye1区', '669ye1区', '373770024', '1470067200', 'lyshujian_1', 'lyshujian_1', '-', '-', '1', '1', '-8', '1', '0', '10001', '12', '1469516516', '12', '1469516516', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('3', '0', '快玩1服', '快玩1服', '373770025', '1470326400', 'lyshujian_2', 'lyshujian_2', '-', '-', '1', '2', '-8', '1', '0', '10002', '12', '1469516771', '12', '1469516771', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '2', '2');
INSERT INTO `gsys_admin_db` VALUES ('4', '0', 'OOwan1区', 'OOwan1区', '373770026', '1470067200', 'lyshujian_3', 'lyshujian_3', '-', '-', '1', '3', '-8', '1', '0', '10003', '12', '1469516887', '12', '1469516887', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('5', '0', '669ye2区', '669ye2区', '373770024', '1470326400', 'lyshujian_4', 'lyshujian_4', '-', '-', '2', '4', '-8', '1', '0', '10004', '12', '1469698955', '12', '1469698955', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('6', '0', 'OOwan2区', 'OOwan2区', '373770026', '1470240000', 'lyshujian_3', 'lyshujian_3', '-', '-', '2', '5', '-8', '1', '0', '10005', '12', '1469699138', '12', '1469699138', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('7', '0', '快玩2服', '快玩2服', '373770025', '1470499200', 'lyshujian_2', 'lyshujian_2', '-', '-', '2', '6', '-8', '1', '0', '10006', '12', '1470222000', '12', '1470222000', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '2', '2');
INSERT INTO `gsys_admin_db` VALUES ('8', '0', '六间房1服', '六间房1服', '373770027', '1470931200', 'lyshujian_7', 'lyshujian_7', '-', '-', '1', '7', '-8', '1', '0', '10007', '12', '1470368047', '12', '1470368047', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('9', '0', '669ye3区', '669ye3区', '373770024', '1470672000', 'lyshujian_8', 'lyshujian_8', '-', '-', '3', '8', '-8', '1', '0', '10008', '12', '1470397517', '12', '1470397517', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('10', '0', 'OOwan3区', 'OOwan3区', '373770026', '1470672000', 'lyshujian_3', 'lyshujian_3', '-', '-', '3', '9', '-8', '1', '0', '10009', '12', '1470397648', '12', '1470397648', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('11', '0', 'OOwan4区', 'OOwan4区', '373770026', '1470758400', 'lyshujian_3', 'lyshujian_3', '-', '-', '4', '10', '-8', '1', '0', '10010', '12', '1470397782', '12', '1470397782', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('12', '0', 'mayiyx1服', 'mayiyx1服', '373770028', '1471449600', 'lyshujian_11', 'lyshujian_11', '-', '-', '1', '11', '-8', '1', '0', '10011', '12', '1470641958', '12', '1470641958', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('13', '0', 'OOwan5区', 'OOwan5区', '373770026', '1470844800', 'lyshujian_3', 'lyshujian_3', '-', '-', '5', '12', '-8', '1', '2', '10012', '12', '1470642838', '12', '1470642838', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('14', '0', '669ye4区', '669ye4区', '373770024', '1470931200', 'lyshujian_13', 'lyshujian_13', '-', '-', '4', '13', '-8', '1', '0', '10013', '12', '1470642993', '12', '1470642993', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('15', '0', '快玩3服', '快玩3服', '373770025', '1470931200', 'lyshujian_2', 'lyshujian_2', '-', '-', '3', '14', '-8', '1', '0', '10014', '12', '1470643127', '12', '1470643127', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '2', '2');
INSERT INTO `gsys_admin_db` VALUES ('16', '0', '六间房2服', '六间房2服', '373770027', '1471104000', 'lyshujian_7', 'lyshujian_7', '-', '-', '2', '15', '-8', '1', '0', '10015', '12', '1470968261', '12', '1470968261', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('17', '0', '快玩4服', '快玩4服', '373770025', '1471363200', 'lyshujian_16', 'lyshujian_16', '-', '-', '4', '16', '-8', '1', '0', '10016', '12', '1470968387', '12', '1470968387', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '16', '16');
INSERT INTO `gsys_admin_db` VALUES ('18', '0', '六间房3服', '六间房3服', '373770027', '1471276800', 'lyshujian_7', 'lyshujian_7', '-', '-', '3', '17', '-8', '1', '0', '10017', '12', '1470968596', '12', '1470968596', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('19', '0', 'OOwan6区', 'OOwan6区', '373770026', '1471276800', 'lyshujian_3', 'lyshujian_3', '-', '-', '6', '18', '-8', '1', '0', '10018', '12', '1470968769', '12', '1470968769', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('20', '0', 'OOwan7区', 'OOwan7区', '373770026', '1471363200', 'lyshujian_3', 'lyshujian_3', '-', '-', '7', '19', '-8', '1', '0', '10019', '12', '1470968850', '12', '1470968850', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('21', '0', 'mayiyx2服', 'mayiyx2服', '373770028', '1471536000', 'lyshujian_11', 'lyshujian_11', '-', '-', '2', '20', '-8', '1', '0', '10020', '12', '1470968999', '12', '1470968999', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('22', '0', '六间房4服', '六间房4服', '373770027', '1471449600', 'lyshujian_7', 'lyshujian_7', '-', '-', '4', '21', '-8', '1', '0', '10021', '12', '1470969122', '12', '1470969122', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('23', '0', 'OOwan8区', 'OOwan8区', '373770026', '1471449600', 'lyshujian_3', 'lyshujian_3', '-', '-', '8', '22', '-8', '1', '0', '10022', '12', '1470969668', '12', '1470969668', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('24', '0', 'OOwan9区', 'OOwan9区', '373770026', '1471536000', 'lyshujian_3', 'lyshujian_3', '-', '-', '9', '23', '-8', '1', '0', '10023', '12', '1471510217', '12', '1471510217', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '3', '3');
INSERT INTO `gsys_admin_db` VALUES ('25', '0', '六间房5服', '六间房5服', '373770027', '1471622400', 'lyshujian_7', 'lyshujian_7', '-', '-', '5', '24', '-8', '1', '0', '10024', '12', '1471510487', '12', '1471510487', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('26', '0', 'mayiyx3服', 'mayiyx3服', '373770028', '1471622400', 'lyshujian_11', 'lyshujian_11', '-', '-', '3', '25', '-8', '1', '0', '10025', '12', '1471510665', '12', '1471510665', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('27', '0', '快玩5服', '快玩5服', '373770025', '1471622400', 'lyshujian_16', 'lyshujian_16', '-', '-', '5', '26', '-8', '1', '0', '10026', '12', '1471511135', '12', '1471511135', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '16', '16');
INSERT INTO `gsys_admin_db` VALUES ('28', '0', 'mayiyx4服', 'mayiyx4服', '373770028', '1471795200', 'lyshujian_11', 'lyshujian_11', '-', '-', '4', '27', '-8', '1', '0', '10027', '12', '1471512327', '12', '1471512327', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('29', '0', '六间房6服', '六间房6服', '373770027', '1471881600', 'lyshujian_7', 'lyshujian_7', '-', '-', '6', '28', '-8', '1', '0', '10028', '12', '1471512412', '12', '1471512412', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('30', '0', 'OOwan11区', 'OOwan11区', '373770026', '1471968000', 'lyshujian_29', 'lyshujian_29', '-', '-', '11', '30', '-8', '1', '0', '10030', '12', '1471512679', '12', '1471512679', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('31', '0', 'OOwan10区', 'OOwan10区', '373770026', '1471881600', 'lyshujian_29', 'lyshujian_29', '-', '-', '10', '29', '-8', '1', '0', '10029', '12', '1471512679', '12', '1471512679', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('32', '0', 'OOwan12区', 'OOwan12区', '373770026', '1472054400', 'lyshujian_29', 'lyshujian_29', '-', '-', '12', '31', '-8', '1', '0', '10031', '12', '1471512940', '12', '1471512940', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('33', '0', 'mayiyx5服', 'mayiyx5服', '373770028', '1471968000', 'lyshujian_11', 'lyshujian_11', '-', '-', '5', '32', '-8', '1', '0', '10032', '12', '1471513071', '12', '1471513071', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('34', '0', '快玩6服', '快玩6服', '373770025', '1472054400', 'lyshujian_16', 'lyshujian_16', '-', '-', '6', '33', '-8', '1', '0', '10033', '12', '1471513207', '12', '1471513207', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '16', '16');
INSERT INTO `gsys_admin_db` VALUES ('35', '1', '合服测试2095', '', '373770024', '1471917600', 'lyshujian_2095', 'lyshujian_2095', '-', '-', '2095', '2095', '-8', '1', '0', '12095', '105', '1471919822', '105', '1471919822', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('36', '1', '合服测试2096', '', '373770024', '1471917600', 'lyshujian_2095', 'lyshujian_2095', '-', '-', '2096', '2096', '-8', '1', '0', '12096', '105', '1471919928', '105', '1471919928', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('37', '0', '160yx1服', '160yx1服', '373770029', '1473177600', 'lyshujian_34', 'lyshujian_34', '-', '-', '1', '34', '-8', '1', '0', '10034', '12', '1472008922', '12', '1472008922', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '34', '34');
INSERT INTO `gsys_admin_db` VALUES ('38', '0', '9991wan1区', '9991wan1区', '373770030', '1472400000', 'lyshujian_35', 'lyshujian_35', '-', '-', '1', '35', '-8', '1', '0', '10035', '12', '1472009060', '12', '1472009060', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '35', '35');
INSERT INTO `gsys_admin_db` VALUES ('39', '0', 'lehihi1区', 'lehihi1区', '373770031', '1472486400', 'lyshujian_36', 'lyshujian_36', '-', '-', '1', '36', '-8', '1', '0', '10036', '12', '1472009243', '12', '1472009243', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '36', '36');
INSERT INTO `gsys_admin_db` VALUES ('40', '0', '33456-1区', '33456-1区', '373770032', '1472745600', 'lyshujian_37', 'lyshujian_37', '-', '-', '1', '37', '-8', '1', '0', '10037', '12', '1472010977', '12', '1472010977', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '37', '37');
INSERT INTO `gsys_admin_db` VALUES ('41', '0', 'mayiyx6服', 'mayiyx6服', '373770028', '1472140800', 'lyshujian_11', 'lyshujian_11', '-', '-', '6', '38', '-8', '1', '0', '10038', '12', '1472120738', '12', '1472120738', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('42', '0', 'OOwan13区', 'OOwan13区', '373770026', '1472140800', 'lyshujian_29', 'lyshujian_29', '-', '-', '13', '39', '-8', '1', '0', '10039', '12', '1472120832', '12', '1472120832', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('43', '0', '六间房7服', '六间房7服', '373770027', '1472227200', 'lyshujian_7', 'lyshujian_7', '-', '-', '7', '40', '-8', '1', '0', '10040', '12', '1472121047', '12', '1472121047', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('44', '0', '快玩7服', '快玩7服', '373770025', '1472313600', 'lyshujian_41', 'lyshujian_41', '-', '-', '7', '41', '-8', '1', '0', '10041', '12', '1472121047', '12', '1472121047', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '41', '41');
INSERT INTO `gsys_admin_db` VALUES ('45', '0', 'mayiyx7服', 'mayiyx7服', '373770028', '1472400000', 'lyshujian_11', 'lyshujian_11', '-', '-', '7', '42', '-8', '1', '0', '10042', '12', '1472121239', '12', '1472121239', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('46', '0', 'OOwan14区', 'OOwan14区', '373770026', '1472486400', 'lyshujian_29', 'lyshujian_29', '-', '-', '14', '43', '-8', '1', '0', '10043', '12', '1472121957', '12', '1472121957', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('47', '0', 'OOwan15区', 'OOwan15区', '373770026', '1472572800', 'lyshujian_29', 'lyshujian_29', '-', '-', '15', '44', '-8', '1', '0', '10044', '12', '1472121957', '12', '1472121957', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('48', '0', '快玩8服', '快玩8服', '373770025', '1472572800', 'lyshujian_41', 'lyshujian_41', '-', '-', '8', '45', '-8', '1', '0', '10045', '12', '1472122208', '12', '1472122208', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '41', '41');
INSERT INTO `gsys_admin_db` VALUES ('49', '0', '六间房8服', '六间房8服', '373770027', '1472486400', 'lyshujian_7', 'lyshujian_7', '-', '-', '8', '46', '-8', '1', '0', '10046', '12', '1472122208', '12', '1472122208', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('50', '0', 'mayiyx8服', 'mayiyx8服', '373770028', '1472572800', 'lyshujian_11', 'lyshujian_11', '-', '-', '8', '47', '-8', '1', '0', '10047', '12', '1472122423', '12', '1472122423', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('51', '0', 'OOwan16区', 'OOwan16区', '373770026', '1472659200', 'lyshujian_29', 'lyshujian_29', '-', '-', '16', '48', '-8', '1', '0', '10048', '12', '1472122619', '12', '1472122619', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('52', '0', 'OOwan17区', 'OOwan17区', '373770026', '1472745600', 'lyshujian_29', 'lyshujian_29', '-', '-', '17', '49', '-8', '1', '0', '10049', '12', '1472122699', '12', '1472122699', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('53', '0', '9991wan2区', '9991wan2区', '373770030', '1472659200', 'lyshujian_35', 'lyshujian_35', '-', '-', '2', '50', '-8', '1', '0', '10050', '12', '1472122839', '12', '1472122839', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '35', '35');
INSERT INTO `gsys_admin_db` VALUES ('54', '0', 'lehihi2区', 'lehihi2区', '373770031', '1472659200', 'lyshujian_36', 'lyshujian_36', '-', '-', '2', '51', '-8', '1', '0', '10051', '12', '1472122937', '12', '1472122937', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '36', '36');
INSERT INTO `gsys_admin_db` VALUES ('55', '0', '快玩9服', '快玩9服', '373770025', '1473177600', 'lyshujian_41', 'lyshujian_41', '-', '-', '9', '52', '-8', '1', '0', '10052', '215', '1472436046', '215', '1472436046', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '41', '41');
INSERT INTO `gsys_admin_db` VALUES ('56', '0', '六间房9服', '六间房9服', '373770027', '1472745600', 'lyshujian_7', 'lyshujian_7', '-', '-', '9', '53', '-8', '1', '0', '10053', '12', '1472718562', '12', '1472718562', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('57', '0', 'lehihi3区', 'lehihi3区', '373770031', '1472832000', 'lyshujian_36', 'lyshujian_36', '-', '-', '3', '54', '-8', '1', '0', '10054', '12', '1472718562', '12', '1472718562', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '36', '36');
INSERT INTO `gsys_admin_db` VALUES ('58', '0', 'mayiyx9服', 'mayiyx9服', '373770028', '1472832000', 'lyshujian_11', 'lyshujian_11', '-', '-', '9', '55', '-8', '1', '0', '10055', '12', '1472718562', '12', '1472718562', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('59', '0', '33456-2区', '33456-2区', '373770032', '1473004800', 'lyshujian_37', 'lyshujian_37', '-', '-', '2', '56', '-8', '1', '0', '10056', '12', '1472718927', '12', '1472718927', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '37', '37');
INSERT INTO `gsys_admin_db` VALUES ('60', '0', 'OOwan18区', 'OOwan18区', '373770026', '1473091200', 'lyshujian_29', 'lyshujian_29', '-', '-', '18', '57', '-8', '1', '0', '10057', '12', '1472718927', '12', '1472718927', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '29', '29');
INSERT INTO `gsys_admin_db` VALUES ('61', '0', 'lehihi4区', 'lehihi4区', '373770031', '1473091200', 'lyshujian_58', 'lyshujian_58', '-', '-', '4', '58', '-8', '1', '0', '10058', '12', '1472719333', '12', '1472719333', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '58', '58');
INSERT INTO `gsys_admin_db` VALUES ('62', '0', 'mayiyx10服', 'mayiyx10服', '373770028', '1473091200', 'lyshujian_11', 'lyshujian_11', '-', '-', '10', '59', '-8', '1', '0', '10059', '12', '1472719333', '12', '1472719333', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('63', '0', '9991wan3区', '9991wan3区', '373770030', '1473091200', 'lyshujian_35', 'lyshujian_35', '-', '-', '3', '60', '-8', '1', '0', '10060', '12', '1472719711', '12', '1472719711', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '35', '35');
INSERT INTO `gsys_admin_db` VALUES ('64', '0', 'OOwan19区', 'OOwan19区', '373770026', '1473177600', 'lyshujian_61', 'lyshujian_61', '-', '-', '19', '61', '-8', '1', '0', '10061', '12', '1472719711', '12', '1472719711', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '61', '61');
INSERT INTO `gsys_admin_db` VALUES ('65', '0', '33456-3区', '33456-3区', '373770032', '1473264000', 'lyshujian_37', 'lyshujian_37', '-', '-', '3', '62', '-8', '1', '0', '10062', '12', '1472721194', '12', '1472721194', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '37', '37');
INSERT INTO `gsys_admin_db` VALUES ('66', '0', 'OOwan20区', 'OOwan20区', '373770026', '1473264000', 'lyshujian_61', 'lyshujian_61', '-', '-', '20', '63', '-8', '1', '0', '10063', '12', '1472721194', '12', '1472721194', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '61', '61');
INSERT INTO `gsys_admin_db` VALUES ('67', '0', 'mayiyx11服', 'mayiyx11服', '373770028', '1473264000', 'lyshujian_11', 'lyshujian_11', '-', '-', '11', '64', '-8', '1', '0', '10064', '12', '1472721194', '12', '1472721194', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('68', '0', '51书剑1服', '51书剑1服', '373770033', '1473782400', 'lyshujian_65', 'lyshujian_65', '-', '-', '1', '65', '-8', '1', '0', '10065', '12', '1472798752', '12', '1472798752', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('69', '0', 'OOwan21区', 'OOwan21区', '373770026', '1473350400', 'lyshujian_61', 'lyshujian_61', '-', '-', '21', '66', '-8', '1', '0', '10066', '12', '1473325669', '12', '1473325669', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '61', '61');
INSERT INTO `gsys_admin_db` VALUES ('70', '0', '160yx2服', '160yx2服', '373770029', '1473350400', 'lyshujian_34', 'lyshujian_34', '-', '-', '2', '67', '-8', '1', '0', '10067', '12', '1473325669', '12', '1473325669', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '34', '34');
INSERT INTO `gsys_admin_db` VALUES ('71', '0', 'lehihi5区', 'lehihi5区', '373770031', '1473350400', 'lyshujian_58', 'lyshujian_58', '-', '-', '5', '68', '-8', '1', '0', '10068', '12', '1473325669', '12', '1473325669', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '58', '58');
INSERT INTO `gsys_admin_db` VALUES ('72', '0', 'mayiyx12服', 'mayiyx12服', '373770028', '1473436800', 'lyshujian_11', 'lyshujian_11', '-', '-', '12', '69', '-8', '1', '0', '10069', '12', '1473325669', '12', '1473325669', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('73', '0', '160yx3服', '160yx3服', '373770029', '1473609600', 'lyshujian_34', 'lyshujian_34', '-', '-', '3', '70', '-8', '1', '0', '10070', '12', '1473326207', '12', '1473326207', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '34', '34');
INSERT INTO `gsys_admin_db` VALUES ('74', '0', 'OOwan22区', 'OOwan22区', '373770026', '1473696000', 'lyshujian_71', 'lyshujian_71', '-', '-', '22', '71', '-8', '1', '0', '10071', '12', '1473326207', '12', '1473326207', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '71', '71');
INSERT INTO `gsys_admin_db` VALUES ('75', '0', '快玩10服', '快玩10服', '373770025', '1473782400', 'lyshujian_72', 'lyshujian_72', '-', '-', '10', '72', '-8', '1', '0', '10072', '12', '1473326207', '12', '1473326207', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '72', '72');
INSERT INTO `gsys_admin_db` VALUES ('76', '0', 'lehihi6区', 'lehihi6区', '373770031', '1473782400', 'lyshujian_58', 'lyshujian_58', '-', '-', '6', '73', '-8', '1', '0', '10073', '12', '1473326787', '12', '1473326787', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '58', '58');
INSERT INTO `gsys_admin_db` VALUES ('77', '0', '160yx4服', '160yx4服', '373770029', '1473782400', 'lyshujian_34', 'lyshujian_34', '-', '-', '4', '74', '-8', '1', '0', '10074', '12', '1473326946', '12', '1473326946', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '34', '34');
INSERT INTO `gsys_admin_db` VALUES ('78', '0', 'mayiyx13服', 'mayiyx13服', '373770028', '1473782400', 'lyshujian_11', 'lyshujian_11', '-', '-', '13', '75', '-8', '1', '0', '10075', '12', '1473327048', '12', '1473327048', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('79', '0', '9991wan4区', '9991wan4区', '373770030', '1473868800', 'lyshujian_35', 'lyshujian_35', '-', '-', '4', '76', '-8', '1', '0', '10076', '12', '1473327129', '12', '1473327129', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '35', '35');
INSERT INTO `gsys_admin_db` VALUES ('80', '0', '六间房10服', '六间房10服', '373770027', '1473955200', 'lyshujian_7', 'lyshujian_7', '-', '-', '10', '77', '-8', '1', '0', '10077', '12', '1473327225', '12', '1473327225', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '7', '7');
INSERT INTO `gsys_admin_db` VALUES ('81', '0', 'mayiyx14服', 'mayiyx14服', '373770028', '1474041600', 'lyshujian_11', 'lyshujian_11', '-', '-', '14', '78', '-8', '1', '0', '10078', '12', '1473327304', '12', '1473327304', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '11', '11');
INSERT INTO `gsys_admin_db` VALUES ('82', '0', '33456-4区', '33456-4区', '373770032', '1473782400', 'lyshujian_37', 'lyshujian_37', '-', '-', '4', '79', '-8', '1', '0', '10079', '12', '1473327725', '12', '1473327725', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '37', '37');
INSERT INTO `gsys_admin_db` VALUES ('83', '0', '160yx5服', '160yx5服', '373770029', '1474214400', 'lyshujian_34', 'lyshujian_34', '-', '-', '5', '80', '-8', '1', '0', '10080', '265', '1473836398', '265', '1473836398', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '34', '34');
INSERT INTO `gsys_admin_db` VALUES ('84', '0', '33456-5区', '33456-5区', '373770032', '1474214400', 'lyshujian_37', 'lyshujian_37', '-', '-', '5', '81', '-8', '1', '0', '10081', '265', '1473837143', '265', '1473837143', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '37', '37');
INSERT INTO `gsys_admin_db` VALUES ('85', '0', '9991wan5区', '9991wan5区', '373770030', '1474300800', 'lyshujian_35', 'lyshujian_35', '-', '-', '5', '82', '-8', '1', '0', '10082', '265', '1473837251', '265', '1473837251', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '35', '35');
INSERT INTO `gsys_admin_db` VALUES ('86', '0', 'lehihi7区', 'lehihi7区', '373770031', '1474387200', 'lyshujian_83', 'lyshujian_83', '-', '-', '7', '83', '-8', '1', '0', '10083', '265', '1473837428', '265', '1473837428', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '83', '83');
INSERT INTO `gsys_admin_db` VALUES ('87', '0', '快玩11服', '快玩11服', '373770025', '1474387200', 'lyshujian_72', 'lyshujian_72', '-', '-', '11', '84', '-8', '1', '0', '10084', '265', '1474187286', '265', '1474187286', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '72', '72');
INSERT INTO `gsys_admin_db` VALUES ('88', '0', '160yx6服', '160yx6服', '373770029', '1474387200', 'lyshujian_34', 'lyshujian_34', '-', '-', '6', '85', '-8', '1', '0', '10085', '265', '1474187607', '265', '1474187607', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '34', '34');
INSERT INTO `gsys_admin_db` VALUES ('89', '0', 'OOwan23区', 'OOwan23区', '373770026', '1474560000', 'lyshujian_71', 'lyshujian_71', '-', '-', '23', '86', '-8', '1', '0', '10086', '265', '1474187739', '265', '1474187739', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '71', '71');
INSERT INTO `gsys_admin_db` VALUES ('90', '0', '33456-6区', '33456-6区', '373770032', '1474819200', 'lyshujian_37', 'lyshujian_37', '-', '-', '6', '87', '-8', '1', '0', '10087', '249', '1474535820', '249', '1474535820', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '37', '37');
INSERT INTO `gsys_admin_db` VALUES ('91', '0', '快玩12服', '快玩12服', '373770025', '1474992000', 'lyshujian_72', 'lyshujian_72', '-', '-', '12', '88', '-8', '1', '0', '10088', '249', '1474536754', '249', '1474536754', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '72', '72');
INSERT INTO `gsys_admin_db` VALUES ('92', '0', 'lehihi8区', 'lehihi8区', '373770031', '1474992000', 'lyshujian_83', 'lyshujian_83', '-', '-', '8', '89', '-8', '1', '0', '10089', '249', '1474537013', '249', '1474537013', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '83', '83');
INSERT INTO `gsys_admin_db` VALUES ('93', '0', '160yx7服', '160yx7服', '373770029', '1474992000', 'lyshujian_34', 'lyshujian_34', '-', '-', '7', '90', '-8', '1', '0', '10090', '249', '1474537518', '249', '1474537518', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '34', '34');
INSERT INTO `gsys_admin_db` VALUES ('94', '0', '9991wan6区', '9991wan6区', '373770030', '1475078400', 'lyshujian_35', 'lyshujian_35', '-', '-', '6', '91', '-8', '1', '0', '10091', '249', '1474538041', '249', '1474538041', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '35', '35');
INSERT INTO `gsys_admin_db` VALUES ('95', '0', 'OOwan24区', 'OOwan24区', '373770026', '1475164800', 'lyshujian_71', 'lyshujian_71', '-', '-', '24', '92', '-8', '1', '0', '10092', '249', '1474538196', '249', '1474538196', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '71', '71');
INSERT INTO `gsys_admin_db` VALUES ('97', '0', '快玩13服', '快玩13服', '373770025', '1475596800', 'lyshujian_94', 'lyshujian_94', '-', '-', '13', '94', '-8', '1', '0', '10094', '12', '1475139809', '12', '1475139809', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '94', '94');
INSERT INTO `gsys_admin_db` VALUES ('96', '0', '33456-7区', '33456-7区', '373770032', '1475424000', 'lyshujian_37', 'lyshujian_37', '-', '-', '7', '93', '-8', '1', '0', '10093', '12', '1475139809', '12', '1475139809', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '37', '37');
INSERT INTO `gsys_admin_db` VALUES ('98', '0', 'lehihi9区', 'lehihi9区', '373770031', '1475596800', 'lyshujian_83', 'lyshujian_83', '-', '-', '9', '95', '-8', '1', '0', '10095', '12', '1475139809', '12', '1475139809', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '83', '83');
INSERT INTO `gsys_admin_db` VALUES ('99', '0', '160yx8服', '160yx8服', '373770029', '1475596800', 'lyshujian_34', 'lyshujian_34', '-', '-', '8', '96', '-8', '1', '0', '10096', '12', '1475140135', '12', '1475140135', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '34', '34');
INSERT INTO `gsys_admin_db` VALUES ('100', '0', 'OOwan25区', 'OOwan25区', '373770026', '1475769600', 'lyshujian_97', 'lyshujian_97', '-', '-', '25', '97', '-8', '1', '0', '10097', '12', '1475140135', '12', '1475140135', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('101', '0', '33456-8区', '33456-8区', '373770032', '1476028800', 'lyshujian_37', 'lyshujian_37', '-', '-', '8', '98', '-8', '1', '0', '10098', '12', '1475140135', '12', '1475140135', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '37', '37');
INSERT INTO `gsys_admin_db` VALUES ('102', '0', '快玩14服', '快玩14服', '373770025', '1476201600', 'lyshujian_94', 'lyshujian_94', '-', '-', '14', '99', '-8', '1', '0', '10099', '12', '1475140420', '12', '1475140420', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '94', '94');
INSERT INTO `gsys_admin_db` VALUES ('103', '0', 'lehihi10区', 'lehihi10区', '373770031', '1476201600', 'lyshujian_100', 'lyshujian_100', '-', '-', '10', '100', '-8', '1', '0', '10100', '12', '1475140420', '12', '1475140420', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('104', '0', 'OOwan26区', 'OOwan26区', '373770026', '1476374400', 'lyshujian_101', 'lyshujian_101', '-', '-', '26', '101', '-8', '1', '0', '10101', '12', '1475140420', '12', '1475140420', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('105', '0', '2323书剑1服', '2323书剑1服', '373770035', '1476288000', 'lyshujian_102', 'lyshujian_102', '-', '-', '1', '102', '-8', '1', '0', '10102', '265', '1475993681', '265', '1475993681', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('106', '0', '2323书剑2服', '2323书剑2服', '373770035', '1476460800', 'lyshujian_103', 'lyshujian_103', '-', '-', '2', '103', '-8', '1', '0', '10103', '265', '1476008699', '265', '1476008699', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');
INSERT INTO `gsys_admin_db` VALUES ('107', '0', '51wan.la1服', '51wan.la1服', '373770036', '1476928800', 'lyshujian_104', 'lyshujian_104', '-', '-', '1', '104', '-8', '1', '0', '10104', '265', '1476252668', '265', '1476252668', '0', '', '0', 'm_', '', 'develop', 'develop', '', '2', '', '', null, null, null, null, null, null, null, '1', '', '', '', '0', '', '0', '0');

-- ----------------------------
-- Table structure for gsys_admin_port
-- ----------------------------
DROP TABLE IF EXISTS `gsys_admin_port`;
CREATE TABLE `gsys_admin_port` (
  `sysid` int(10) NOT NULL AUTO_INCREMENT COMMENT '自动id',
  `ap_name` varchar(20) NOT NULL COMMENT '端口名',
  `ap_http` int(10) DEFAULT NULL COMMENT 'http端口：对后台或者内网开放',
  `ap_game` int(10) DEFAULT NULL COMMENT 'socket端口：游戏端口',
  `ap_game2` int(10) DEFAULT NULL COMMENT 'socket2端口：游戏端口',
  `ap_game3` int(10) DEFAULT NULL COMMENT 'socket3端口：对后台端口',
  `ap_x` int(10) DEFAULT NULL COMMENT '充值',
  `ap_http2` int(10) DEFAULT NULL COMMENT 'http2端口：对IDIP或者内网开放',
  `ap_http3` int(10) DEFAULT NULL COMMENT 'http3端口：对外网开放',
  PRIMARY KEY (`sysid`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gsys_admin_port
-- ----------------------------
INSERT INTO `gsys_admin_port` VALUES ('1', '端口组1', '6001', '8001', '8002', '0', '9001', '7001', '0');
INSERT INTO `gsys_admin_port` VALUES ('2', '端口组2', '6002', '8003', '8004', '0', '9002', '7002', '0');
INSERT INTO `gsys_admin_port` VALUES ('3', '端口组3', '6003', '8005', '8006', '0', '9003', '7003', '0');
INSERT INTO `gsys_admin_port` VALUES ('4', '端口组4', '6004', '8007', '8008', '0', '9004', '7004', '0');
INSERT INTO `gsys_admin_port` VALUES ('5', '端口组5', '6005', '8009', '8010', '0', '9005', '7005', '0');
INSERT INTO `gsys_admin_port` VALUES ('6', '端口组6', '6006', '8011', '8012', '0', '9006', '7006', '0');
INSERT INTO `gsys_admin_port` VALUES ('7', '端口组7', '6007', '8013', '8014', '0', '9007', '7007', '0');
INSERT INTO `gsys_admin_port` VALUES ('8', '端口组8', '6008', '8015', '8016', '0', '9008', '7008', '0');
INSERT INTO `gsys_admin_port` VALUES ('9', '端口组9', '6009', '8017', '8018', '0', '9009', '7009', '0');
INSERT INTO `gsys_admin_port` VALUES ('10', '端口组10', '6010', '8019', '8020', '0', '9010', '7010', '0');
INSERT INTO `gsys_admin_port` VALUES ('11', '端口组11', '6011', '8021', '8022', '0', '9011', '7011', '0');
INSERT INTO `gsys_admin_port` VALUES ('12', '端口组12', '6012', '8023', '8024', '0', '9012', '7012', '0');
INSERT INTO `gsys_admin_port` VALUES ('13', '端口组13', '6013', '8025', '8026', '0', '9013', '7013', '0');
INSERT INTO `gsys_admin_port` VALUES ('14', '端口组14', '6014', '8027', '8028', '0', '9014', '7014', '0');
INSERT INTO `gsys_admin_port` VALUES ('15', '端口组15', '6015', '8029', '8030', '0', '9015', '7015', '0');

-- ----------------------------
-- Table structure for gsys_admin_role
-- ----------------------------
DROP TABLE IF EXISTS `gsys_admin_role`;
CREATE TABLE `gsys_admin_role` (
  `sysid` int(10) NOT NULL AUTO_INCREMENT COMMENT '自动id',
  `ar_role` varchar(50) NOT NULL COMMENT '角色名',
  `ar_explain` varchar(100) NOT NULL COMMENT '角色说明',
  `ar_zoneid` int(10) DEFAULT NULL COMMENT '区号',
  `ar_vmid` int(10) DEFAULT NULL COMMENT '机器id',
  `ar_tovmid` int(10) DEFAULT '0' COMMENT '后端迁移',
  `ar_createuser` varchar(50) DEFAULT NULL COMMENT '添加管理员名',
  `ar_createtime` int(10) DEFAULT NULL COMMENT '创建时间',
  `ar_updateuser` varchar(50) DEFAULT NULL COMMENT '修改管理员名',
  `ar_updatetime` int(10) DEFAULT NULL COMMENT '修改时间',
  `ar_typeid` int(10) NOT NULL COMMENT '机器业务用途类型',
  `ar_portid` int(10) DEFAULT NULL COMMENT 'java使用,数据库为0',
  `ar_toportid` int(10) DEFAULT '0' COMMENT '端口迁移',
  `ar_ismove` int(2) DEFAULT '0' COMMENT '迁移状态',
  PRIMARY KEY (`sysid`),
  UNIQUE KEY `role` (`ar_role`),
  KEY `ar_zoneid` (`ar_zoneid`) USING BTREE,
  KEY `ar_typeid` (`ar_typeid`) USING BTREE,
  KEY `ar_zoneid_ar_tovmid` (`ar_zoneid`,`ar_tovmid`,`ar_portid`),
  KEY `ar_vmid` (`ar_vmid`)
) ENGINE=MyISAM AUTO_INCREMENT=230 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gsys_admin_role
-- ----------------------------
INSERT INTO `gsys_admin_role` VALUES ('1', 'java_9998', '', '9998', '1', '1', 'shanen12', '1467884646', 'shanen12', '1467884646', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('2', 'mysql_9998', '', '9998', '1', '1', 'shanen12', '1467884665', 'shanen12', '1467884665', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('3', 'LB_weblogin1', '', '0', '3', '3', 'shanen12', '1469088170', 'shanen12', '1469088170', '6', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('4', 'LB_weblogin2', '', '0', '4', '4', 'shanen12', '1469088170', 'shanen12', '1469088170', '6', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('5', 'mysql_1', '', '1', '7', '7', 'shanen12', '1469516373', 'shanen12', '1469516373', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('6', 'java_1', '', '1', '8', '8', 'shanen12', '1469516373', 'shanen12', '1469516373', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('7', 'java_2', '', '2', '8', '8', 'shanen12', '1469516638', 'shanen12', '1469516638', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('8', 'mysql_2', '', '2', '15', '15', 'shanen12', '1469516638', 'shanen12', '1469516638', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('9', 'java_3', '', '3', '19', '19', 'shanen12', '1469516817', 'shanen12', '1469516817', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('10', 'mysql_3', '', '3', '16', '16', 'shanen12', '1469516817', 'shanen12', '1469516817', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('11', 'token', '', '0', '3', '3', 'shanen12', '1469518768', 'shanen12', '1469518768', '7', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('12', 'java_4', '', '4', '8', '8', 'shanen12', '1469698888', 'shanen12', '1469698888', '1', '4', '4', '0');
INSERT INTO `gsys_admin_role` VALUES ('13', 'mysql_4', '', '4', '7', '7', 'shanen12', '1469698888', 'shanen12', '1469698888', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('14', 'java_5', '', '5', '19', '19', 'shanen12', '1469699054', 'shanen12', '1469699054', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('15', 'mysql_5', '', '5', '16', '16', 'shanen12', '1469699054', 'shanen12', '1469699054', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('16', 'game', '', '0', '6', '6', 'shanen12', '1469702029', 'shanen12', '1469702029', '7', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('17', 'gamewebadmin1', '', '0', '5', '5', 'shanen12', '1469702098', 'shanen12', '1469702098', '4', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('18', 'globalServer_1', '世界跨服', '0', '9', '9', 'shanen12', '1470050971', 'shanen12', '1470050971', '12', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('19', 'globalServer_2', '普通跨服', '0', '9', '9', 'shanen12', '1470187816', 'shanen12', '1470187816', '12', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('20', 'java_6', '', '6', '8', '8', 'shanen12', '1470221938', 'shanen12', '1470221938', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('21', 'mysql_6', '', '6', '15', '15', 'shanen12', '1470221938', 'shanen12', '1470221938', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('22', 'java_7', '', '7', '19', '19', 'shanen12', '1470367983', 'shanen12', '1470367983', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('23', 'mysql_7', '', '7', '26', '26', 'shanen12', '1470367983', 'shanen12', '1470367983', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('24', 'java_8', '', '8', '11', '11', 'shanen12', '1470389444', 'shanen12', '1470389444', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('25', 'mysql_8', '', '8', '12', '12', 'shanen12', '1470389444', 'shanen12', '1470389444', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('26', 'java_9', '', '9', '19', '19', 'shanen12', '1470397556', 'shanen12', '1470397556', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('27', 'mysql_9', '', '9', '16', '16', 'shanen12', '1470397556', 'shanen12', '1470397556', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('28', 'java_10', '', '10', '19', '19', 'shanen12', '1470397739', 'shanen12', '1470397739', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('29', 'mysql_10', '', '10', '16', '16', 'shanen12', '1470397739', 'shanen12', '1470397739', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('30', 'java_11', '', '11', '19', '19', 'shanen12', '1470641893', 'shanen12', '1470641893', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('31', 'mysql_11', '', '11', '26', '26', 'shanen12', '1470641893', 'shanen12', '1470641893', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('32', 'java_12', '', '12', '19', '19', 'shanen12', '1470642619', 'shanen12', '1470642619', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('33', 'mysql_12', '', '12', '16', '16', 'shanen12', '1470642619', 'shanen12', '1470642619', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('34', 'java_13', '', '13', '11', '11', 'shanen12', '1470642917', 'shanen12', '1470642917', '1', '6', '6', '0');
INSERT INTO `gsys_admin_role` VALUES ('35', 'mysql_13', '', '13', '12', '12', 'shanen12', '1470642917', 'shanen12', '1470642917', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('36', 'java_14', '', '14', '8', '8', 'shanen12', '1470643080', 'shanen12', '1470643080', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('37', 'mysql_14', '', '14', '15', '15', 'shanen12', '1470643080', 'shanen12', '1470643080', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('38', 'java_15', '', '15', '19', '19', 'shanen12', '1470967911', 'shanen12', '1470967911', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('39', 'mysql_15', '', '15', '26', '26', 'shanen12', '1470967911', 'shanen12', '1470967911', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('40', 'java_16', '', '16', '21', '21', 'shanen12', '1470968324', 'shanen12', '1470968324', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('41', 'mysql_16', '', '16', '15', '15', 'shanen12', '1470968324', 'shanen12', '1470968324', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('42', 'java_17', '', '17', '19', '19', 'shanen12', '1470968499', 'shanen12', '1470968499', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('43', 'mysql_17', '', '17', '26', '26', 'shanen12', '1470968499', 'shanen12', '1470968499', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('44', 'java_18', '', '18', '19', '19', 'shanen12', '1470968656', 'shanen12', '1470968656', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('45', 'mysql_18', '', '18', '16', '16', 'shanen12', '1470968656', 'shanen12', '1470968656', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('46', 'java_19', '', '19', '19', '19', 'shanen12', '1470968806', 'shanen12', '1470968806', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('47', 'mysql_19', '', '19', '16', '16', 'shanen12', '1470968806', 'shanen12', '1470968806', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('48', 'java_20', '', '20', '19', '19', 'shanen12', '1470968945', 'shanen12', '1470968945', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('49', 'mysql_20', '', '20', '26', '26', 'shanen12', '1470968945', 'shanen12', '1470968945', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('50', 'java_21', '', '21', '19', '19', 'shanen12', '1470969048', 'shanen12', '1470969048', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('51', 'mysql_21', '', '21', '26', '26', 'shanen12', '1470969048', 'shanen12', '1470969048', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('52', 'java_22', '', '22', '19', '19', 'shanen12', '1470969577', 'shanen12', '1470969577', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('53', 'mysql_22', '', '22', '16', '16', 'shanen12', '1470969577', 'shanen12', '1470969577', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('54', 'java_23', '', '23', '19', '19', 'shanen12', '1471510163', 'shanen12', '1471510163', '1', '14', '14', '0');
INSERT INTO `gsys_admin_role` VALUES ('55', 'mysql_23', '', '23', '16', '16', 'shanen12', '1471510163', 'shanen12', '1471510163', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('56', 'java_24', '', '24', '19', '19', 'shanen12', '1471510332', 'shanen12', '1471510332', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('57', 'mysql_24', '', '24', '26', '26', 'shanen12', '1471510332', 'shanen12', '1471510332', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('58', 'java_25', '', '25', '19', '19', 'shanen12', '1471510611', 'shanen12', '1471510611', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('59', 'mysql_25', '', '25', '26', '26', 'shanen12', '1471510611', 'shanen12', '1471510611', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('60', 'java_26', '', '26', '21', '21', 'shanen12', '1471511009', 'shanen12', '1471511009', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('61', 'mysql_26', '', '26', '15', '15', 'shanen12', '1471511009', 'shanen12', '1471511009', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('62', 'java_27', '', '27', '19', '19', 'shanen12', '1471512234', 'shanen12', '1471512234', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('63', 'mysql_27', '', '27', '26', '26', 'shanen12', '1471512234', 'shanen12', '1471512234', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('64', 'java_28', '', '28', '19', '19', 'shanen12', '1471512357', 'shanen12', '1471512357', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('65', 'mysql_28', '', '28', '26', '26', 'shanen12', '1471512357', 'shanen12', '1471512357', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('66', 'java_29', '', '29', '19', '19', 'shanen12', '1471512531', 'shanen12', '1471512531', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('67', 'mysql_29', '', '29', '15', '15', 'shanen12', '1471512531', 'shanen12', '1471512531', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('68', 'java_30', '', '30', '19', '19', 'shanen12', '1471512531', 'shanen12', '1471512531', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('69', 'mysql_30', '', '30', '15', '15', 'shanen12', '1471512531', 'shanen12', '1471512531', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('70', 'java_31', '', '31', '19', '19', 'shanen12', '1471512868', 'shanen12', '1471512868', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('71', 'mysql_31', '', '31', '15', '15', 'shanen12', '1471512868', 'shanen12', '1471512868', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('72', 'java_32', '', '32', '19', '19', 'shanen12', '1471512976', 'shanen12', '1471512976', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('73', 'mysql_32', '', '32', '26', '26', 'shanen12', '1471512976', 'shanen12', '1471512976', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('74', 'java_33', '', '33', '21', '21', 'shanen12', '1471513119', 'shanen12', '1471513119', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('75', 'mysql_33', '', '33', '15', '15', 'shanen12', '1471513119', 'shanen12', '1471513119', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('76', 'java_2095', '', '2095', '20', '20', 'yuanguohao', '1471919567', 'yuanguohao', '1471919567', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('77', 'mysql_2095', '', '2095', '20', '20', 'yuanguohao', '1471919595', 'yuanguohao', '1471919595', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('78', 'java_2096', '', '2096', '20', '20', 'yuanguohao', '1471919854', 'yuanguohao', '1471919854', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('79', 'mysql_2096', '', '2096', '20', '20', 'yuanguohao', '1471919879', 'yuanguohao', '1471919879', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('80', 'hefu_1', '', '0', '20', '20', 'yuanguohao', '1471924629', 'yuanguohao', '1471924629', '10', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('82', 'mysql_34', '', '34', '16', '16', 'shanen12', '1472008834', 'shanen12', '1472008834', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('81', 'java_34', '', '34', '19', '19', 'shanen12', '1472008834', 'shanen12', '1472008834', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('83', 'java_35', '', '35', '21', '21', 'shanen12', '1472008999', 'shanen12', '1472008999', '1', '10', '10', '0');
INSERT INTO `gsys_admin_role` VALUES ('84', 'mysql_35', '', '35', '23', '23', 'shanen12', '1472008999', 'shanen12', '1472008999', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('85', 'java_36', '', '36', '19', '19', 'shanen12', '1472009170', 'shanen12', '1472009170', '1', '9', '9', '0');
INSERT INTO `gsys_admin_role` VALUES ('86', 'mysql_36', '', '36', '26', '26', 'shanen12', '1472009170', 'shanen12', '1472009170', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('87', 'java_37', '', '37', '22', '22', 'shanen12', '1472010907', 'shanen12', '1472010907', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('88', 'mysql_37', '', '37', '16', '16', 'shanen12', '1472010907', 'shanen12', '1472010907', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('90', 'mysql_38', '', '38', '26', '26', 'shanen12', '1472120647', 'shanen12', '1472120647', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('89', 'java_38', '', '38', '19', '19', 'shanen12', '1472120647', 'shanen12', '1472120647', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('91', 'java_39', '', '39', '19', '19', 'shanen12', '1472120784', 'shanen12', '1472120784', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('92', 'mysql_39', '', '39', '15', '15', 'shanen12', '1472120784', 'shanen12', '1472120784', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('93', 'java_40', '', '40', '19', '19', 'shanen12', '1472120929', 'shanen12', '1472120929', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('94', 'mysql_40', '', '40', '26', '26', 'shanen12', '1472120929', 'shanen12', '1472120929', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('95', 'java_41', '', '41', '19', '19', 'shanen12', '1472120929', 'shanen12', '1472120929', '1', '12', '12', '0');
INSERT INTO `gsys_admin_role` VALUES ('96', 'mysql_41', '', '41', '7', '7', 'shanen12', '1472120929', 'shanen12', '1472120929', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('97', 'java_42', '', '42', '19', '19', 'shanen12', '1472121153', 'shanen12', '1472121153', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('98', 'mysql_42', '', '42', '26', '26', 'shanen12', '1472121153', 'shanen12', '1472121153', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('99', 'java_43', '', '43', '19', '19', 'shanen12', '1472121837', 'shanen12', '1472121837', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('100', 'mysql_43', '', '43', '15', '15', 'shanen12', '1472121837', 'shanen12', '1472121837', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('101', 'java_44', '', '44', '19', '19', 'shanen12', '1472121837', 'shanen12', '1472121837', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('102', 'mysql_44', '', '44', '15', '15', 'shanen12', '1472121837', 'shanen12', '1472121837', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('103', 'java_45', '', '45', '19', '19', 'shanen12', '1472122072', 'shanen12', '1472122072', '1', '12', '12', '0');
INSERT INTO `gsys_admin_role` VALUES ('104', 'mysql_45', '', '45', '7', '7', 'shanen12', '1472122072', 'shanen12', '1472122072', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('105', 'java_46', '', '46', '19', '19', 'shanen12', '1472122072', 'shanen12', '1472122072', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('106', 'mysql_46', '', '46', '26', '26', 'shanen12', '1472122072', 'shanen12', '1472122072', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('107', 'java_47', '', '47', '19', '19', 'shanen12', '1472122343', 'shanen12', '1472122343', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('108', 'mysql_47', '', '47', '26', '26', 'shanen12', '1472122343', 'shanen12', '1472122343', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('109', 'java_48', '', '48', '19', '19', 'shanen12', '1472122560', 'shanen12', '1472122560', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('110', 'mysql_48', '', '48', '15', '15', 'shanen12', '1472122560', 'shanen12', '1472122560', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('111', 'java_49', '', '49', '19', '19', 'shanen12', '1472122660', 'shanen12', '1472122660', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('112', 'mysql_49', '', '49', '15', '15', 'shanen12', '1472122660', 'shanen12', '1472122660', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('113', 'java_50', '', '50', '21', '21', 'shanen12', '1472122776', 'shanen12', '1472122776', '1', '10', '10', '0');
INSERT INTO `gsys_admin_role` VALUES ('114', 'mysql_50', '', '50', '23', '23', 'shanen12', '1472122776', 'shanen12', '1472122776', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('115', 'java_51', '', '51', '19', '19', 'shanen12', '1472122882', 'shanen12', '1472122882', '1', '9', '9', '0');
INSERT INTO `gsys_admin_role` VALUES ('116', 'mysql_51', '', '51', '26', '26', 'shanen12', '1472122882', 'shanen12', '1472122882', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('117', 'java_52', '', '52', '19', '19', 'zhangyuanyi', '1472435906', 'zhangyuanyi', '1472435906', '1', '12', '12', '0');
INSERT INTO `gsys_admin_role` VALUES ('118', 'mysql_52', '', '52', '7', '7', 'zhangyuanyi', '1472435906', 'zhangyuanyi', '1472435906', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('119', 'hefu_2', '', '0', '21', '21', 'liuhuisi', '1472633817', 'liuhuisi', '1472633817', '10', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('126', 'java_55', '', '55', '19', '19', 'shanen12', '1472718363', 'shanen12', '1472718363', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('121', 'hefu_3', '', '0', '22', '22', 'liuhuisi', '1472634985', 'liuhuisi', '1472634985', '10', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('125', 'mysql_54', '', '54', '26', '26', 'shanen12', '1472718363', 'shanen12', '1472718363', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('123', 'mysql_53', '', '53', '26', '26', 'shanen12', '1472718363', 'shanen12', '1472718363', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('124', 'java_54', '', '54', '19', '19', 'shanen12', '1472718363', 'shanen12', '1472718363', '1', '9', '9', '0');
INSERT INTO `gsys_admin_role` VALUES ('122', 'java_53', '', '53', '19', '19', 'shanen12', '1472718363', 'shanen12', '1472718363', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('127', 'mysql_55', '', '55', '26', '26', 'shanen12', '1472718363', 'shanen12', '1472718363', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('128', 'java_56', '', '56', '22', '22', 'shanen12', '1472718795', 'shanen12', '1472718795', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('129', 'mysql_56', '', '56', '16', '16', 'shanen12', '1472718795', 'shanen12', '1472718795', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('130', 'java_57', '', '57', '19', '19', 'shanen12', '1472718795', 'shanen12', '1472718795', '1', '13', '13', '0');
INSERT INTO `gsys_admin_role` VALUES ('131', 'mysql_57', '', '57', '15', '15', 'shanen12', '1472718795', 'shanen12', '1472718795', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('132', 'java_58', '', '58', '21', '21', 'shanen12', '1472719189', 'shanen12', '1472719189', '1', '6', '6', '0');
INSERT INTO `gsys_admin_role` VALUES ('133', 'mysql_58', '', '58', '15', '15', 'shanen12', '1472719189', 'shanen12', '1472719189', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('134', 'java_59', '', '59', '19', '19', 'shanen12', '1472719189', 'shanen12', '1472719189', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('135', 'mysql_59', '', '59', '26', '26', 'shanen12', '1472719189', 'shanen12', '1472719189', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('136', 'java_60', '', '60', '21', '21', 'shanen12', '1472719528', 'shanen12', '1472719528', '1', '10', '10', '0');
INSERT INTO `gsys_admin_role` VALUES ('137', 'mysql_60', '', '60', '23', '23', 'shanen12', '1472719528', 'shanen12', '1472719528', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('138', 'java_61', '', '61', '19', '19', 'shanen12', '1472719528', 'shanen12', '1472719528', '1', '7', '7', '0');
INSERT INTO `gsys_admin_role` VALUES ('139', 'mysql_61', '', '61', '15', '15', 'shanen12', '1472719528', 'shanen12', '1472719528', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('140', 'java_62', '', '62', '22', '22', 'shanen12', '1472720972', 'shanen12', '1472720972', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('141', 'mysql_62', '', '62', '16', '16', 'shanen12', '1472720972', 'shanen12', '1472720972', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('142', 'java_63', '', '63', '19', '19', 'shanen12', '1472720972', 'shanen12', '1472720972', '1', '7', '7', '0');
INSERT INTO `gsys_admin_role` VALUES ('143', 'mysql_63', '', '63', '15', '15', 'shanen12', '1472720972', 'shanen12', '1472720972', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('144', 'java_64', '', '64', '19', '19', 'shanen12', '1472720972', 'shanen12', '1472720972', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('145', 'mysql_64', '', '64', '26', '26', 'shanen12', '1472720972', 'shanen12', '1472720972', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('146', 'java_65', '', '65', '11', '11', 'shanen12', '1472798672', 'shanen12', '1472798672', '1', '9', '9', '0');
INSERT INTO `gsys_admin_role` VALUES ('147', 'mysql_65', '', '65', '12', '12', 'shanen12', '1472798672', 'shanen12', '1472798672', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('149', 'mysql_66', '', '66', '15', '15', 'shanen12', '1473325335', 'shanen12', '1473325335', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('150', 'java_67', '', '67', '19', '19', 'shanen12', '1473325335', 'shanen12', '1473325335', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('148', 'java_66', '', '66', '19', '19', 'shanen12', '1473325335', 'shanen12', '1473325335', '1', '7', '7', '0');
INSERT INTO `gsys_admin_role` VALUES ('152', 'java_68', '', '68', '21', '21', 'shanen12', '1473325335', 'shanen12', '1473325335', '1', '6', '6', '0');
INSERT INTO `gsys_admin_role` VALUES ('151', 'mysql_67', '', '67', '16', '16', 'shanen12', '1473325335', 'shanen12', '1473325335', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('153', 'mysql_68', '', '68', '15', '15', 'shanen12', '1473325335', 'shanen12', '1473325335', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('154', 'java_69', '', '69', '19', '19', 'shanen12', '1473325335', 'shanen12', '1473325335', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('155', 'mysql_69', '', '69', '26', '26', 'shanen12', '1473325335', 'shanen12', '1473325335', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('156', 'java_70', '', '70', '19', '19', 'shanen12', '1473325873', 'shanen12', '1473325873', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('157', 'mysql_70', '', '70', '16', '16', 'shanen12', '1473325873', 'shanen12', '1473325873', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('158', 'java_71', '', '71', '19', '19', 'shanen12', '1473325873', 'shanen12', '1473325873', '1', '6', '6', '0');
INSERT INTO `gsys_admin_role` VALUES ('159', 'mysql_71', '', '71', '16', '16', 'shanen12', '1473325873', 'shanen12', '1473325873', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('160', 'java_72', '', '72', '21', '21', 'shanen12', '1473325873', 'shanen12', '1473325873', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('161', 'mysql_72', '', '72', '23', '23', 'shanen12', '1473325873', 'shanen12', '1473325873', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('162', 'java_73', '', '73', '21', '21', 'shanen12', '1473326566', 'shanen12', '1473326566', '1', '6', '6', '0');
INSERT INTO `gsys_admin_role` VALUES ('163', 'mysql_73', '', '73', '15', '15', 'shanen12', '1473326566', 'shanen12', '1473326566', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('164', 'java_74', '', '74', '19', '19', 'shanen12', '1473326825', 'shanen12', '1473326825', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('165', 'mysql_74', '', '74', '16', '16', 'shanen12', '1473326825', 'shanen12', '1473326825', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('166', 'java_75', '', '75', '19', '19', 'shanen12', '1473326996', 'shanen12', '1473326996', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('167', 'mysql_75', '', '75', '26', '26', 'shanen12', '1473326996', 'shanen12', '1473326996', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('168', 'java_76', '', '76', '21', '21', 'shanen12', '1473327085', 'shanen12', '1473327085', '1', '10', '10', '0');
INSERT INTO `gsys_admin_role` VALUES ('169', 'mysql_76', '', '76', '23', '23', 'shanen12', '1473327085', 'shanen12', '1473327085', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('170', 'java_77', '', '77', '19', '19', 'shanen12', '1473327166', 'shanen12', '1473327166', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('171', 'mysql_77', '', '77', '26', '26', 'shanen12', '1473327166', 'shanen12', '1473327166', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('172', 'java_78', '', '78', '19', '19', 'shanen12', '1473327257', 'shanen12', '1473327257', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('173', 'mysql_78', '', '78', '26', '26', 'shanen12', '1473327257', 'shanen12', '1473327257', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('174', 'java_79', '', '79', '22', '22', 'shanen12', '1473327681', 'shanen12', '1473327681', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('175', 'mysql_79', '', '79', '16', '16', 'shanen12', '1473327681', 'shanen12', '1473327681', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('176', 'java_80', '', '80', '19', '19', 'pengxuming', '1473836305', 'pengxuming', '1473836305', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('177', 'mysql_80', '', '80', '16', '16', 'pengxuming', '1473836305', 'pengxuming', '1473836305', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('178', 'java_81', '', '81', '22', '22', 'pengxuming', '1473837070', 'pengxuming', '1473837070', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('179', 'mysql_81', '', '81', '16', '16', 'pengxuming', '1473837070', 'pengxuming', '1473837070', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('180', 'java_82', '', '82', '21', '21', 'pengxuming', '1473837192', 'pengxuming', '1473837192', '1', '10', '10', '0');
INSERT INTO `gsys_admin_role` VALUES ('181', 'mysql_82', '', '82', '23', '23', 'pengxuming', '1473837192', 'pengxuming', '1473837192', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('182', 'java_83', '', '83', '21', '21', 'pengxuming', '1473837308', 'pengxuming', '1473837308', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('183', 'mysql_83', '', '83', '16', '16', 'pengxuming', '1473837308', 'pengxuming', '1473837308', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('184', 'java_84', '', '84', '21', '21', 'pengxuming', '1474187153', 'pengxuming', '1474187153', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('185', 'mysql_84', '', '84', '23', '23', 'pengxuming', '1474187153', 'pengxuming', '1474187153', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('186', 'java_85', '', '85', '19', '19', 'pengxuming', '1474187495', 'pengxuming', '1474187495', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('187', 'mysql_85', '', '85', '16', '16', 'pengxuming', '1474187495', 'pengxuming', '1474187495', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('188', 'java_86', '', '86', '19', '19', 'pengxuming', '1474187645', 'pengxuming', '1474187645', '1', '6', '6', '0');
INSERT INTO `gsys_admin_role` VALUES ('189', 'mysql_86', '', '86', '16', '16', 'pengxuming', '1474187645', 'pengxuming', '1474187645', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('190', 'java_87', '', '87', '22', '22', 'wenqipeng', '1474535716', 'wenqipeng', '1474535716', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('191', 'mysql_87', '', '87', '16', '16', 'wenqipeng', '1474535716', 'wenqipeng', '1474535716', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('192', 'java_88', '', '88', '21', '21', 'wenqipeng', '1474536610', 'wenqipeng', '1474536610', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('193', 'mysql_88', '', '88', '23', '23', 'wenqipeng', '1474536610', 'wenqipeng', '1474536610', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('194', 'java_89', '', '89', '21', '21', 'wenqipeng', '1474536893', 'wenqipeng', '1474536893', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('195', 'mysql_89', '', '89', '16', '16', 'wenqipeng', '1474536893', 'wenqipeng', '1474536893', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('196', 'java_90', '', '90', '19', '19', 'wenqipeng', '1474537397', 'wenqipeng', '1474537397', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('197', 'mysql_90', '', '90', '16', '16', 'wenqipeng', '1474537397', 'wenqipeng', '1474537397', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('198', 'java_91', '', '91', '21', '21', 'wenqipeng', '1474537945', 'wenqipeng', '1474537945', '1', '10', '10', '0');
INSERT INTO `gsys_admin_role` VALUES ('199', 'mysql_91', '', '91', '23', '23', 'wenqipeng', '1474537945', 'wenqipeng', '1474537945', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('200', 'java_92', '', '92', '19', '19', 'wenqipeng', '1474538134', 'wenqipeng', '1474538134', '1', '6', '6', '0');
INSERT INTO `gsys_admin_role` VALUES ('201', 'mysql_92', '', '92', '16', '16', 'wenqipeng', '1474538134', 'wenqipeng', '1474538134', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('202', 'hefu_4', '', '0', '8', '8', 'yuanguohao', '1474540520', 'yuanguohao', '1474540520', '10', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('203', 'hefu_5', '', '0', '11', '11', 'yuanguohao', '1474540520', 'yuanguohao', '1474540520', '10', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('204', 'hefu_6', '', '0', '19', '19', 'yuanguohao', '1474540520', 'yuanguohao', '1474540520', '10', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('205', 'hefu_7', '', '0', '25', '25', 'yuanguohao', '1474540520', 'yuanguohao', '1474540520', '10', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('221', 'mysql_100', '', '100', '23', '23', 'shanen12', '1475140278', 'shanen12', '1475140278', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('222', 'java_101', '', '101', '22', '22', 'shanen12', '1475140278', 'shanen12', '1475140278', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('223', 'mysql_101', '', '101', '7', '7', 'shanen12', '1475140278', 'shanen12', '1475140278', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('224', 'java_102', '', '102', '21', '21', 'shanen12', '1475993123', 'shanen12', '1475993123', '1', '7', '7', '0');
INSERT INTO `gsys_admin_role` VALUES ('220', 'java_100', '', '100', '19', '19', 'shanen12', '1475140278', 'shanen12', '1475140278', '1', '10', '10', '0');
INSERT INTO `gsys_admin_role` VALUES ('219', 'mysql_99', '', '99', '23', '23', 'shanen12', '1475140278', 'shanen12', '1475140278', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('227', 'mysql_103', '', '103', '16', '16', 'pengxuming', '1476006997', 'pengxuming', '1476006997', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('226', 'java_103', '', '103', '22', '22', 'pengxuming', '1476006997', 'pengxuming', '1476006997', '1', '6', '6', '0');
INSERT INTO `gsys_admin_role` VALUES ('225', 'mysql_102', '', '102', '23', '23', 'shanen12', '1475993123', 'shanen12', '1475993123', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('215', 'mysql_97', '', '97', '7', '7', 'shanen12', '1475139964', 'shanen12', '1475139964', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('213', 'mysql_96', '', '96', '16', '16', 'shanen12', '1475139964', 'shanen12', '1475139964', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('212', 'java_96', '', '96', '19', '19', 'shanen12', '1475139964', 'shanen12', '1475139964', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('217', 'mysql_98', '', '98', '16', '16', 'shanen12', '1475139964', 'shanen12', '1475139964', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('216', 'java_98', '', '98', '22', '22', 'shanen12', '1475139964', 'shanen12', '1475139964', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('214', 'java_97', '', '97', '19', '19', 'shanen12', '1475139964', 'shanen12', '1475139964', '1', '8', '8', '0');
INSERT INTO `gsys_admin_role` VALUES ('206', 'java_93', '', '93', '22', '22', 'shanen12', '1475139638', 'shanen12', '1475139638', '1', '1', '1', '0');
INSERT INTO `gsys_admin_role` VALUES ('207', 'mysql_93', '', '93', '16', '16', 'shanen12', '1475139638', 'shanen12', '1475139638', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('208', 'java_94', '', '94', '22', '22', 'shanen12', '1475139638', 'shanen12', '1475139638', '1', '7', '7', '0');
INSERT INTO `gsys_admin_role` VALUES ('209', 'mysql_94', '', '94', '23', '23', 'shanen12', '1475139638', 'shanen12', '1475139638', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('210', 'java_95', '', '95', '21', '21', 'shanen12', '1475139638', 'shanen12', '1475139638', '1', '5', '5', '0');
INSERT INTO `gsys_admin_role` VALUES ('211', 'mysql_95', '', '95', '16', '16', 'shanen12', '1475139638', 'shanen12', '1475139638', '2', '0', '0', '0');
INSERT INTO `gsys_admin_role` VALUES ('218', 'java_99', '', '99', '22', '22', 'shanen12', '1475140278', 'shanen12', '1475140278', '1', '7', '7', '0');
INSERT INTO `gsys_admin_role` VALUES ('228', 'java_104', '', '104', '25', '25', 'pengxuming', '1476252183', 'pengxuming', '1476252183', '1', '2', '2', '0');
INSERT INTO `gsys_admin_role` VALUES ('229', 'mysql_104', '', '104', '16', '16', 'pengxuming', '1476252183', 'pengxuming', '1476252183', '2', '0', '0', '0');

-- ----------------------------
-- Table structure for gsys_admin_type
-- ----------------------------
DROP TABLE IF EXISTS `gsys_admin_type`;
CREATE TABLE `gsys_admin_type` (
  `sysid` int(10) NOT NULL AUTO_INCREMENT COMMENT '自动id',
  `at_type` varchar(50) NOT NULL COMMENT '机器业务用途类型',
  PRIMARY KEY (`sysid`)
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of gsys_admin_type
-- ----------------------------
INSERT INTO `gsys_admin_type` VALUES ('1', '游戏服后端');
INSERT INTO `gsys_admin_type` VALUES ('2', '游戏服数据库');
INSERT INTO `gsys_admin_type` VALUES ('3', '管理机');
INSERT INTO `gsys_admin_type` VALUES ('4', '后台');
INSERT INTO `gsys_admin_type` VALUES ('5', '发货接口集群');
INSERT INTO `gsys_admin_type` VALUES ('6', '前端登录集群');
INSERT INTO `gsys_admin_type` VALUES ('7', '中央数据库');
INSERT INTO `gsys_admin_type` VALUES ('8', '外部接口集群');
INSERT INTO `gsys_admin_type` VALUES ('9', '反向代理');
INSERT INTO `gsys_admin_type` VALUES ('10', '合服加工机');
INSERT INTO `gsys_admin_type` VALUES ('11', '数据拉取服务器');
INSERT INTO `gsys_admin_type` VALUES ('12', '跨服战功能服务器后端');
INSERT INTO `gsys_admin_type` VALUES ('13', '备份');
INSERT INTO `gsys_admin_type` VALUES ('14', '跨服战功能服务器DB');
INSERT INTO `gsys_admin_type` VALUES ('15', '中央游戏库');
INSERT INTO `gsys_admin_type` VALUES ('16', '日志分析服务器');

-- ----------------------------
-- Table structure for gsys_admin_vm
-- ----------------------------
DROP TABLE IF EXISTS `gsys_admin_vm`;
CREATE TABLE `gsys_admin_vm` (
  `sysid` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '虚拟主机的ID',
  `av_vmip` varchar(100) NOT NULL DEFAULT '0' COMMENT '虚拟主机ip,不唯一',
  `av_mastermark` tinyint(2) NOT NULL DEFAULT '0' COMMENT '主从标记',
  `av_masterid` int(10) NOT NULL DEFAULT '0' COMMENT '若为从机则要求输入主机ID',
  `av_hostname` varchar(100) NOT NULL DEFAULT '0' COMMENT '主机名称',
  `av_domainname` varchar(100) NOT NULL DEFAULT '0' COMMENT '主机域名',
  `av_publicip` varchar(100) NOT NULL COMMENT '公网IP',
  `av_vmtype` varchar(100) NOT NULL DEFAULT '0' COMMENT '机器的类型',
  `av_vmos` varchar(100) NOT NULL DEFAULT '0' COMMENT '主机操作系统',
  `av_status` int(10) NOT NULL DEFAULT '2' COMMENT '主机状态:online,preuse,free,offline',
  `av_dbport` int(10) NOT NULL DEFAULT '0' COMMENT '数据库端口',
  `av_dbpass` varchar(100) NOT NULL DEFAULT '0' COMMENT '数据库密码',
  `av_platform` varchar(100) NOT NULL DEFAULT '' COMMENT '平台',
  `av_project` varchar(100) NOT NULL DEFAULT 'yt' COMMENT '项目',
  `av_account` varchar(100) NOT NULL DEFAULT '0' COMMENT '添加人账号',
  `av_createtime` int(10) NOT NULL DEFAULT '0' COMMENT '添加时间',
  `av_updateaccount` varchar(100) NOT NULL DEFAULT '0' COMMENT '修改账号',
  `av_updatetime` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  `av_servertype` int(10) NOT NULL COMMENT '服务器类型',
  `av_timezone` varchar(50) NOT NULL DEFAULT '-8' COMMENT '时区',
  PRIMARY KEY (`sysid`),
  KEY `vmip` (`av_vmip`) USING BTREE,
  KEY `av_masterid` (`av_masterid`) USING BTREE,
  KEY `av_domainname` (`av_domainname`,`av_dbport`),
  KEY `av_domainname_dbport` (`av_domainname`,`av_dbport`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COMMENT='机器信息表,每台机器是唯一的';

-- ----------------------------
-- Records of gsys_admin_vm
-- ----------------------------
INSERT INTO `gsys_admin_vm` VALUES ('1', '172.16.136.12', '0', '0', 'test_104_114_96', '123.207.100.165', '123.207.100.165', 'CS1', 'centos6.2', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1467884243', 'shanen12', '1467884243', '5', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('2', '10.12.12.12', '0', '0', 'mgr_104_32_186', '119.29.22.30', '119.29.22.30', 'CS1', 'centos6.2', '4', '0', '-', 'ly', 'shujian', 'shanen12', '1467884423', 'shanen12', '1467884423', '8', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('3', '10.104.166.127', '0', '0', 'web_104_166_127', '10.111.111.111', '123.207.87.133', 'CS1', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1469004399', 'shanen12', '1469004399', '4', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('4', '127.0.0.1', '0', '0', 'web_104_138_254', '123.207.126.222', '123.207.126.222', 'CS1', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1469004399', 'shanen12', '1469004399', '4', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('5', '10.135.36.73', '0', '0', 'mgr_135_36_73', '-', '123.207.228.237', 'CS1', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1469351247', 'shanen12', '1469351247', '8', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('6', '10.66.158.163', '0', '0', 'web_66_158_163', '-', '-', 'CDB', 'cdb', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1469434131', 'shanen12', '1469515682', '4', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('7', '10.135.49.112', '1', '0', 'mysql_135_49_112', '-', '123.207.229.16', 'VB3', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1469515934', 'shanen12', '1469515934', '2', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('8', '172.16.83.18 ', '0', '0', 'erlang_135_44_85', '123.207.116.201', '123.207.116.201', 'VC3', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1469515934', 'shanen12', '1469515934', '1', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('9', '10.135.50.109', '0', '0', 'kua_135_50_109', '123.207.108.238', '123.207.108.238', 'CS1', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1469515934', 'shanen12', '1469515934', '1', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('10', '10.135.56.117', '2', '7', 'slave_56_117-3306', '-', '123.207.227.47', 'VC2', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1469702479', 'shanen12', '1469702479', '3', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('11', '172.16.85.19', '0', '0', 'erlang_104_81_139', '123.207.231.217', '123.207.231.217', 'VC3', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1470382509', 'shanen12', '1470382586', '1', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('12', '10.104.249.55', '1', '0', 'mysql_104_249_55', '-', '123.207.232.229', 'VB3', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1470382580', 'shanen12', '1470382580', '2', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('13', '10.135.56.117', '2', '12', 'slave_56_117-3307', '-', '-', 'VC2', 'centos6.x', '1', '3307', '', 'ly', 'shujian', 'shanen12', '1470382745', 'shanen12', '1470382745', '3', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('14', '172.16.85.22', '0', '0', 'erlang_104_105_180', '123.207.236.193', '123.207.236.193', 'CSVC3', 'centos6.x', '4', '0', '-', 'ly', 'shujian', 'shanen12', '1470965233', 'shanen12', '1470965233', '1', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('15', '10.104.80.122', '1', '0', 'mysql_104_80_122', '-', '123.207.238.117', 'CSVB3', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1470965233', 'shanen12', '1470965233', '2', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('16', '10.104.101.38', '1', '0', 'mysql_104_101_38', '-', '123.207.237.102', 'CSVB3', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1470965233', 'shanen12', '1470965233', '2', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('17', '10.135.56.117', '2', '16', 'slave_56_117-3308', '-', '-', 'VC2', 'centos6.x', '1', '3308', '', 'ly', 'shujian', 'shanen12', '1470968095', 'shanen12', '1470968095', '3', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('18', '10.135.56.117', '2', '15', 'slave_56_117-3309', '-', '-', 'VC2', 'centos6.x', '1', '3309', '', 'ly', 'shujian', 'shanen12', '1470968095', 'shanen12', '1470968095', '3', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('19', '172.16.85.7', '0', '0', 'erlang_104_95_210', '123.207.118.191', '123.207.118.191', 'CSVC3', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1471511706', 'shanen12', '1471511706', '1', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('20', '10.104.233.134', '0', '0', 'hefu_104_233_134', '123.207.99.11', '123.207.99.11', 'CS1', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'yuanguohao', '1471919256', 'yuanguohao', '1471919256', '5', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('21', '172.16.85.10', '0', '0', 'erlang_104_99_171', '119.29.233.168', '119.29.233.168', 'CSVC3', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1472002652', 'shanen12', '1472002683', '1', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('22', '172.16.85.8', '0', '0', 'erlang_104_118_49', '123.207.95.201', '123.207.95.201', 'CSVC3', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1472119068', 'shanen12', '1472119068', '1', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('23', '10.104.121.96', '1', '0', 'mysql_104_121_96', '-', '123.207.93.233', 'CSVB3', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1472119068', 'shanen12', '1472119068', '2', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('24', '10.104.104.228', '2', '23', 'slave_104_228-3306', '-', '123.207.90.160', 'CSVC2', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1472119137', 'shanen12', '1473325142', '3', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('25', '172.16.102.22', '0', '0', 'erlang_104_245_216', '123.207.118.81', '123.207.118.81', 'CSVC3', 'centos6.x', '1', '0', '-', 'ly', 'shujian', 'shanen12', '1473322409', 'shanen12', '1473322409', '1', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('26', '10.104.250.116', '1', '0', 'mysql_104_250_116', '-', '123.207.97.214', 'CSVB3', 'centos6.x', '1', '3306', '', 'ly', 'shujian', 'shanen12', '1473322409', 'shanen12', '1473322409', '2', '-8');
INSERT INTO `gsys_admin_vm` VALUES ('27', '10.104.104.228', '2', '26', 'slave_104_228-3307', '-', '-', 'CSVC2', 'centos6.x', '1', '3307', '', 'ly', 'shujian', 'shanen12', '1473325209', 'shanen12', '1473325209', '3', '-8');

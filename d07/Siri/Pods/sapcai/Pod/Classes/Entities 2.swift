//
//  Entities.swift
//  SAP Conversational AI Official iOS SDK
//
//  Created by Pierre-Edouard LIEB on 24/03/2016.
//

import Foundation
import ObjectMapper

/**
 Entities class. This is the list of the current entities detected:
 - age
 - cardinal
 - color
 - datetime
 - distance
 - duration
 - email
 - ip
 - language
 - location
 - mass
 - misc
 - money
 - nationality
 - number
 - ordinal
 - organization
 - percent
 - person
 - pronoun
 - set
 - sort
 - speed
 - temperature
 - url
 - volume
 - custom
 */

public class Entities : Mappable
{
    public var cardinals : [Cardinal]?
    public var colors : [Color]?
    public var datetimes : [Datetime]?
    public var distances : [Distance]?
    public var durations : [Duration]?
    public var emails : [Email]?
    public var emojis : [Emoji]?
    public var ips : [IP]?
    public var intervals : [Interval]?
    public var jobs : [Job]?
    public var languages : [Language]?
    public var locations : [Location]?
    public var masses : [Mass]?
    public var moneys : [Money]?
    public var nationalities : [Nationality]?
    public var numbers : [Number]?
    public var ordinals : [Ordinal]?
    public var organizations : [Organization]?
    public var percents : [Percent]?
    public var persons : [Person]?
    public var phone : [Phone]?
    public var pronouns : [Pronoun]?
    public var sets : [Set]?
    public var sorts : [Sort]?
    public var speeds : [Speed]?
    public var temperatures : [Temperature]?
    public var urls : [Url]?
    public var volumes : [Volume]?
    public var customs : [String:[Custom]]?
    
    /**
     Init class map
     */
    
    required public init?(map: Map){

    }
    
    // Mappable
    public func mapping(map: Map) {
        cardinals       <- map["cardinal"]
        colors          <- map["color"]
        datetimes       <- map["datetime"]
        distances       <- map["distance"]
        durations       <- map["duration"]
        emails          <- map["email"]
        emojis          <- map["emoji"]
        ips             <- map["ip"]
        intervals       <- map["interval"]
        jobs            <- map["job"]
        languages       <- map["language"]
        locations       <- map["location"]
        masses          <- map["masse"]
        moneys          <- map["money"]
        nationalities   <- map["nationalitie"]
        numbers         <- map["number"]
        ordinals        <- map["ordinal"]
        organizations   <- map["organization"]
        percents        <- map["percent"]
        persons         <- map["person"]
        phone           <- map["phone"]
        pronouns        <- map["pronoun"]
        sets            <- map["set"]
        sorts           <- map["sort"]
        speeds          <- map["speed"]
        temperatures    <- map["temperature"]
        urls            <- map["url"]
        volumes         <- map["volume"]
        customs         <- map["custom"]
    }
}

/**
 Struct Cardinal
 
 Examples :	north, southeast, north-west
 
 Key:
 - bearing: Float, the cardinal point bearing in degrees
 - raw: The raw value extracted for the sentence
 */
public class Cardinal : Mappable, CustomStringConvertible
{
    public var bearing : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Bearing(deg : \(bearing), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        bearing     <- map["bearing"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Color
 
 Examples :	blue, red, orange
 
 Key:
 - hex: String, the hexadecimal value of the color
 - raw: The raw value extracted for the sentence
 */
public class Color : Mappable, CustomStringConvertible
{
    public var rgb : String = ""
    public var hex : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Color(hex : \(hex), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        rgb         <- map["rgb"]
        hex         <- map["hex"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Datetime
 
 Examples :	the next friday, today, September 7 2016
 
 Key:
 - value: Integer, the unix timestamp of the datetime
 - raw: The raw value extracted for the sentence
 */
public class Datetime : Mappable, CustomStringConvertible
{
    public var formatted : String = ""
    public var iso : String = ""
    public var accuracy : String = ""
    public var chronology : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Datetime(formatted : \(formatted), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        formatted   <- map["formatted"]
        iso         <- map["iso"]
        accuracy    <- map["accuracy"]
        chronology  <- map["chronology"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Distance
 
 Examples :	20 meters, seven miles
 
 Key:
 - value: Float, the countable
 - unit: String, the quantifier
 - raw: The raw value extracted for the sentence
 */
public class Distance : Mappable, CustomStringConvertible
{
    public var scalar : Float = 0.0
    public var unit : String = ""
    public var meters : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Distance(scalar : \(scalar), unit : \(unit), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        scalar      <- map["scalar"]
        unit        <- map["unit"]
        meters      <- map["meters"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Duration
 
 Examples :	five days, one year
 
 Key:
 - value: Integer, the number of seconds in this span
 - raw: The raw value extracted for the sentence
 */
public class Duration : Mappable, CustomStringConvertible
{
    public var chrono : String = ""
    public var years : Float = 0.0
    public var months : Float = 0.0
    public var days : Float = 0.0
    public var hours : Float = 0.0
    public var minutes : Float = 0.0
    public var seconds : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Duration(chrono : \(chrono), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        chrono      <- map["chrono"]
        years       <- map["years"]
        months      <- map["months"]
        days        <- map["days"]
        hours       <- map["hours"]
        minutes     <- map["minutes"]
        seconds     <- map["seconds"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Email
 
 Examples :	hello@example.com, hello+devs@example.com
 
 Key:
 - value: String, the downcased email
 - raw: The raw value extracted for the sentence
 */
public class Email : Mappable, CustomStringConvertible
{
    public var local : String = ""
    public var tag : String = ""
    public var domain : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Email(local : \(local), domain : \(domain), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        local       <- map["local"]
        tag         <- map["tag"]
        domain      <- map["domain"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Emoji
 
 Examples : emoji	:), :heart:, 🙂
 
 Key:
 - formatted: the value
 - feeling: the value
 - tags: the value
 - unicode: the value
 - description: the value
 - raw: The raw value extracted for the sentence
 */
public class Emoji : Mappable, CustomStringConvertible
{
    public var formatted : String = ""
    public var feeling : String = ""
    public var tags : [String] = []
    public var unicode : String = ""
    public var descriptionEmoji : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Emoji(formatted : \(formatted), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        formatted           <- map["formatted"]
        feeling             <- map["feeling"]
        tags                <- map["tags"]
        unicode             <- map["unicode"]
        descriptionEmoji    <- map["description"]
        raw                 <- map["raw"]
        confidence          <- map["confidence"]
    }
}

/**
 Struct IP
 
 Examples :	127.0.0.1
 
 Key:
 - formated: String, the full denomination of the ip’s location
 - lat: Float, the latitude of the ip’s location
 - lng: Float, the longitude of the ip’s location
 - raw: The raw value extracted for the sentence
 */
public class IP : Mappable, CustomStringConvertible
{
    public var formated : String = ""
    public var lat : Float = 0.0
    public var lng : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "IP(formated : \(formated), lat : \(lat), lng : \(lng), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        formated    <- map["formated"]
        lat         <- map["lat"]
        lng         <- map["lng"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Interval
 
 Examples :	between today and tomorrow, from now to next week, wednesday the 3rd between 2pm and 3pm, starting sunday ending monday
 
 Key:
 - value: String, the downcased job
 - raw: The raw value extracted for the sentence
 */
public class Interval : Mappable, CustomStringConvertible
{
    public var begin : String = ""
    public var end : String = ""
    public var begin_chronology : String = ""
    public var end_chronology : String = ""
    public var begin_accuracy : String = ""
    public var end_accuracy : String = ""
    public var timespan : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Interval(begin : \(begin), end : \(end), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        begin               <- map["begin"]
        end                 <- map["end"]
        begin_chronology    <- map["begin_chronology"]
        end_chronology      <- map["end_chronology"]
        begin_accuracy      <- map["begin_accuracy"]
        end_accuracy        <- map["end_accuracy"]
        timespan            <- map["timespan"]
        raw                 <- map["raw"]
        confidence          <- map["confidence"]
    }
}

/**
 Struct Job
 
 Examples :	CTO, farmer, financial accoutant
 
 Key:
 - value: String, the downcased job
 - raw: The raw value extracted for the sentence
 */
public class Job : Mappable, CustomStringConvertible
{
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Job(raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Language
 
 Examples :	French, Hindi, Russian
 
 Key:
 - code: String, the language code. Follows the ISO 639-1 standard
 - raw: The raw value extracted for the sentence
 */
public class Language : Mappable, CustomStringConvertible
{
    public var short : String = ""
    public var long : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Language(short : \(short), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        short       <- map["short"]
        long        <- map["long"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Location
 
 Examples :	San Francisco, Paris, France
 
 Key:
 - formated: String, the full denomination of the location
 - lat: Float, the latitude of the location
 - lng: Float, the longitude of the location
 - raw: The raw value extracted for the sentence
 */
public class Location : Mappable, CustomStringConvertible
{
    public var formated : String = ""
    public var lat : Float = 0.0
    public var lng : Float = 0.0
    public var place : String = ""
    public var type : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Location(formated : \(formated), lat : \(lat), lng : \(lng), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        formated    <- map["formated"]
        lat         <- map["lat"]
        lng         <- map["lng"]
        place       <- map["place"]
        type        <- map["type"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Mass
 
 Examples :	45 pounds, twenty-one grams
 
 Key:
 - value: Float, the countable
 - unit: String, the quantifier. Can be lbs (pounds), kg (kilograms), g (grams), oz (ounces), etc.
 - raw: The raw value extracted for the sentence
 */
public class Mass : Mappable, CustomStringConvertible
{
    public var scalar : Float = 0.0
    public var unit : String = ""
    public var grams : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Mass(scalar : \(scalar), unit : \(unit), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        scalar       <- map["scalar"]
        unit        <- map["unit"]
        grams       <- map["grams"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Money
 
 Examples :	3.14 euros, eight millions dollars, $6
 
 Key:
 - value: Float, the countable
 - unit: String, the currency. Follows the ISO 4217 standard
 - raw: The raw value extracted for the sentence
 */
public class Money : Mappable, CustomStringConvertible
{
    public var amount : Float = 0.0
    public var currency : String = ""
    public var dollars : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Money(amount : \(amount), currency : \(currency), dollars : \(dollars), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        amount      <- map["amount"]
        currency    <- map["currency"]
        dollars     <- map["dollars"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Nationality
 
 Examples :	French, Spanish, Australian
 
 Key:
 - code: String, the country code. Follows the ISO 3166-1 alpha2 standard
 - raw: The raw value extracted for the sentence
 */
public class Nationality : Mappable, CustomStringConvertible
{
    public var short : String = ""
    public var long : String = ""
    public var country : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Nationality(short : \(short), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        short       <- map["short"]
        long        <- map["long"]
        country     <- map["country"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Number
 
 Examples :	one thousand, 3, 9,000
 
 Key:
 - value: Integer, the number
 - raw: The raw value extracted for the sentence
 */
public class Number : Mappable, CustomStringConvertible
{
    public var scalar : Int = 0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Number(scalar : \(scalar), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        scalar      <- map["scalar"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Ordinal
 
 Examples :	3rd, 158th, last
 
 Key:
 - value: Integer, the number behind the ordinal
 - raw: The raw value extracted for the sentence
 */
public class Ordinal : Mappable, CustomStringConvertible
{
    public var rank : Int = 0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Ordinal(rank : \(rank), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        rank        <- map["rank"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Organization
 
 Examples :	Lehman Brothers, NASA
 
 Key:
 - value: String, the downcased entity extracted
 - raw: The raw value extracted for the sentence
 */
public class Organization : Mappable, CustomStringConvertible
{
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Organization(raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Percent
 
 Examples :	99%, two percent, one out of three
 
 Key:
 - value: Float, the countable
 - unit: String, the quantifier. Can be % (percent), etc.
 - raw: The raw value extracted for the sentence
 */
public class Percent : Mappable, CustomStringConvertible
{
    public var scalar : Float = 0.0
    public var unit : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Percent(scalar : \(scalar), unit : \(unit), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        scalar      <- map["scalar"]
        unit        <- map["unit"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Person
 
 Examples :	John Smith, David H. Doe
 
 Key:
 - value: String, the downcased entity extracted
 - raw: The raw value extracted for the sentence
 */
public class Person : Mappable, CustomStringConvertible
{
    public var fullname : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Person(fullname : \(fullname), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        fullname    <- map["fullname"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Phone
 
 Examples :	+91-22-265 9000, 64 4 437-4746, 0682753582, (123) 123 1234
 
 Key:
 - value: String, the downcased entity extracted
 - raw: The raw value extracted for the sentence
 */
public class Phone : Mappable, CustomStringConvertible
{
    public var number : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Phone(number : \(number), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        number      <- map["number"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Pronoun
 
 Examples :	I, we, it
 
 Key:
 - person: Integer, the person of the pronoun. Can be 1, 2 or 3
 - number: String, the number of the pronoun. Can be singular or plural
 - gender: String, the gender of the pronoun. Can be unknown, neutral, male of female
 - raw: The raw value extracted for the sentence
 */
public class Pronoun : Mappable, CustomStringConvertible
{
    public var person : Int = 0
    public var number : String = ""
    public var gender : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Pronoun(person : \(person), number : \(number), gender : \(gender), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        person      <- map["person"]
        number      <- map["number"]
        gender      <- map["gender"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Set
 
 Examples :	every Sunday, each day
 
 Key:
 - next: Integer, the timestamp representing the next occurence
 - grain: String, the delay to repeat. Can be a combination of a number and a quantifier (day, week, month, year), just a quantifier, or even a day name.
 - raw: The raw value extracted for the sentence
 */
public class Set : Mappable, CustomStringConvertible
{
    public var next : String = ""
    public var frequencey : String = ""
    public var interval : Int = 0
    public var rrule : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Set(next : \(next), frequencey : \(frequencey), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        next        <- map["next"]
        frequencey  <- map["frequencey"]
        interval    <- map["interval"]
        rrule       <- map["rrule"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Sort
 
 Examples :	most valuable, best, least affordable
 
 Key:
 - value: String, the criterion to sort
 - order: String, the order to sort (MySQL inspired)
 - raw: The raw value extracted for the sentence
 */
public class Sort : Mappable, CustomStringConvertible
{
    public var order : String = ""
    public var criterion : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Sort(order : \(order), criterion : \(criterion), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        order       <- map["order"]
        criterion   <- map["criterion"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Speed
 
 Examples :	7 mph, 10 km/h, seven meters per second
 
 Key:
 - value: Float, the countable
 - unit: String, the quantifier. Can be km/h (kilometer per hour), mi/s (miles per second), kt (knots), etc.
 - raw: The raw value extracted for the sentence
 */
public class Speed : Mappable, CustomStringConvertible
{
    public var scalar : Float = 0.0
    public var unit : String = ""
    public var mps : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Speed(scalar : \(scalar), unit : \(unit), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        scalar      <- map["scalar"]
        unit        <- map["unit"]
        mps         <- map["mps"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Temperature
 
 Examples :	7 mph, 10 km/h, seven meters per second
 
 Key:
 - value: Float, the countable
 - unit: String, the quantifier. Can be C (Celsius), K (Kelvin), F (Fahrenheit), R (Rankine), etc.
 - raw: The raw value extracted for the sentence
 */
public class Temperature : Mappable, CustomStringConvertible
{
    public var scalar : Float = 0.0
    public var unit : String = ""
    public var celsius : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Temperature(scalar : \(scalar), unit : \(unit), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        scalar      <- map["scalar"]
        unit        <- map["unit"]
        celsius     <- map["celsius"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Url
 
 Examples :	https://cai.tools.sap, localhost:9000, api.cai.tools.sap/request
 
 Key:
 - value: String, the downcased entity extracted
 - raw: The raw value extracted for the sentence
 */
public class Url : Mappable, CustomStringConvertible
{
    public var scheme : String = ""
    public var host : String = ""
    public var path : String = ""
    public var params : String = ""
    public var query : String = ""
    public var fragment : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Url(host : \(host), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        scheme      <- map["scheme"]
        host        <- map["host"]
        path        <- map["path"]
        params      <- map["params"]
        query       <- map["query"]
        fragment    <- map["fragment"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Volume
 
 Examples :	30 liters, two barrels, ½ tbsp
 
 Key:
 - value: Float, the countable
 - unit: String, the quantifier. Can be l (liters), tsp (teaspoons), pt (pints), etc.
 - raw: The raw value extracted for the sentence
 */
public class Volume : Mappable, CustomStringConvertible
{
    public var scalar : Float = 0.0
    public var unit : String = ""
    public var liters : Float = 0.0
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Volume(scalar : \(scalar), unit : \(unit), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        scalar      <- map["scalar"]
        unit        <- map["unit"]
        liters      <- map["liters"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

/**
 Struct Custom
 
 Key:
 - value: the value
 - raw: The raw value extracted for the sentence
 */
public class Custom : Mappable, CustomStringConvertible
{
    public var value : String = ""
    public var raw : String = ""
    public var confidence : Float = 0.0
    
    public var description: String
    {
        return "Custom(value : \(value), raw : \(raw))"
    }
    
    required convenience public init?(map: Map) {
        self.init()
        mapping(map: map)
    }
    
    // Mappable
    public func mapping(map: Map) {
        value       <- map["value"]
        raw         <- map["raw"]
        confidence  <- map["confidence"]
    }
}

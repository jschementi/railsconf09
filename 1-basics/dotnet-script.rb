require 'mscorlib'
include System

System.constants.sort

class_names = System.constants.sort.grep /^[A-C]/

classes = class_names.map { |c| eval c }

classes.first.to_clr_type.is_interface

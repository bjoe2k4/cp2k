!--------------------------------------------------------------------------------------------------!
!   CP2K: A general program to perform molecular dynamics simulations                              !
!   Copyright 2000-2023 CP2K developers group <https://cp2k.org>                                   !
!                                                                                                  !
!   SPDX-License-Identifier: GPL-2.0-or-later                                                      !
!--------------------------------------------------------------------------------------------------!

! **************************************************************************************************
!> \brief parse cp2k input files
!> \par History
!>      06.2004 created [fawzi]
!>      03.2014 moved into separate module [Ole Schuett]
!> \author fawzi
! **************************************************************************************************
MODULE input_cp2k_read
   USE cp_para_types,                   ONLY: cp_para_env_type
   USE cp_parser_types,                 ONLY: cp_parser_type,&
                                              empty_initial_variables,&
                                              parser_create,&
                                              parser_release
   USE cp_units,                        ONLY: cp_unit_set_create,&
                                              cp_unit_set_release,&
                                              cp_unit_set_type
   USE input_parsing,                   ONLY: section_vals_parse
   USE input_section_types,             ONLY: section_type,&
                                              section_vals_create,&
                                              section_vals_type,&
                                              typo_match_section
#include "./base/base_uses.f90"

   IMPLICIT NONE
   PRIVATE

   LOGICAL, PRIVATE, PARAMETER :: debug_this_module = .TRUE.
   CHARACTER(len=*), PARAMETER, PRIVATE :: moduleN = 'input_cp2k_read'

   PUBLIC :: read_input, empty_initial_variables

CONTAINS

! **************************************************************************************************
!> \brief reads the cp2k input from the given filepath and returns a section_vals
!>      containing the input
!> \param input_declaration ...
!> \param file_path path where the input should be read
!> \param initial_variables ...
!> \param para_env ...
!> \return ...
!> \author fawzi
! **************************************************************************************************
   FUNCTION read_input(input_declaration, file_path, initial_variables, para_env) RESULT(res)
      TYPE(section_type), POINTER                        :: input_declaration
      CHARACTER(len=*), INTENT(in)                       :: file_path
      CHARACTER(len=*), DIMENSION(:, :)                  :: initial_variables
      TYPE(cp_para_env_type), POINTER                    :: para_env
      TYPE(section_vals_type), POINTER                   :: res

      CHARACTER(len=*), PARAMETER                        :: routineN = 'read_input'

      INTEGER                                            :: handle
      TYPE(cp_parser_type)                               :: cpparser
      TYPE(cp_unit_set_type)                             :: default_units

      CALL timeset(routineN, handle)
      NULLIFY (res)
      CALL section_vals_create(res, input_declaration)
      CALL parser_create(cpparser, initial_variables=initial_variables, file_name=file_path, &
                         para_env=para_env)
      CALL cp_unit_set_create(default_units, "OUTPUT")
      typo_match_section => input_declaration
      CALL section_vals_parse(res, cpparser, root_section=.FALSE., &
                              default_units=default_units)
      typo_match_section => NULL()
      CALL cp_unit_set_release(default_units)
      CALL parser_release(cpparser)
      CALL timestop(handle)
   END FUNCTION read_input

END MODULE input_cp2k_read

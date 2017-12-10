module ManageIQ
  module Providers
    module Hawkular
      module Roles
        module HasMachineId
          def machine_id
            properties[:machine_id]
          end

          def possible_machine_ids
            [machine_id, alternate_machine_id, dashed_machine_id]
          end

          # See the BZ #1294461 [1] for a more complete background.
          # Here, we'll try to adjust the machine ID to the format from that bug. We expect to get a string like
          # this: 2f68d133a4bc4c4bb19ecb47d344746c . For such string, we should return
          # this: 33d1682f-bca4-4b4c-b19e-cb47d344746c .The actual BIOS UUID is probably returned in upcase, but other
          # providers store it in downcase, so, we let the upcase/downcase logic to other methods with more
          # business knowledge.
          # 1 - https://bugzilla.redhat.com/show_bug.cgi?id=1294461
          def alternate_machine_id
            return nil if machine_id.nil? || machine_id.length != 32 || machine_id[/\H/]

            @alternate_machine_id ||= [
              swap_part(machine_id[0, 8]),
              swap_part(machine_id[8, 4]),
              swap_part(machine_id[12, 4]),
              machine_id[16, 4],
              machine_id[20, 12],
            ].join('-')
          end

          # Add standard dashes to a machine GUID that doesn't have dashes.
          #
          # @param machine_id [String] the GUI to which dashes should be added. The string
          #   is validated to be 32 characters long and to only contain valid hexadecimal
          #   digits. If any validations fail, nil is returned.
          # @return [String] the GUI with dashed added at standard locations.
          def dashed_machine_id
            return nil if machine_id.nil? || machine_id.length != 32 || machine_id[/\H/]

            @dashed_machine_id ||= [
              machine_id[0, 8],
              machine_id[8, 4],
              machine_id[12, 4],
              machine_id[16, 4],
              machine_id[20, 12]
            ].join('-')
          end

          def swap_part(part)
            # here, we receive parts of an UUID, split into an array with 2 chars each element, and reverse the invidual
            # elements, joining and reversing the final outcome
            # for instance:
            # 2f68d133 -> ["2f", "68", "d1", "33"] -> ["f2", "86", "1d", "33"] -> f2861d33 -> 33d1682f
            part.scan(/../).collect(&:reverse).join.reverse
          end
        end
      end
    end
  end
end

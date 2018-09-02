
Imports Microsoft.MetadirectoryServices
Imports System.Xml

Public Class MVExtensionObject
    Implements IMVSynchronization

    ' These two variables are initialized based on a xml configuration file
    ' The values are read during the Initialize() method of the Rules Extension
    '
    Dim DaysAfterDeletePendingInvites As Double
    Dim DaysAfterDeleteInactiveGuests As Double
    Dim B2BUserConnectorName As String

    Public Sub Initialize() Implements IMVSynchronization.Initialize

        ' Modify path to your solution xml config path below
        Const SCENARIO_XML_CONFIG As String = "C:\PSMA\B2BHouseKeepSolution.xml"

        Dim config As XmlDocument = New XmlDocument
        config.Load(SCENARIO_XML_CONFIG)
        Dim rnode As XmlNode = config.SelectSingleNode("B2BHouseKeepSolution/MVExtension")

        DaysAfterDeletePendingInvites = Convert.ToDouble(rnode.SelectSingleNode("DaysAfterDeletePendingInvites").InnerText)
        DaysAfterDeleteInactiveGuests = Convert.ToDouble(rnode.SelectSingleNode("DaysAfterDeleteInactiveGuests").InnerText)
        B2BUserConnectorName = rnode.SelectSingleNode("B2BUserConnectorName").InnerText

    End Sub

    Public Sub Terminate() Implements IMVSynchronization.Terminate
        ' TODO: Add termination code here
    End Sub

    Public Sub Provision(ByVal mventry As MVEntry) Implements IMVSynchronization.Provision
        Dim numConnectors As Integer
        Dim csentry As CSEntry
        Dim B2BUserMA As ConnectedMA
        Dim createdTime As Date
        Dim currentTime As Date = DateTime.Now()
        Dim DateDiff As TimeSpan

        ' Deprovision (delete) B2B user after defined days
        If mventry.ObjectType = "B2BUser" Then
            B2BUserMA = mventry.ConnectedMAs(B2BUserConnectorName)
            numConnectors = B2BUserMA.Connectors.Count

            If 1 = numConnectors Then
                csentry = B2BUserMA.Connectors.ByIndex(0)

                ' Deprovision Pending B2B Invites after defined days
                If mventry("InviteStatus").IsPresent AndAlso mventry("InviteStatus").Value = "PendingAcceptance" Then
                    createdTime = Convert.ToDateTime(mventry("createdTime").Value)
                    DateDiff = currentTime.Subtract(createdTime)
                    If DateDiff.Days >= DaysAfterDeletePendingInvites Then
                        csentry.Deprovision()
                    End If
                End If

                ' Deprovision B2B Guests when Custom LastLogin is older then defined days
                If mventry("LastLogin").IsPresent Then
                    createdTime = Convert.ToDateTime(mventry("LastLogin").Value)
                    DateDiff = currentTime.Subtract(createdTime)
                    If DateDiff.Days >= DaysAfterDeleteInactiveGuests Then
                        csentry.Deprovision()
                    End If
                End If

            End If
        End If

    End Sub

    Public Function ShouldDeleteFromMV(ByVal csentry As CSEntry, ByVal mventry As MVEntry) As Boolean Implements IMVSynchronization.ShouldDeleteFromMV
        ' TODO: Add MV deletion code here
        Throw New EntryPointNotImplementedException()
    End Function
End Class

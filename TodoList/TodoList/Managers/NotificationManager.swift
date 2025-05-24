import UserNotifications
import CoreData

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // Request notification permission
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error requesting notification authorization: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(granted)
            }
        }
    }
    
    // Schedule a notification for a todo item
    func scheduleNotification(for item: Item) {
        // Remove any existing notifications for this item
        removeNotification(for: item)
        
        // Only schedule if the item has a due date and is not completed
        guard let dueDate = item.dueDateTime, !item.isCompleted else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "🔔 Task Due: \(item.title)"
        
        // Format the due date for the notification body
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dueDateString = formatter.string(from: dueDate)
        
        content.body = "Due: \(dueDateString)"
        content.sound = .default
        
        // Set up the trigger for the notification
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Create a unique identifier for this notification
        let identifier = "todo_\(item.objectID.uriRepresentation().absoluteString)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    // Remove a notification for a specific todo item
    func removeNotification(for item: Item) {
        let identifier = "todo_\(item.objectID.uriRepresentation().absoluteString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // Remove all notifications
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // Schedule all active todo items with due dates
    func scheduleNotifications(for items: [Item]) {
        // First remove all existing notifications
        removeAllNotifications()
        
        // Request permission if needed
        requestAuthorization { granted in
            if granted {
                // Schedule notifications for all items with due dates
                for item in items where item.dueDate != nil && !item.isCompleted {
                    self.scheduleNotification(for: item)
                }
            }
        }
    }
    
    // Schedule a notification for a recurring task
    func scheduleRecurringNotification(for item: Item) {
        guard item.isRecurring, let dueDate = item.dueDateTime, !item.isCompleted else { return }
        
        // Schedule the initial notification
        scheduleNotification(for: item)
        
        // If the task is overdue, schedule the next occurrence
        if dueDate < Date(), let nextDate = item.nextDueDate() {
            // Preserve the time component when scheduling the next occurrence
            let calendar = Calendar.current
            let timeComponents = calendar.dateComponents([.hour, .minute], from: item.dueTime ?? Date())
            
            var nextDateComponents = calendar.dateComponents([.year, .month, .day], from: nextDate)
            nextDateComponents.hour = timeComponents.hour
            nextDateComponents.minute = timeComponents.minute
            
            if let nextDateTime = calendar.date(from: nextDateComponents) {
                let nextItem = item
                nextItem.dueDate = nextDateTime
                nextItem.dueTime = nextDateTime
                scheduleNotification(for: nextItem)
            }
        }
    }
}

// Helper extension to schedule notifications when an item is created or updated
extension Item {
    func scheduleNotification() {
        if isRecurring {
            NotificationManager.shared.scheduleRecurringNotification(for: self)
        } else {
            NotificationManager.shared.scheduleNotification(for: self)
        }
    }
    
    func removeNotification() {
        NotificationManager.shared.removeNotification(for: self)
    }
}

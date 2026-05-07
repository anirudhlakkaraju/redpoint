//
//  Migrations.swift
//  Redpoint
//
//  Created by Anirudh Lakkaraju on 5/3/26.
//

import GRDB

enum Migrations {
    static func run(on pool: DatabasePool) throws {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("v1_initial_schema") { db in
            try db.create(table: "sessions") {t in
                t.autoIncrementedPrimaryKey("id")
                t.column("date", .text).notNull()
                t.column("sport", .text).notNull()
                t.column("duration_minutes", .integer)
                t.column("notes", .text).notNull().defaults(to: "")
                t.column("feel", .integer)
                t.column("source", .text).notNull()
                t.column("image_path", .text)
                t.column("created_at", .text).notNull()
                t.column("updated_at", .text).notNull()
            }
            
            try db.create(table: "running") {t in
                t.autoIncrementedPrimaryKey("id")
                t.column("session_id", .integer).notNull()
                    .references("sessions", onDelete: .cascade)
                t.column("distance_miles", .real)
                t.column("time", .text)
                t.column("pace", .text)
                t.column("notes", .text)
            }
            
            try db.create(table: "weight_training") {t in
                t.autoIncrementedPrimaryKey("id")
                t.column("session_id", .integer).notNull()
                    .references("sessions", onDelete: .cascade)
                t.column("target", .text)
                t.column("notes", .text)
            }
            
            try db.create(table: "exercises") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("wt_training_session_id", .integer).notNull()
                    .references("weight_training", onDelete: .cascade)
                t.column("name", .text).notNull()
                t.column("sets", .integer)
                t.column("reps", .integer)
                t.column("weight", .real)
                t.column("weight_unit", .text)
                t.column("notes", .text)
            }
            
            try db.create(table: "climbing") {t in
                t.autoIncrementedPrimaryKey("id")
                t.column("session_id", .integer).notNull()
                    .references("sessions", onDelete: .cascade)
                t.column("type", .text)
            }
            
            try db.create(table: "climbing_routes") {t in
                t.autoIncrementedPrimaryKey("id")
                t.column("climbing_session_id", .integer).notNull()
                    .references("climbing", onDelete: .cascade)
                t.column("name", .text).notNull()
                t.column("sent", .integer).notNull().defaults(to: 0)
                t.column("attempts", .integer).notNull().defaults(to: 1)
                t.column("grade", .text)
                t.column("notes", .text)
            }
            
            try db.create(table: "yoga") {t in
                t.autoIncrementedPrimaryKey("id")
                t.column("session_id", .integer).notNull()
                    .references("sessions", onDelete: .cascade)
                t.column("style", .text)
                t.column("instructor", .text)
                t.column("notes", .text)
            }
            
            try db.create(table: "yoga_poses") {t in
                t.autoIncrementedPrimaryKey("id")
                t.column("yoga_session_id", .integer).notNull()
                    .references("yoga", onDelete: .cascade)
                t.column("name", .text).notNull()
            }
        }
        
        try migrator.migrate(pool)
    }
}

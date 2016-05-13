//
//  PieChartStatisticViewController.swift
//  homefinancing
//
//  Created by 辰 宫 on 5/2/16.
//  Copyright © 2016 wph. All rights reserved.
//

class PieChartStatisticViewController: UIViewController {
    
    @IBOutlet weak var pieChartView :PNPieChart!
    
    var titleText = "消费分布"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = titleText
        
//        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:550 color:[UIColor colorWithRed:218.0 / 255.0 green:17.0 / 255.0 blue:29.0 / 255.0 alpha:1.0f] description:@"日用品"],
//        [PNPieChartDataItem dataItemWithValue:3000 color:[UIColor colorWithRed:252.0 / 255.0 green:140.0 / 255.0 blue:108.0 / 255.0 alpha:1.0f] description:@"房贷"],
//        [PNPieChartDataItem dataItemWithValue:300 color:[UIColor colorWithRed:248.0 / 255.0 green:236.0 / 255.0 blue:59.0 / 255.0 alpha:1.0f] description:@"交通费"],
//        [PNPieChartDataItem dataItemWithValue:2000 color:[UIColor colorWithRed:230.0 / 255.0 green:151.0 / 255.0 blue:42.0 / 255.0 alpha:1.0f] description:@"奶粉"],
//        [PNPieChartDataItem dataItemWithValue:2500 color:[UIColor colorWithRed:121.0 / 255.0 green:157.0 / 255.0 blue:246.0 / 255.0 alpha:1.0f] description:@"其他消费"],
//        [PNPieChartDataItem dataItemWithValue:360 color:[UIColor colorWithRed:116.0 / 255.0 green:252.0 / 255.0 blue:218.0 / 255.0 alpha:1.0f] description:@"水电费"]
//        ];
//        
//        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 135, 200.0, 200.0) items:items];
//        self.pieChart.descriptionTextColor = [UIColor whiteColor];
//        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
//        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
//        self.pieChart.showAbsoluteValues = NO;
//        self.pieChart.showOnlyValues = NO;
//        [self.pieChart strokeChart];
//        
//        self.pieChart.legendStyle = PNLegendItemStyleSerial;
//        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
//        self.pieChart.legendFontColor = [UIColor grayColor];
//        
//        UIView *legend = [self.pieChart getLegendWithMaxWidth:SCREEN_WIDTH * 0.9];
//        [legend setFrame:CGRectMake(SCREEN_WIDTH/2 - legend.frame.size.width/2, 350, legend.frame.size.width, legend.frame.size.height)];
//        [self.view addSubview:legend];
//        
//        [self.view addSubview:self.pieChart];
        var items:[PNPieChartDataItem] = []
        let item1 = PNPieChartDataItem()
        item1.color = UIColor.redColor()
        item1.value = 550
        items.append(item1)
        let item2 = PNPieChartDataItem()
        item2.color = UIColor.yellowColor()
        item2.value = 2000
        items.append(item2)
        
        
//        let pieChart:PNPieChart = PNPieChart(frame:CGRect(x:SCREEN_WIDTH/2 - pieChartWidth/2, y:135, width:200.0, height:200.0))
        pieChartView.updateChartData(items)
//
//        self.view.addSubview(pieChart)
    }
    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        let navigationBar = self.navigationController?.navigationBar
//        navigationBar?.hideBottomHairline()
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        let navigationBar = self.navigationController?.navigationBar
//        navigationBar?.showBottomHairline()
//    }
}
